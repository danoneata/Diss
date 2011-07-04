function [output] = nca_cls_cs_back(X, c, Q, l, A, moments, Nc, mix_prop)
%NCA_CLS_CS_BACK Classification using NCA with compact support kernels and
%background distribution.
%
%     [output] = nca_cls_cs_back(X, c, Q, l, A, moments, Nc, mix_prop)
%
% Inputs:
%                X DxN training data.
%                c 1xN labels for the traning data. 
%                Q DxM test data.
%                l 1xM labels for the test data. If unspecified, there are
%                      returned the predicted labels. Else there is 
%                      returned the score.
%                A dXD projection matrix A. If unspecified, A = eye(D).
%          moments 1xK structure with the mean and cov for each class. If
%                      unspecifed, no background distribution is computed.
%               Nc 1xK number of points from each class. If unspecified,
%                      this is computed from the given data.
%         mix_prop 1x1 number that represents the mixing proportion of the
%                      compact support kernels and the background distribution.
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
  dd = 15/16*(1 - dd).^2;
  dd( dd > 1 ) = 0;
  
  fn = @sum;
  [rowidx, colidx] = ndgrid(c, 1:M);
  p_xc = accumarray([rowidx(:) colidx(:)], dd(:), [], fn);
  p_cx = mix_prop * p_xc / N;
  
  if exist('moments','var') && ~isempty(moments),
    bd = (1 - mix_prop) * multivariate_gaussian(Q, c, moments, A) / N;
    bd = bsxfun(@times, bd, Nc');
    p_cx = p_cx + bd;
  end
  
  [dummy, idxs_min] = max(p_cx, [], 1);
  
  if ~exist('l','var') || isempty(l),
    output = idxs_min;
  else
    output = 1 - nnz(idxs_min - l)/M;
  end
  
end