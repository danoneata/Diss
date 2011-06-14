function [X, f_new, i] = gd(X0, f)

  MAX_NR_ITER = 1e5;

  step = median(abs(X0))/100;
  f_old = Inf;
  df_new = zeros(size(X0));
  df_old = zeros(size(X0));
  i = 0;

  while step > 1e-5,
    X = X0 - step*df_new;
    [f_new df_new] = feval(f, X);
    if f_new >= f_old,
      step = 0.5*step;
      df_new = df_old;
    else
      step = 1.1*step;
      f_old = f_new;
      X0 = X;
      df_old = df_new;
    end
    
    i = i + 1;
    if ~mod(i,100),
      fprintf('Iteration %6i;  Value %4.6e\r', i, f_new);
    end
    if i > MAX_NR_ITER,
      break;
    end
  end
  
  fprintf('Iteration %6i;  Value %4.6e\r', i, f_new);

end