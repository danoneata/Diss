function [score, predictions] = nca_classification(X, c, Q, l)

  [~, M] = size(Q);

  dd = exp(-square_dist(X, Q));
  
  fn = @sum;
  [rowidx, colidx] = ndgrid(c, 1:M);
  Mu = accumarray([rowidx(:) colidx(:)], dd(:), [], fn);
  [~, idxs_min] = max(Mu, [], 1);
  
  score = 1 - nnz(idxs_min - l)/M;
  predictions = idxs_min;

end