function score = loocv(X,c)

  [D,N] = size(X);
  score = 0;

  for i = 1:N,
    X2 = X;
    X2(:,i) = [];
    [d_min idx_min] = NN_naive_search(X2,X(:,i));
    
    if idx_min >= i,
      idx_min = idx_min + 1;
    end
    
    d = sum((X(:,idx_min)-X(:,i)).^2,1);
    assert(d_min==d);
    
    if c(idx_min) == c(i),
      score = score + 1;
    end
  end

end