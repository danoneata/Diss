function [E, lambda] = PCA(X)
%PCA Principal Components Analysis computes the linear transformation that
%projects the given data into the to a new coordinate system such that the
%greatest variance by any projection of the data comes to lie on the first 
%coordinate (called the first principal component), the second greatest 
%variance on the second coordinate, and so on.
%
%     [E, lambda] = PCA(X)
%
% Inputs:
%           X DxN data. D is the dimensionality and N is the number of
%           points.
%
% Outputs:
%           E DxD (or DxN if N < D) contains the eigenvectors on the
%           columns. These are sorted in descending order of their
%           coressponding eigenvalues.
%      lambda 1xD (or 1xN if N < D) is the vector of eigenvalues sorted in 
%           descending order. 

% Dan Oneata, June 2011

  [D N] = size(X);
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
  end
  
  % Sort the eigenvectors in the descending order of the eigenvalues:
  [lambda idx] = sort(lambda, 'descend');
  E = V(:,idx);
  
end