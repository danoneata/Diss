function [Y] = normalize_data(X)

  Y = bsxfun(@minus, X, mean(X,2));
  Y = diag(1./std(X,0,2))*Y;

end