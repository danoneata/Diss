function cv_score = nca_cv_score(A, X, c, X_cv, c_cv)

  cv_score = 0;

  [D N] = size(X);
  N_cv  = size(X_cv,2);
  A = reshape(A,[],D);
  
  AX = A*X;
  AX_cv = A*X_cv;
    
  for i=1:N_cv,
    % Compute denominator---sum of the distances between the current 
    % point x_i and all the other points x_k, k~=i:
    dist_all = exp( -sum( bsxfun(@minus,AX_cv(:,i),AX).^2, 1 ) );
    sum_dist_all = sum(dist_all);

    % Compute numerator---sum of the distances between the current 
    % point x_i and its neighbours x_j:
    dist_neigh = dist_all(c==c_cv(i));
    sum_dist_neigh = sum(dist_neigh);
   
    p_i = sum_dist_neigh / sum_dist_all;

    % Update function value:
    cv_score = cv_score + max(p_i,eps);
  end

end