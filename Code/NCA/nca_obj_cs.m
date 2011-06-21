function [f, df] = nca_obj_cs(A, X, c)
%NCA_OBJ Neighbourhood Component Analysis with compact support kernel 
%objective function. The used kernel is k(d) = (1-d^2)^2, for d \in \Re.
%Returns function value and the first order derivatives.
%
%     [f, df] = nca_obj_cs(A, X, c)
%
% Inputs:
%       A dxD - projection matrix (d <= D).
%       X DxN - data.
%       c 1xN - class labels.
%
% Outputs:
%       f 1x1   - function value. 
%      df 1xD*d - derivative values.

% Dan Oneata, June 2011

  [D N] = size(X);
  A = reshape(A,[],D);
  C = repmat(c,[D 1]);
  
  df = zeros(D);
  
  % Compute distances between all the points:
  AX = A*X;
  dist_all = square_dist(AX,AX);
  
  % Apply kernel:
  d_kern_all = (1 - dist_all);
  d_kern_all(1:N+1:end) = 0;
  d_kern_all( dist_all > 1 ) = 0;
  kern_all = d_kern_all.^2;
  
  % Compute distance to the neighbours:
  row_dict = logical(eye(max(c)));
  neigh_mask = row_dict(c,c);
  kern_neigh = sum(kern_all.*neigh_mask, 1);
  
  kern_sum = sum(kern_all, 1);
  p = kern_neigh ./ kern_sum;
  p = max(p, eps);
  
  % Update function value:
  f = - sum(p);
  
  % Compute gradient if required:
  if nargout > 1, 
    dp = d_kern_all;
    for i=1:N,
        x_ik = bsxfun(@minus,X(:,i),X); 
        x_ij = reshape(x_ik(C==c(i)),D,[]);

        % Update gradient value:
        df = df + p(i) * bsxfun(@times, dp(i,:), x_ik) * x_ik' / kern_sum(i) ...
            - bsxfun(@times, dp(i,c==c(i)), x_ij) * x_ij' / kern_sum(i);
    end
    df = -4*A*df;
    df = df(:);
  end
    
end