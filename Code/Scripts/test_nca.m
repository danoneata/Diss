function A = test_nca(dataset, d, init, subsample, plot_results, save_results)
%TEST_NCA Function that tests NCA code for different arguments.
%
%     A = test_nca(dataset, d, init, subsample, plot_results, save_results)
%
% Inputs:
%           dataset string that specifies the name of the data set.
%                 d 1x1 dimensionality to reduce the original data to. 
%              init string that specifies the method used to initialize the 
%                   projection matrix. It can be one of the following: 
%                   'rand', 'pca', 'lda'.
%         subsample 1x1 defines how to subsample from the given data set.
%                   The sampling is done in the following manner:
%                   X(1:subsample:end).
%      plot_results 1x1 flag. If non-zero the function plots the initial
%                   and the learnt projection. By default this flag is 0.
%      save_results 1x1 flag. If non-zero the funtcion save the results:
%                   the learnt projection matrix and the obtained scored.
%                   By default this flag is 0.
%
% Outputs:
%                 A dxD learnt projection matrix.

% Dan Oneata, June 2011


  if ~exist('dataset','var'),
    help('test_nca');
    error('No data set specified.');
  end

  if ~exist('subsample','var'),
    subsample = 1;
  end

  if ~exist('d','var'),
    d = 2;
  end

  if ~exist('init','var'),
    init = 'pca';
  end
  
  if ~exist('plot_results','var'),
    plot_results = 0;
  end
  
  if ~exist('save_results','var'),
    save_results = 0;
  end

  NR_TRIALS = 50;     % Number of trials to pick the best random projection.
  NR_ITER   = 300;    % Number of iteration for CGs optimization algorithm.

  % Load data:
  [X, c] = load_data_set(dataset);
  X = double(X);
  X = X(:,1:subsample:end);
  c = c(1:subsample:end);

  % Normalize data?
  X = normalize_data(X);

  % Dimensionality of the data:
  D = size(X,1);

  switch init
    case 'pca'
      Ainit = PCA(X, d);
    case 'lda'
      Ainit = LDA(X, c, d);
    case 'rand'
      it = 1;
      score = - Inf;
      while it <= NR_TRIALS,
        it = it + 1;
        
        Anew =  randn(d,D);
        new_score = - nca_obj(Anew(:), X, c);
        
        if new_score > score,
          score = new_score;
          Ainit = Anew;
        end
      end
  end

  % Apply NCA;
  A = minimize(Ainit(:), 'nca_obj', NR_ITER, X, c);
  
  % Use the folowing for older versions of MATLAB:
  % fn = @(A)nca_obj(A, X, c);
  % A = minimize(Ainit(:), fn, NR_ITER); 
  
  score = - nca_obj(Ainit(:), X, c);
  fprintf('Initial score: %4.2f\r', score);
  score = - nca_obj(A(:), X, c);
  fprintf('Final score: %4.2f\r', score);
  
  % Plot results:
  if plot_results,
    plot3_data(Ainit*X,c);
    plot3_data(reshape(A,d,D)*X,c);
  end

  % Save results:
  if save_results,
    file_name = ['~/Documents/Diss/Results/nca-' ...
                dataset '-ss-' num2str(subsample) '-' init '-d-' num2str(d) '.txt'];
    fid = fopen(file_name, 'w');
    fprintf(fid, '%e\n', score);
    fprintf(fid, '%f ', A);
    fclose(fid);
  end

end