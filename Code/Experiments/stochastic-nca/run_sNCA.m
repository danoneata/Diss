function [mapping, to_plot] = run_sNCA(obj, X, c, d, opts)
%RUN_SNCA 
%
%     [mapping, to_plot] = run_sNCA(obj, X, c, d, opts)
%
% Inputs:
%          obj string that specifies the NCA objective function to be used.
%            X DxN data.
%            c 1xN labels.
%            d 1x1 number of dimensions to reduce to.
%         opts 1x2 opts(1) defines initialization procedure: 
%                   0 randn (default)
%                   1 PCA 
%                   2 LDA
%                   3 RCA
%                   if negative, tries abs(opt(1)) random initializations
%                   and picks the best one.
%                  opts(2) define number of points that are considered at
%                   each iteration.
%                  opts(3) defines percentage of points that are used for
%                   cross-validaton.
%                  opts(4) specifies 1st hyperparameter for the learning
%                   rate.
%                  opts(5) specifies 2nd hyperparameter for the learning
%                   rate.
%                  opts(6) defines the maximum number of iterations.
%
% Outputs:
%      mapping structure that contains:
%              the projection matrix A (mapping.A)
%              the mean of the data X (mapping.mean).
%      to_plot structure that contains the cross-validation score.

% Dan Oneata, July 2011

  if ~exist('obj','var'),
    obj = 'nca_obj_o1';
  end
  
  if ~exist('opts','var') || numel(opts) ~= 6,
    opts = [0 50 0.05 0.5 50 3000];
  end
  
  % Size of mini-batches:
  init_type = opts(1);
  m = opts(2);
  p = opts(3);
  lambda = opts(4);
  ct = opts(5);
  max_iter = opts(6);
  
  % Split data into training set and cross validation set:
  [X, c, X_cv, c_cv] = split_data(X,c,p);
  [X, t] = normalize_data(double(X));
  % Apply standardization to the cross-validation set:
  X_cv = transform(double(X_cv),t);
  
  [D N] = size(X);
  N_cv = size(X_cv,2);
  
  converged = 0;
  it = 1;
  
  % Variables for cross-validation error:
  window_length = 50;
  score_best = -Inf;
  it_best = 0;
  score_cv = zeros(1,max_iter);
  
  % Learning rate:
  epsilon = lambda / ct;
  
  % Initialize projection matrix:
  A = initA(init_type,X,c,D,d);
  
%   lambda = tune_learning_rate(A, X, c, X_cv, c_cv, obj, m)
%   score_total = zeros(1,max_iter);

  while epsilon > 0 && it <= max_iter && ~converged,
    % Random shuffle the data points:
    idxs = randperm(N);
    for ii = 1:m:N,
      [f, df] = feval(obj, A, X, c, idxs(ii:min(N, ii+m-1)));
      
      epsilon = lambda / (it + ct);
      A = A - df*epsilon;
      
      % Get score on cross-validation set:
      A_ = reshape(A,d,D);
      score_cv(it) = nca_cv_score(A_, X, c, X_cv, c_cv)/N_cv;
      
      % Monitor cross-validation error:
      if score_cv(it) > score_best,
        score_best = score_cv(it)
        A_best = A_;
        it_best = it;
      end
      if it_best == it - window_length,
        converged = 1;
        break;
      end
      
      disp(['Iteration ' num2str(it) ' of ' num2str(max_iter) '...']);    
      it = it + 1;
    end
  end
  
%   A_best = A_;
  % Compute the whole transformation:
  mapping.mean = t.mean;
  mapping.A    = A_best * t.std;

  to_plot.score_cv = score_cv;
  to_plot.it = it;
  to_plot.it_best = it_best;
  to_plot.score_best = score_best;
  
end

function A = initA(sw,X,c,D,d)
  % Select initialization for the projection matrix A:
  switch sw
    case 0
      A = randn(d,D);
    case 1
      A = PCA(X,d);
    case 2
      A = LDA(X,c,d);
    case 3
      [dummy, A] = RCA(X',c,d);
      A = A';
    otherwise
      ff = Inf;
      max_it = abs(opts(1));
      for yy = 1:max_it,
        Aprop = 0.1*randn(d,D);
        fprop = feval(obj, Aprop, X, c, Nc, moments);
        if fprop < ff,
          A = Aprop;
          ff = fprop;
        end
      end
  end
  A = A(:);
end

function [lambda,ct] = tune_learning_rate(Ainit, X, c, X_cv, cv, obj, m);

%   lambda_prop = 0.001;
%   score_best = -Inf;
%   
  [yy] = rpc(reshape(Ainit,[],size(X,1))*X, m);
  [dummy, df] = feval(obj, Ainit, X(yy==1), c(yy==1));
% %   
%   while lambda_prop <= 10,
%     ct_prop = 0.01;
%     while ct_prop <= 10,
%       epsilon = lambda_prop / (ct_prop + 1);
%       Aprop = Ainit - df*epsilon;
%       score = nca_cv_score(Aprop, X, c, X_cv, cv);
%       score
%       if score > score_best,
%         score_best = score;
%         lambda = lambda_prop;
%         ct = ct_prop;
%       end
%       ct_prop = ct_prop*10;
%     end
%     lambda_prop = lambda_prop*10;
%   end
  
%   while lambda_prop <= 10,
%     ct_prop = lambda_prop*abs(mean(df))/0.5;
%     epsilon = lambda_prop / (ct_prop + 1);
%     Aprop = Ainit - df*epsilon;
%     score = nca_cv_score(Aprop, X, c, X_cv, cv);
%     score
%     if score > score_best,
%       score_best = score;
%       lambda = lambda_prop;
%       ct = ct_prop;
%     end
%     lambda_prop = lambda_prop*10;
%   end

  lambda = abs( mean(abs(Ainit)) - 0.5 ) * 20 / mean( abs( df(:) ) );

end