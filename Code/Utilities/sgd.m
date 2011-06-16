function [X_new, f_all, step_all] = sgd(X_old, f, data, labels)
%GD Basic implementation of stochastic gradient descent algorithm.
%
%     [X_new, f_new, i] = sgd(X_old, f)
%
% Inputs:
%      X_old Dx1 Initial point.
%          f function handle.
%      data DxN data set.
%    labels 1xN class labels.
%
% Outputs:
%      X_new Dx1 solution.
%      f_new 1x1 value of the function of the obtained solution X.
%          i 1x1 number of iterations.

% Dan Oneata, June 2011

% TO DO: 
%   * Add momentum?
%   * Try other stopping criteria?

  NR_MAX_ITER = 300;
  BATCH_SIZE = 50;
  
  step = median(abs(X_old))/100;
  X_new = X_old;
  f_old = Inf;
  iter = 0;
  f_all = zeros(1,NR_MAX_ITER);
  step_all = zeros(1,NR_MAX_ITER);

  [D N] = size(data);

  while iter < NR_MAX_ITER,
    iter = iter + 1;
    idxs = randperm(N);
    
    for i = 1:BATCH_SIZE:N,
      batch = data(:,idxs(i:min(N,i+BATCH_SIZE-1)));
      batch_labels = labels(:,idxs(i:min(N,i+BATCH_SIZE-1)));
      
      [f_new df_new] = feval(f, X_new, batch, batch_labels);

      step_all(iter) = step;
      
      X_new = X_old - step*df_new;
    end
    
    if isnan(f_new),
      break;
    end
    
%     if X_new - X_old < 1e-40,
%       break;
%     end

    % Update step size using 'Bold driver' heuristic.
    if f_new >= f_old,        
      step = 0.5*step;        
      df_new = df_old;  
      f_all(iter) = f_old;
    else                      
      step = 1.1*step;        
      f_old = f_new;          
      X_old = X_new;          
      df_old = df_new;    
      f_all(iter) = f_new;
    end
%     step = step/iter;
  end

end