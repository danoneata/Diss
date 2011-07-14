function [Y,transf] = normalize_data(X)

  sd = std(X,0,2);
  sd(sd == 0) = 1;
  
  transf.mean = mean(X,2);
  transf.std  = diag(1./sd);

  Y = bsxfun(@minus, X, mean(X,2));
  Y = diag(1./sd)*Y;  
  
end