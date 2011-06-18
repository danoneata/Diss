
function E  = LDA(X, c, d)
%LDA Linear Discriminant Analysis or Fisher Linear's Discriminant
%
%     E = LDA(X, c, d)
%
% Inputs:
%           X DxN data. D is the dimensionality and N is the number of
%             points.
%           c 1xN label for each of the N points.
%           d 1x1 dimensionality to reduce the original data. If 
%           unspecified, d is equal to D.
%
% Outputs:
%           E dxD projection matrix to obtain the LDA transform.

% Dan Oneata, June 2011

  [D N] = size(X);
  Sw = zeros(D);

  if ~exist('d','var'),
    d = D;
  end
  
  if D > N,
    EE = PCA(X);
    X = EE*X;
    Sw = zeros(N);
    if d > N,
      d = N;
    end
  end
  
  % Compute mean for each class:
  fn = @mean;
  [rowidx, colidx] = ndgrid(1:size(X,1), c);
  Mu = accumarray([rowidx(:) colidx(:)], X(:), [], fn);
  
  cc = unique(c);
  nr_classes = numel(cc);
  
  % Compute within variance matrix:
  for i = 1:nr_classes,
    xx = X(:, c==cc(i));
    xx = bsxfun(@minus, xx, Mu(:,i));
    Sw = Sw + xx*xx';
  end
  
  X = bsxfun(@minus, X, mean(X,2));
  St = X*X';
  
  % Compute between variance matrix:
  Sb = St - Sw;
  
  % Compute eigenvectors and eigenvalues of the covariance matrix:
  [V DD] = eig(Sb,Sw);
  lambda = diag(DD)';
  
  % Sort the eigenvectors in the descending order of the eigenvalues:
  [~, idx] = sort(lambda, 'descend');
  E = V(:,idx);
  E = E(:,1:d)';
  % Normalize eigenvectors such that they are orthonormal:
  E = bsxfun(@rdivide,E,sum(E.^2,2));
  if D > N,
    E = E*EE;
  end
    
end