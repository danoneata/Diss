function E = PCA(X, d)
%PCA Principal Components Analysis computes the linear transformation that
%projects the given data into the to a new coordinate system such that the
%greatest variance by any projection of the data comes to lie on the first 
%coordinate (called the first principal component), the second greatest 
%variance on the second coordinate, and so on.
%
%     E = PCA(X, d)
%
% Inputs:
%           X DxN data. D is the dimensionality and N is the number of
%             points.
%           d 1x1 dimensionality to reduce the original data. If 
%             unspecified, d is equal to D.
%
% Outputs:
%           E dxD (or NxD if N < D, d) projection matrix to obtain the PCA 
%             transform. It contains the eigenvectors on the rows. These 
%             are sorted in descending order of their coressponding 
%             eigenvalues.

% Dan Oneata, June 2011

  [D N] = size(X);
  
  if ~exist('d','var'),
    d = D;
  end
  
  % Compute mean:
  mu = mean(X, 2);  
  % Center data:
  X =  bsxfun(@minus, X, mu);
  
  if D <= N,
    % Compute eigenvectors and eigenvalues of the covariance matrix:
    [V lambda] = eig(X*X');
    lambda = diag(lambda)';
  else
    [V lambda] = eig( 1/N * (X'*X) );
    lambda = diag(lambda)';
    % Normalise eigenvectors:
    V = (X*V) ./ sqrt( N*repmat(lambda, [D 1]) );
    if d > N,
      d = N;
    end
  end
  
  % Sort the eigenvectors in the descending order of the eigenvalues:
  [~, idx] = sort(lambda, 'descend');
  E = V(:,idx);
  E = E(:,1:d)';
  
end