function test_cs_back_mixing(dataset)
%TEST_CS_BACK_MIXING Function to determine what mixing proportion is the 
%most suitable for the NCA with compact support kernels and background
%distribution.
%
%     test_cs_back_mixing(dataset, mix_prop)
%
% Inputs:
%       dataset string that specifies the name of the data set. 
%      mix_prop 1x1 mixing proportion between compact support kernels and
%               background distribution.

% Dan Oneata, July 2011

  root = '~/Documents/Diss/Results/mixing-proportion/';

  T = 20;
  % Load data:
  [X,c] = load_data_set(dataset);
  [D] = size(X,1);
  dd = [2 3 D];
  mix_props = [0.8 0.85 0.9 0.95 0.99 0.999];
  
  for idd = 1:length(dd);
    disp(dataset);
    disp(dd(idd));
    for mm = 1:length(mix_props);
      mix_prop = mix_props(mm);
      d = dd(idd);
      nca_score = zeros(1,T);
      nn_score  = zeros(1,T);
      for tt = 1:T,
        % Split data into training set and testing set:
        [X_train, c_train, X_test, c_test] = split_data(X,c);
        [X_train, transf] = normalize_data(X_train);
        % Get mean and covariance for each class:
        moments = get_moments(X_train,c_train);
        % Get number of points in each class:
        [dummy,bb] = unique(c_train);
        Nc = diff([0 bb]);

        % Initialize projection matrix:
        A = init_A(X_train, c_train, moments, Nc, d, T);
        % Minimize objective function:
        A = minimize(A(:),'nca_obj_cs_back', 500, X_train, c_train, Nc, moments, mix_prop);
        AA = reshape(A,d,D);

        transf.A = transf.std;
        X_test = transform(X_test, transf);
        % Get scores on test set:
        nca_score(tt) = nca_cls_cs_back(X_train, c_train, X_test, c_test, AA, moments, Nc, mix_prop);
        nn_score(tt) = NN_score(X_train, c_train, X_test, c_test, AA);
      end
      mean_nca_score = mean(nca_score);
      std_nca_score = std(nca_score);

      mean_nn_score = mean(nn_score);
      std_nn_score = std(nn_score);

      M = [mix_prop mean_nca_score std_nca_score mean_nn_score std_nn_score];
      % Save results:
      filename = [dataset '-' num2str(d) '.txt'];
      dlmwrite([root filename], M, '-append', 'delimiter', '&');
    end
  end

end

function [X_train, c_train, X_test, c_test] = split_data(X,c)
% Split data set into 70% train set and 30% test set:
  N = size(X,2);
  nr_test_points = ceil(30*N/100);

  idxs = randperm(N);
  idxs = idxs(1:nr_test_points);

  X_test = X(:, idxs);
  c_test = c(idxs);

  X_train = X; 
  c_train = c;
  X_train(:, idxs) = [];
  c_train(:, idxs) = [];
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

function A = init_A(X, c, moments, Nc, d, max_iter)
% Initialize projection matrix A:
  best_score = Inf;
  ii = 0;
  D = size(X,1);
  
  while ii < max_iter,
    ii = ii + 1;
    A = 0.5*rand(d,D);
    score = nca_obj_cs_back(A(:), X, c, Nc, moments);
    if score < best_score,
      best_score = score;
      best_A = A;
    end
  end
  A = best_A;
end