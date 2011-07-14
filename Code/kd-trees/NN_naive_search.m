function [d_min Xmin idx_min] = NN_naive_search(X, q)

  [D N] = size(X);
  Q = repmat(q,1,N);
  
  d = sum((X - Q).^2, 1);
  [d_min idx_min] = min(d);
  Xmin = X(:,idx_min);

end