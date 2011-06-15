function [X_new, f_new, i] = gd(X_old, f)
%GD Basic implementation of gradient descent algorithm.
%
%     [X_new, f_new, i] = gd(X_old, f)
%
% Inputs:
%      X_old Dx1 Initial point.
%          f function handle.
%
% Outputs:
%      X_new Dx1 solution.
%      f_new 1x1 value of the function of the obtained solution X.
%          i 1x1 number of iterations.

% Dan Oneata, June 2011
% This function was inspired by the notes for the course CSC2515 
% (University of Toronto).

% TO DO: 
%   * Add momentum?
%   * Try other stopping criteria?

  MAX_NR_ITER = 1000;

  step = median(abs(X_old))/100;
%   step = 5;
  X_new = X_old + 1;
  f_old = Inf;
  df_new = zeros(size(X_old));
  df_old = zeros(size(X_old));
  i = 0;

  while step > 1e-5,          % What stopping condition should I use?
%   while 1,
    X_new = X_old - step*df_new;
    [f_new df_new] = feval(f, X_new);
    
    i = i + 1;
%     if (i > 0 && sum(abs(X_old - X_new)) < 1e-5) || i > MAX_NR_ITER, 
%       break;
%     end
    
    if f_new >= f_old,        % Worse.
      step = 0.5*step;        % Slow down.
      df_new = df_old;        % Use gradient from the previous step.
    else                      % Better.
      step = 1.1*step;        % Go faster.
      f_old = f_new;          % Update function value;
      X_old = X_new;          % Update position.
      df_old = df_new;        % Update gradient.
    end
    
    if ~mod(i,10),
      fprintf('Iteration %6i;  Value %4.6e\r', i, f_new);
    end
  end
  
  fprintf('Iteration %6i;  Value %4.6e\r', i, f_new);

end