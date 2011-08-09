function [f, df] = nca_obj_simple(A, X, c, P1, P2)
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
  
  df = zeros(size(A,1),D);
    
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
    K = bsxfun(@rdivide, kern_all, kern_sum);
    K = max(K, eps);
    K = K';
    for i=1:N,    
        x_ik = bsxfun(@minus,X(:,i),X); 
        Ax_ik = bsxfun(@minus,AX(:,i),AX);
        x_ij = x_ik(:,c==c(i));
        Ax_ij = Ax_ik(:,c==c(i));

        % Update gradient value:
        df = df + p(i) * bsxfun(@times, K(i,:), Ax_ik) * x_ik' ...
            - bsxfun(@times, K(i,c==c(i)), Ax_ij) * x_ij';
    end
    df = -2*df;
    df = df(:);
  end
    
end