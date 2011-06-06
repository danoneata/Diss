function [E, lambda] = PCA(X)

  % Compute mean:
  mu = mean(X, 2);  
  
  % Center data:
  X =  bsxfun(@minus, X, mu);
  
  % Compute eigenvectors and eigenvalues of the covariance matrix:
  [V D] = eig(X*X');
  lambda = diag(D)';
  
  % Sort the eigenvectors in the descending order of the eigenvalues:
  [lambda idx] = sort(lambda, 'descend');
  E = V(:,idx);
    
end