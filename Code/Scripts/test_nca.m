function test_nca(dataset, d, init, subsample, nr_trials)
% TEST_NCA Simple function that tests NCA code for different arguments.
%
% Input:
%   dataset - name of the data set.
%   subsample - subsamples the given data set in the following way:
%     X(1:subsample:end). Default subsample=1.
%   d - dimensions to project to. Default d=2.
%   init - defines how to initialize the projection matrix A. If init='pca'
%     use the first d eigenvectors. If init='rand' generates a random
%     matrix A; there are nr_trials trials and there is selected that A
%     that achieves the best score. Default nr_trials=50.

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

  if ~exist('nr_trials','var'),
    nr_trials = 50;
  end

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
      [E, lambda] = PCA(X);
      Ainit = E(:,1:d);
    case 'rand'
      it = 1;
      score = -Inf;
      while it <= nr_trials,
        it = it + 1;

        Anew = randn(1,D*d);
        % Make sure no NaNs will appear?
        new_score = nca_obj(Anew, X, c);

        if new_score > score,
          score = new_score;
          Ainit = Anew;
        end
      end
  end

  % Apply NCA;
  fn = @(A)nca_obj(A, X, c);
  A = minimize(Ainit(:), fn, 300);
  score = nca_obj(A, X, c);

  % Save results:
  file_name = ['~/Documents/Diss/Results/nca-' ...
              dataset '-ss-' num2str(subsample) '-' init '-d-' num2str(d) '.txt'];
  fid = fopen(file_name, 'w');
  fprintf(fid, '%e\n', score);
  fprintf(fid, '%f ', A);
  fclose(fid);
  
  view_results('nca', dataset, subsample, init, d);

  clear all; close all;

end