% Replicate experiments in paper:

[X, c] = load_data_set(dataset);
[D, N] = size(X);
score_train = zeros(nr_iter, 1);
score_test  = zeros(nr_iter, 2);

for iter = 1:nr_iter
  % Split data set into 70 train set and 30 test set:
  nr_test_points = ceil(30*N/100);
  nr_train_points = N - nr_test_points;

  idxs = randperm(N);
  idxs = idxs(1:nr_test_points);

  X_test = X(:, idxs);
  c_test = c(idxs);

  X_train = X; 
  c_train = c;
  X_train(:, idxs) = [];
  c_train(:, idxs) = [];
  
  [AX_train, mapping, score_train(iter)] = run_nca(X_train, c_train, d, [ceil(rand*3) 0]);
  AX_test = transform(X_test, mapping);
  score_test(iter, 1) = kNN_score(AX_test, c_test, AX_train, c_train);
  score_test(iter, 2) = nca_classification(AX_train, c_train, AX_test, c_test);
end

mean_train_error = mean(score_train);
mean_test_error  = mean(score_test,1);

scores = [[1:nr_iter 0]' train_error test_error; mean_train_error mean_test_error];

dlmwrite(fn, scores, '-append', 'delimiter', '&');
