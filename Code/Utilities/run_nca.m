function [AX, mapping, score] = run_nca(obj, X, c, d, opts)
%RUN_NCA Perform Neighbourhood Component Analysis.
%
%     [AX, mapping] = run_nca(obj, X, c, d, opts)
%
% Inputs:
%          obj string that specifies the NCA objective function to be used.
%            X DxN data.
%            c 1xN labels.
%            d 1x1 number of dimensions to reduce to.
%         opts 1x2 opt(1) defines initialization procedure: 
%                   0 randn (default)
%                   1 PCA 
%                   2 LDA
%                   if negative, tries abs(opt(1)) random initializations
%                   and picks the best one.
%                  opt(2) defines how the optimization is done:
%                   0 batch mode using CGs (default)
%                   1 mini-batches using CGs.
%                  opt(3) define the maximum number of iterations.
%
% Outputs:
%           AX dxN projected data using the learnt matrix A.
%      mapping structure that contains:
%              the projection matrix A (mapping.A)
%              the mean of the data X (mapping.mean).

% Dan Oneata, June 2011

  if ~exist('d','var') || isempty(d),
    d = size(X,1);
  end
  if ~exist('obj','var') || isempty(obj),
    obj = 'nca_obj';
  end
  if ~exist('opts','var') || isempty(opts),
    opts = zeros(1,3);
    opts(3) = 500;
  end
  max_iter = opts(3);
  
  X = double(X);
  [X, t] = normalize_data(X);
  [D, N] = size(X);
  
  if N > 4000,
    opts(2) = 1;
  end
  
  % For compact support + background distribution method, precompute the
  % mean and covariance for each class and the number of points in each
  % class (equivalently the probability of each class).
  if strcmp(obj,'nca_obj_cs_back'),
    moments = get_moments(X, c);
    [dummy, Nc] = unique(c);
    Nc = diff([0 Nc]);
  else
    moments = [];
    Nc = [];
  end
  
  % Select initialization for the projection matrix A:
  switch opts(1)
    case 0
      A = randn(d,D);
    case 1
      A = PCA(X,d);
    case 2
      A = LDA(X,c,d);
    otherwise
      ff = Inf;
      max_it = abs(opts(3));
      for yy = 1:max_it,
        Aprop = 0.1*randn(d,D);
        fprop = feval(obj, Aprop, X, c, Nc, moments);
        if fprop < ff,
          A = Aprop;
          ff = fprop;
        end
      end
  end
  
  iter = 0;
  converged = false;
  
  switch opts(2)
    case 1
      % Mini-batches optimization:
      batch_size = min(1000, N);
      nr_batches = ceil(N / batch_size);
      max_iter = ceil(max_iter / nr_batches);
      while iter < max_iter && ~converged,
        iter = iter + 1;
        disp(['Iteration ' num2str(iter) ' of ' num2str(max_iter) '...']);
        idxs = randperm(N);

        for batch = 1:batch_size:N
          X_batch = X( :, idxs( batch : min(batch + batch_size - 1, N) ) );
          c_batch = c( idxs( batch : min(batch + batch_size - 1, N) ) );
          [A, f] = minimize(A(:), obj, 5, X_batch, c_batch, Nc, moments);

          if isempty(f) || f(end) - f(1) > -1e-4
              disp('Converged!');
              converged = true;
          end
        end
      end
      score = - feval(obj, A, X, c, Nc, moments) / N;
    case 2
      % Use stochastic gradient descent:
      [A] = bolddriver(A(:), obj, max_iter, X, c, Nc, moments);
      score = - feval(obj, A, X, c, Nc, moments) / N;
    otherwise
      % Train on the whole data at once:        
      [A f] = minimize(A(:), obj, max_iter, X, c, Nc, moments);
      score = - f(end) / N;
  end
  
  % Compute the whole transformation:
  A = reshape(A, [d D]);
  mapping.mean = t.mean;
  mapping.A    = A * t.std;
  
  % Return the projected A:
  AX = A*X;
  
end

function moments = get_moments(X,c)
% Get moments of the data:
  D = size(X,1);
  K = max(c);
  moments(K).mean = zeros(D,1);
  moments(K).cov = zeros(D,D);
  for kk = 1:K,
    idxs = c == kk;
    moments(kk).mean = mean(X(:,idxs),2);
    moments(kk).cov = cov(X');
  end
end