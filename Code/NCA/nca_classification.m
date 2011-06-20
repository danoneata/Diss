function [score, predictions] = nca_classification(X, c, Q, l)

  M = size(Q,2);

  dd = exp(-square_dist(X, Q));
  
  fn = @sum;
  [rowidx, colidx] = ndgrid(c, 1:M);
  Mu = accumarray([rowidx(:) colidx(:)], dd(:), [], fn);
  
  % Scale everything at the number of elements in a class:
  [dummy, idxs_class] = unique(c);
  nr_elem_class = diff([0 idxs_class]);
  
  Mu_scaled = bsxfun(@times, Mu, 1./nr_elem_class');
  [dummy, idxs_min] = max(Mu_scaled, [], 1);
  
  score = 1 - nnz(idxs_min - l)/M;
  predictions = idxs_min;

end