function try_nca(dataset, d)

  % d = 2;
  % dataset = 'transfusion';
  root_path = '~/Documents/Diss/Results/19-06/';
  sw_plot = 0;

  randn('seed', 100);
  rand('seed', 100);

  global kdtree;
  global ii;
  global contor;
  global d_best;

  % Data loading:
  if exist([dataset '-train.mat'], 'file') && ... 
      exist([dataset '-test.mat'], 'file'),
    [X_train, c_train] = load_data_set([dataset '-train']);
    [X_test, c_test] = load_data_set([dataset '-test']);
    [D nr_train_points] = size(X_train);
    nr_test_points = size(X_test, 2);
  else
    [X, c] = load_data_set(dataset);
    [D, N] = size(X);

    % Split data set into train set and test set:
    nr_test_points = ceil(N/10);
    nr_train_points = N - nr_test_points;

    idxs = randperm(N);
    idxs = idxs(1:nr_test_points);

    X_test = X(:, idxs);
    c_test = c(idxs);

    X_train = X; 
    c_train = c;
    X_train(:, idxs) = [];
    c_train(:, idxs) = [];
  end

  sw = 0;
  if ~exist('d','var'),
    d = D;
  end

  fn1 = [root_path dataset '-mapping.txt'];
  fn2 = [root_path dataset '-train-score.txt'];
  fn3 = [root_path dataset '-test-score.txt'];
  fn4 = [root_path dataset '-kdtree-contors.txt'];

  if exist(fn1,'file'),
    ff = dlmread(fn1);
    if ~isempty(find(ff(:,1) == d, 1)),
      % If available, load transformation:
      temp = ff(find(ff(:,1) == d, 1),:);
      d = temp(1); D = temp(2);
      mapping.mean = temp(3:D+3-1)';
      mapping.A = reshape(temp(D+3:D+3+d*D-1)', [d D]);
      sw = 1;
    end
  end
  if sw == 0,
    % Determine projection matrix A:
    [AX_train, mapping, score] = run_nca(X_train, c_train, d, [0 0]);
    % Determine error/score on train set:
    loocv_score_A = loocv(AX_train, c_train)/nr_train_points;
    eucl_loocv_score = loocv(X_train, c_train)/nr_train_points;

    % Apply transformation to test data:
    AX_test = transform(X_test, mapping);

    % Determine error/score on test set:
    A_kNN_score = kNN_score(AX_test, c_test, AX_train, c_train);
    eucl_kNN_score = kNN_score(X_test, c_test, X_train, c_train);
    NCA_score = nca_classification(AX_train, c_train, AX_test, c_test);

    % Work out how many nodes if we search via k-d trees:
    % Perturb values a little to ensure a balanced k-d tree.
    build_kdtree(AX_train + (1e-10)*rand(size(AX_train)), 1);
    contor = zeros(1,nr_test_points);
    for ii = 1:nr_test_points,
      contor(ii) = 0;
      d_best = Inf;
      NN_search(AX_test(:,ii), kdtree, 1);
    end
    mean_contor = mean(contor);

    % Save results:
    dlmwrite(fn1, [d D mapping.mean' mapping.A(:)'], '-append');
    dlmwrite(fn2, [d score loocv_score_A], '-append', 'delimiter', '&');
    dlmwrite(fn3, [d A_kNN_score NCA_score], '-append', 'delimiter', '&');
    dlmwrite(fn4, [d mean_contor contor], '-append');
  end

  fn5 = [root_path dataset '-eucl-score.txt'];
  if ~exist(fn5, 'file'),
    dlmwrite(fn5, [nr_train_points nr_test_points; eucl_loocv_score eucl_kNN_score]);
  end

  if sw_plot,
    % Plot final data:
    plot3_data(AX_train, c_train);
    plot3_data(AX_test, c_test);
  end
  
end

