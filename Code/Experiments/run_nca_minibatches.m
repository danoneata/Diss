function [mapping, to_plot] = run_nca_minibatches(obj, X, c, d, opts)
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
%                  opts(7) defines windows length for cross-validation.
%
% Outputs:
%      mapping structure that contains:
%              the projection matrix A (mapping.A)
%              the mean of the data X (mapping.mean).
%      to_plot structure that contains the cross-validation score.

% Dan Oneata, July 2011

  if ~exist('obj','var'),
    obj = 'nca_obj_simple';
  end
  
  if ~exist('opts','var') || numel(opts) ~= 7,
    opts = [3 5000 0.05 0.5 50 3000 25];
  end
  
  % Size of mini-batches:
  init_type = opts(1);
  m = opts(2);
  p = opts(3);
  lambda = opts(4);
  ct = opts(5);
  max_iter = opts(6);
  window_length = opts(7);
  
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
  score_best = -Inf;
  it_best = 0;
  score_cv = zeros(1,max_iter);
  
  % Learning rate:
  epsilon = lambda / ct;
  
  % Initialize projection matrix:
  A = initA(init_type,X,c,D,d);
  A_ = reshape(A,d,D);
  
  [lambda, ct] = tune_learning_rate(A, X, c, X_cv, c_cv, obj, m)
%   score_total = zeros(1,max_iter);

  while epsilon > 0 && it <= max_iter && ~converged,
    % Random shuffle the data points:
    [yy] = rpc(A_*X,m);
    for ii = 1:max(yy),
      [f, df] = feval(obj, A, X(:,yy==ii), c(yy==ii));
      
      epsilon = lambda / (it + ct);
      A = A - df*epsilon;
      
      % Get score on cross-validation set:
      A_ = reshape(A,d,D);
      score_cv(it) = nca_cv_score(A_, X, c, X_cv, c_cv)/N_cv;
      
      % Monitor cross-validation error:
      if score_cv(it) - score_best > 1e-5,
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

function [lambda,ct] = tune_learning_rate(Ainit, X, c, X_cv, cv, obj, m)

  score = zeros(1,7);
  ct_prop = zeros(1,7);
  N = size(X,2);

  [yy] = rpc(reshape(Ainit,[],size(X,1))*X,m);
  [dummy, df] = feval(obj, Ainit, X(:,yy==1), c(yy==1));
  disp('Initialization score: ');
  (- dummy / m)
  
  disp('Starting exponential search for hyperparameters');
  
  lambda = 1;
  ct_prop(1) = 0.1;
  
  score(1) = -Inf;
  i = 1;
  
  while 1,
    i = i + 1;
    ct_prop(i) = ct_prop(i-1)*5;
    epsilon = lambda / (ct_prop(i) + 1);
    Aprop = Ainit - df*epsilon;
    score(i) = nca_cv_score(Aprop, X, c, X_cv, cv) / size(X_cv,2);
    if ct_prop(i) > 1e3,
      break;
    end
  end
  
  [score_sort, idxs_sort] = sort(score,'descend');
  ct = ct_prop(idxs_sort(1));
  
  if abs(idxs_sort(1)-idxs_sort(2)) == 1,
    disp('Starting linear search for hyperparameters');
    
    score_best = score_sort(1);
    ct_sort = ct_prop(idxs_sort);
    delta = abs(ct_sort(2) - ct_sort(1)) / 5;
    
    if ct_sort(1) < ct_sort(2),
      ct_min = ct_sort(1);
      ct_max = ct_sort(2);
    else
      ct_min = ct_sort(2);
      ct_max = ct_sort(1);
    end
    for ct_ = ct_min:delta:ct_max,
      epsilon = lambda / (ct_ + 1);
      Aprop = Ainit - df*epsilon;
      score_ = nca_cv_score(Aprop, X, c, X_cv, cv) / size(X_cv,2);
      if score_ > score_best,
        ct = ct_;
        score_best = score_;
      end
    end
  end

end