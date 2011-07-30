function [Y,transf] = normalize_data(X, sw)

  if ~exist('sw','var'),
    sw = 0;
  end

  if sw == 1,
    transf.mean = mean(X,2);
    transf.std  = eye(size(X,1));
    Y = bsxfun(@minus, X, mean(X,2));
  else
    sd = std(X,0,2);
    sd(sd == 0) = 1;

    transf.mean = mean(X,2);
    transf.std  = diag(1./sd);

    Y = bsxfun(@minus, X, mean(X,2));
    Y = diag(1./sd)*Y;  
  end
end