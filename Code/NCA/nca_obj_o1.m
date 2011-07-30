function [f, df] = nca_obj_o1(A, X, c, idxs)
%NCA_OBJ Neighbourhood Component Analysis objective function for option 1: 
%Computes function value and the first order derivatives of a few
%data-points wrt to rest of the remaining data set.
%
%     [f, df] = nca_obj(A, X, c, idxs)
%
% Inputs:
%       A dxD - projection matrix (d <= D).
%       X DxN - data.
%       c 1xN - class labels.
%    idxs 1xn - indexes of the points that the function value is computed
%               for.
%
% Outputs:
%       f 1x1   - function value. 
%      df 1xD*d - derivative values.

% Dan Oneata, June 2011

%   lambda = 1.5;

  [D N] = size(X);
  n = length(idxs);
  A = reshape(A,[],D);
  C = repmat(c,[D 1]);
  
  df = zeros(size(A,1),D);
    
  AX = A*X;
  dist_all = square_dist(AX,AX(:,idxs));
  kern_all = exp(-dist_all);
  inds = sub2ind([N n], idxs, 1:n);
  kern_all(inds) = 0;
%   kern_all(dist_all>20) = 0;
  % Compute distance to the neighbours:
  row_dict = logical(eye(max(c)));
  neigh_mask = row_dict(c,c(idxs));
  kern_neigh = sum(kern_all.*neigh_mask, 1);

  kern_sum = sum(kern_all, 1);
  p = kern_neigh ./ kern_sum;
  p = max(p, eps);
  
  % Update function value:
  f = - sum(p);
%   f = - sum(p) + n/N*sum(lambda.*sum(A.*A,2));
  
  if nargout > 1, 
    K = bsxfun(@rdivide, kern_all, kern_sum);
    K = max(K, eps);
    K = K';
    for i=1:n,    
      ii = idxs(i);
      
      x_ik = bsxfun(@minus,X(:,ii),X); 
      Ax_ik = A*x_ik;
      x_ij = reshape(x_ik(C==c(ii)),D,[]);
      Ax_ij = A*x_ij;

      % Update gradient value:
%       df = df + p(i) * bsxfun(@times, kern_all(:,i)', x_ik) * x_ik' / kern_sum(i) ...
%           - bsxfun(@times, kern_all(c==c(ii),i)', x_ij) * x_ij' / kern_sum(i);
      
        df = df + p(i) * bsxfun(@times, K(i,:), Ax_ik) * x_ik' ...
            - bsxfun(@times, K(i,c==c(ii)), Ax_ij) * x_ij';
    end
    df = -2*df;
%     df = -2*A*df + 2*n/N*bsxfun(@times,lambda,A);
    df = df(:);
  end
  
%   dbstop if naninf;
    
end