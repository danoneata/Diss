function [f, df] = nca_obj_cs_back(A, X, c, Nc, moments, mix_prop)
%NCA_OBJ Neighbourhood Component Analysis with compact support kernel and
%Gaussian background distribution. The used kernel is k(d) = (1-d^2)^2, for 
%d \in \Re. 
%Returns function value and the first order derivatives.
%
%     [f, df] = nca_obj_cs(A, X, c, Nc, moments)
%
% Inputs:
%       A dxD - projection matrix (d <= D).
%       X DxN - data.
%       c 1xN - class labels.
%      Nc 1xC - number of points in each class.
% moments 1xC - structure that contains the sample mean and covariance 
%               corresponding to the points in each of the C classes.
%
% Outputs:
%       f 1x1   - function value. 
%      df 1xD*d - derivative values.

% Dan Oneata, June 2011

  [D N] = size(X);
  A = reshape(A,[],D);
  C = repmat(c,[D 1]);
  K = max(c);
  if ~exist('mix_prop','var'),
    pp = 0.95;
  else
    pp = mix_prop;
  end

  norm_fact = pp/N;
  p_c = Nc'/N * (1-pp);
  
  df = zeros(size(A));
  
  % Compute distances between all the points:
  AX = A*X;
  dist_all = square_dist(AX,AX);
  
  % Apply kernel:
  d_kern_all = (1 - dist_all);
  d_kern_all(1:N+1:end) = 0;
  d_kern_all( dist_all > 1 ) = 0;
  
  % Kernel values between all points---NxN matrix:
  kern_all = 15/16*d_kern_all.^2;
  kern_all = bsxfun(@times, kern_all, norm_fact);
  % Kernel values needed for the derivative---NxN matrix:
  d_kern_all = 15/16*d_kern_all;
  d_kern_all = bsxfun(@times, d_kern_all, norm_fact);
  % Background distributions---KxN matrix:
  back_dist = multivariate_gaussian(X, c, moments, A);
  back_dist = bsxfun(@times, back_dist, p_c);
  
  % Construct mask to select only neighbours:
  row_dict = logical(eye(max(c)));
  neigh_mask_kern = row_dict(c,c);
  neigh_mask_back = row_dict(1:K, c);
  
  % Compute distance to the neighbours:
  kern_neigh = sum(kern_all.*neigh_mask_kern, 1);
  back_dist_neigh = sum(back_dist.*neigh_mask_back, 1);
  
  % Compute distances to all the points:
  kern_sum = sum(kern_all, 1);
  back_dist_sum = sum(back_dist, 1);
  
  p = (kern_neigh + back_dist_neigh) ./ (kern_sum + back_dist_sum);
  p = max(p, eps);
  
  % Update function value:
  f = - sum(p);
  
  % Compute gradient if required:
  if nargout > 1, 
    % Derivative of k(x_i|x_j):
    PP = bsxfun(@rdivide, d_kern_all, kern_sum + back_dist_sum);
    PP = max(PP, eps);
    PP = PP';
    
    for k = 1:K,
      moments(k).AS = A*moments(k).cov;
      moments(k).ASA = moments(k).AS*A';
      moments(k).df_back_grad_t1 = moments(k).ASA\moments(k).AS;
      moments(k).vv= moments(k).ASA\A;
    end
    
    for i=1:N,
        x_ik = bsxfun(@minus,X(:,i),X); 
        x_ij = reshape(x_ik(C==c(i)),D,[]);
        Ax_ik = A*x_ik;
        Ax_ij = A*x_ij;
        
        df_gauss_sum = zeros(size(A));
        
        for k = 1:K,
          Xm = (X(:,i) - moments(k).mean);
          v = moments(k).vv*Xm;
          % Derivative of N(Ax|A\mu, A\SigmaA):
          df_gauss = back_dist(k,i)*( - moments(k).df_back_grad_t1 + ...
                    (v*v')*moments(k).AS - v*Xm' );
          df_gauss_sum = df_gauss_sum + df_gauss;
          if k == c(i),
            df_gauss_neigh = df_gauss;
          end
        end
        
        kern_back_dist_sum = kern_sum(i) + back_dist_sum(i);
        % Update gradient value:
        df = df + p(i) * ( -4*bsxfun(@times, PP(i,:), Ax_ik) * x_ik'...
                                + df_gauss_sum / kern_back_dist_sum )...
                - ( -4*bsxfun(@times, PP(i,c==c(i)), Ax_ij) * x_ij' +...
                                df_gauss_neigh / kern_back_dist_sum );
    end
    df = df(:);
  end
%   dbstop if naninf;
  
end
