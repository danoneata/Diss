function [f, df] = nca_obj(A, X, c)
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

  f  = 0;
  df = 0;

  [D N] = size(X);
  A = reshape(A,[],D);
  C = repmat(c,[D 1]);
    
  for i=1:N,
    % Compute denominator---sum of the distances between the current 
    % point x_i and all the other points x_k, k~=i:
    AX = A*X;
    Axi = A*X(:,i);
    dist_all = exp( -sum( bsxfun(@minus,Axi,AX).^2, 1 ) );
    dist_all(i) = 0;
    sum_dist_all = sum(dist_all);

    % Compute numerator---sum of the distances between the current 
    % point x_i and its neighbours x_j:
    dist_neigh = dist_all(c==c(i));
    sum_dist_neigh = sum(dist_neigh);
    
    if sum_dist_all == 0,
%       p_i = exp( log_sum_exp(Axi, AX, c, c(i)) );
      p_i = eps;
    else
      p_i = sum_dist_neigh / sum_dist_all;
    end

    % Update function value:
    f = f - p_i;
    
    if nargout > 1,
      x_ik = bsxfun(@minus,X(:,i),X); 
      x_ij = reshape(x_ik(C==c(i)),D,[]);

      % Update gradient value:
      df = df + p_i * bsxfun(@times,dist_all,x_ik) * x_ik' / sum_dist_all ...
          - bsxfun(@times,dist_neigh,x_ij) * x_ij' / sum_dist_all;
    end
  end
    
  if nargout > 1,
    df = -2*A*df;
    df = df(:);
  end
    
end

function log_p_i = log_sum_exp(Axi, AX, c, ci)

  dd = sum( bsxfun(@minus,Axi,AX).^2, 1 );
  L = max(dd);
  dd2 = dd(c==ci);
  log_p_i = log(sum(exp( L - dd ))) - log(sum(exp( L - dd2 )));

end