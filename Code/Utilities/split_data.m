function [X_train, c_train, X_test, c_test] = split_data(X, c, p)
%SPLIT_DATA Splits data sets into training and testing sets.
%
%     [X_train, c_train, X_test, c_test] = split_data(X, c, p)
%
% Inputs:
%            X DxN data.
%            c 1xN labels. 
%            p 1x1 percentage (if p \in (0,1)) or number of points (if p
%                  \in [1,N)) of testing points. Default p = 0.3.
%
% Outputs:
%      X_train Dxm train data. 
%      c_train 1xm labels for train data.
%       X_test Dxn test data. 
%       c_test 1xn labels for test data.

% Dan Oneata, July 2011

  N = size(X,2);
  
  if ~exist('p','var') || isempty(p),
    p = 0.3;
  end
  if 0 < p && p < 1,
    nr_test_points = ceil(p*N);
  elseif 1 <= p && p < N,
    nr_test_points = p;
  else
    help('split_data');
    error('p is negative or larger than the total number of points.');
  end
  
  idxs = randperm(N);
  idxs = idxs(1:nr_test_points);

  X_test = X(:, idxs);
  c_test = c(idxs);

  X_train = X; 
  c_train = c;
  X_train(:, idxs) = [];
  c_train(:, idxs) = [];
  
end