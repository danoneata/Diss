function [f, df] = nca_obj_simple(A, X, c)
%NCA_OBJ Neighbourhood Component Analysis objective function. Returns
%function value and the first order derivatives.
%
%     [f, df] = nca_obj(A, X, c)
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
  
  df = zeros(size(A));
    
  AX = A*X;
  dist_all = square_dist(AX,AX);
  kern_all = exp(-dist_all);
  kern_all(1:N+1:end) = 0;
  
  % Compute distance to the neighbours:
  row_dict = logical(eye(max(c)));
  neigh_mask = row_dict(c,c);
  kern_neigh = sum(kern_all.*neigh_mask, 1);

  kern_sum = sum(kern_all, 1);
  p = kern_neigh ./ kern_sum;
  p = max(p, eps);
  
  % Update function value:
  f = - sum(p);
  
  if nargout > 1, 
    for i=1:N,    
        x_ik = bsxfun(@minus,X(:,i),X); 
        x_ij = reshape(x_ik(C==c(i)),D,[]);

        % Update gradient value:
        df = df + p(i) * bsxfun(@times, kern_all(i,:), x_ik) * x_ik' / kern_sum(i) ...
            - bsxfun(@times, kern_all(i,c==c(i)), x_ij) * x_ij' / kern_sum(i);
    end
    df = -2*A*df;
    df = df(:);
  end
    
end