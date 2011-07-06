function [output] = nca_cls(obj, X, c, Q, l, A)
%NCA_CLS_CS_BACK Classification using NCA with compact support kernels and
%background distribution.
%
%     [output] = nca_cls(obj, X, c, Q, l, A)
%
% Inputs:
%              obj string that specifies the NCA objective function used
%                      for classification.
%                X DxN training data.
%                c 1xN labels for the traning data. 
%                Q DxM test data.
%                l 1xM labels for the test data. If unspecified, there are
%                      returned the predicted labels. Else there is 
%                      returned the score.
%                A dXD projection matrix A. If unspecified, A = eye(D).
%
% Outputs:
%           output 1x1 if l is specified: output = accuracy: number of 
%                      corrected classified points over number of total 
%                      points. 
%                  1xM if l is unspecified: output = the predicted labels.

% Dan Oneata, July 2011
  
  [D, N] = size(X);
  M = size(Q,2);

  if ~exist('A','var') || isempty(A),
    A = eye(D);
  end
  
  if ~exist('Nc','var') || isempty(Nc),
    [dummy,Nc] = unique(c);
    Nc = diff([0 Nc]);
  end
  
  % Project points into the new space:
  AX = A*X;
  AQ = A*Q;
  
  dd = square_dist(AX,AQ);
  % Apply kernel:
  if strcmp(obj, 'nca_obj_simple') || strcmp(obj, 'nca_obj'),
    dd = exp(-dd);
  elseif strcmp(obj, 'nca_obj_cs') || strcmp(obj, 'nca_obj_cs_back'),
    dkern = 15/16*(1 - dd).^2;
    dkern( dd > 1 ) = 0;
    dd = dkern;
  else
    error('Objective function incorrectly specified');
  end
    
  fn = @sum;
  [rowidx, colidx] = ndgrid(c, 1:M);
  p_xc = accumarray([rowidx(:) colidx(:)], dd(:), [], fn);
  
  if strcmp(obj, 'nca_obj_cs_back'),
    moments = get_moments(X, c);
    mix_prop = 0.9999;
    p_cx = mix_prop * p_xc / N;
    % Background distribution influence:
    
    bd = (1 - mix_prop) * multivariate_gaussian(Q, c, moments, A) / N;
    bd = bsxfun(@times, bd, Nc');
    p_cx = p_cx + bd;
    
    [dummy, idxs_min] = max(p_cx, [], 1);
  else
    [dummy, idxs_min] = max(p_xc, [], 1);
  end
  
  
  if ~exist('l','var') || isempty(l),
    output = idxs_min;
  else
    output = 1 - nnz(idxs_min - l)/M;
  end
  
end

function background_dist = multivariate_gaussian(X, c, moments, A)
%MULTIVARIATE_GAUSSIAN Computes the contribution N(AX|A\mu, A\Sigma.A').
%
%     background_dist = multivariate_gaussian(X, c, moments, A)
%
% Inputs:
%                    X DxN data.
%                    c 1xN labels. 
%              moments structure that contains mean and cov for each class. 
%                    A dxD projection matrix. 
%
% Outputs:
%     background_dist  CxN contribution for each point given each class.

% Dan Oneata, July 2011

  N = size(X,2);
  C = length(unique(c));
  background_dist = zeros(C,N);
  
  if ~exist('A','var') || isempty(A),
    AX = X;
  else  
    AX = A*X;
  end
  
  for cc = 1:C,
    if ~exist('A','var'),
      m = moments(cc).mean;
      S = moments(cc).cov;
    else
      m = A*moments(cc).mean;
      S = A*moments(cc).cov*A';
    end
    background_dist(cc,:) = gaussian_dist(AX, m, S);
  end

end

function p = gaussian_dist(X, m, S)

  D = size(X,1);
  
  Xm = bsxfun(@minus, X, m);
  XmS = Xm'/S;
  p = (2*pi)^(-D/2)*det(S)^(-1/2)*exp(-1/2*sum(XmS'.*Xm,1));

end

function moments = get_moments(X,c)
% Get moments of the data:
  D = size(X,1);
  K = max(c);
  moments(K).mean = zeros(D,1);
  moments(K).cov = zeros(D,D);
  for kk = 1:K,
    idxs = c == kk;
    moments(kk).mean = mean(X(:,idxs),2);
    moments(kk).cov = cov(X');
  end
end