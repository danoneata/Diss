function [E, lambda] = LDA(X, c)

  [c idx] = sort(c, 'ascend');
  X = X(:,idx);
  
  fn = @mean;
  [rowidx, colidx] = ndgrid(1:size(X,1), c);
  Mu = accumarray([rowidx(:) colidx(:)], X(:), [], fn);
  
  cc = unique(c);
  nr_classes = numel(cc);
  
  D = size(X,1);
  Cw = zeros(D);
  
  for i = 1:nr_classes,
    xx = X(:, c==cc(i));
    xx = bsxfun(@minus, xx, Mu(:,i));
    Cw = Cw + xx*xx';
  end
  
  Cb = 1/nr_classes * Mu * Mu';
  
  C = inv(Cw)*Cb;
  
  % Compute eigenvectors and eigenvalues of the covariance matrix:
  [V D] = eig(C*C');
  lambda = diag(D)';
  
  % Sort the eigenvectors in the descending order of the eigenvalues:
  [lambda idx] = sort(lambda, 'descend');
  E = V(:,idx);
    
end