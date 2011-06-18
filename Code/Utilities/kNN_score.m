function [score] = kNN_score(X_test, c_test, X_train, c_train, k)

  if ~exist('k','var') || isempty('k'),
    k = 1;
  end
  
  sd = square_dist(X_train, X_test);
  [~, idxs_min] = min(sd, [], 1);
  c_predicted = c_train(idxs_min);
  score = 1 - nnz(c_predicted - c_test)/size(X_test, 2);

end