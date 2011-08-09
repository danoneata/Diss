function [f, df] = snca_obj(A, X, c, idxs)
%SNCA_OBJ Neighbourhood Component Analysis objective function for
%stochastic learning. 
%Computes function value and the first order derivatives of a few
%data-points with respect to rest of the whole data set.
%
%     [f, df] = snca_obj(A, X, c, idxs)
%
% Inputs:
%       A dxD - projection matrix (d <= D).
%       X DxN - data.
%       c 1xN - class labels.
%    idxs 1xn - indexes of the points that the function value 
%               is computed for.
%
% Outputs:
%       f 1x1   - function value. 
%      df 1xD*d - derivative values.

% Dan Oneata, June 2011

  [D N] = size(X);
  n = length(idxs);
  A = reshape(A,[],D);
  
  df = zeros(size(A,1),D);
    
  AX = A*X;
  dist_all = square_dist(AX,AX(:,idxs));
  kern_all = exp(-dist_all);
  inds = sub2ind([N n], idxs, 1:n);
  kern_all(inds) = 0;
  
  % Compute distance to the neighbours:
  row_dict = logical(eye(max(c)));
  neigh_mask = row_dict(c,c(idxs));
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
    for i=1:n,    
      ii = idxs(i);
      
      x_ik = bsxfun(@minus,X(:,ii),X); 
      Ax_ik = bsxfun(@minus,AX(:,ii),AX);
      x_ij = x_ik(:,c==c(ii));
      Ax_ij = Ax_ik(:,c==c(ii));

      % Update gradient value:      
        df = df + p(i) * bsxfun(@times, K(i,:), Ax_ik) * x_ik' ...
            - bsxfun(@times, K(i,c==c(ii)), Ax_ij) * x_ij';
    end
    df = -2*df;
    df = df(:);
  end
    
end
