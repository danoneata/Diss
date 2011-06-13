function score = loocv(X,c)
%LOOCV Computes the leave-one-out cross validation error for 1-NN algorithm
%that uses Euclidean metric.
%
%     score = loocv(X,c)
%
% Inputs:
%          X DxN data. D is the dimensionality and N is the number of
%            points in the data set.
%          c 1xN labels for each of the N points. 
%
% Outputs:
%     score  1x1 number of correctly classified points. 

% Dan Oneata, June 2011

  N = size(X,2);
  
  dists = square_dist(X, X);
  dists(1:N+1:N*N) = Inf;
  
  [~, min_idxs] = min(dists,[],1);
  predicted_labels = c(min_idxs);
  
  score = N - nnz(c - predicted_labels);

end