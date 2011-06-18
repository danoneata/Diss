function [AX, mapping, score] = run_nca(X, c, d, opts)
%RUN_NCA Perform Neighbourhood Component Analysis.
%
%     [AX, mapping] = run_nca(X, c, d, opts)
%
% Inputs:
%            X DxN data.
%            c 1xN labels.
%            d 1x1 number of dimensions to reduce to.
%         opts 1x2 opt(1) defines initialization procedure: 
%                   0 randn (default)
%                   1 PCA 
%                   2 LDA.
%                  opt(2) defines how the optimization is done:
%                   0 batch mode using CGs (default)
%                   1 mini-batches using CGs.
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
  if ~exist('opts','var') || isempty(opts),
    opts = zeros(1,2);
  end
  max_iter = 300;
  
  X = double(X);
  [X, t] = normalize_data(X);
  [D, N] = size(X);
  
  if N > 1000,
    opts(2) = 1;
  end
  batch_size = min(1000, N);
  nr_batches = ceil(N / batch_size);
  max_iter = ceil(max_iter / nr_batches);
  
  switch opts(1)
    case 1
      A = PCA(X,d);
    case 2
      A = LDA(X,c,d);
    otherwise
      A = randn(d,D);
  end
  
  iter = 0;
  converged = false;
  
  switch opts(2)
    case 1
      % Mini-batches optimization:
      while iter < max_iter && ~converged,
        iter = iter + 1;
        disp(['Iteration ' num2str(iter) ' of ' num2str(max_iter) '...']);
        idxs = randperm(N);

        for batch = 1:batch_size:N
          X_batch = X( :, idxs( batch : min(batch + batch_size - 1, N) ) );
          c_batch = c( idxs( batch : min(batch + batch_size - 1, N) ) );
          [A, f] = minimize(A(:), 'nca_obj', 5, X_batch, c_batch);

          if isempty(f) || f(end) - f(1) > -1e-4
              disp('Converged!');
              converged = true;
          end
        end
      end
    otherwise
      % Train on the whole data at once:
      [A f] = minimize(A(:), 'nca_obj', max_iter, X, c);
  end
  
  A = reshape(A, [d D]);
  mapping.mean = t.mean;
  mapping.A    = A * t.std;
  
  AX = A*X;
  
  score = -f(end)/N;
  
end