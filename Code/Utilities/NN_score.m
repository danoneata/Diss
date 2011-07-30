function [output] = NN_score(X_train, c_train, X_test, c_test, A)
%NN_SCORE Nearest neighbour score.
%
%   [output] = NN_score(X_train, c_train, X_test, c_test, A)
%
% Inputs:
%      X_train DxN training data.
%      c_train 1xN labels corresponding to training data.
%       X_test DxM testing data.
%       c_test 1xM labels corresponding to test data.
%            A dxD projection matrix. If unspecified the NN is done in the
%                  original space.
%
% Outputs:
%       output 1x1 if c_test is specified: output = accuracy: number of 
%                  corrected classified points over number of total 
%                  points. 
%              1xM if c_test is unspecified: output = the predicted labels.

% Dan Oneata, July 2011

  if ~exist('A','var') || isempty('A'),
    A = eye(size(X_test,1));
  end
  
  if size(X_train,2) > 3000 || size(X_test,2) > 3000,
    N = size(X_test,2);
    c_predicted = zeros(1,N);
    
    AX_train = A*X_train;
    
    for i = 1:N,
      sd = square_dist(AX_train, A*X_test(:,i));
      [dummy, idxs_min] = min(sd, [], 1);
      c_predicted(i) = c_train(idxs_min);  
    end
  else  
    sd = square_dist(A*X_train, A*X_test);
    [dummy, idxs_min] = min(sd, [], 1);
    c_predicted = c_train(idxs_min);
  end
  
  if ~exist('c_test','var') || isempty(c_test),
    output = c_predicted;
  else
    output = 1 - nnz(c_predicted - c_test)/size(X_test, 2);
  end
  
end