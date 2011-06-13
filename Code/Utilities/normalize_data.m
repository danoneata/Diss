function [Y,transf] = normalize_data(X)

  transf.mean = mean(X,2);
  transf.std  = diag(1./std(X,0,2));

  Y = bsxfun(@minus, X, mean(X,2));
  Y = diag(1./std(X,0,2))*Y;  
  
  Y = max(Y,1e-6);

end