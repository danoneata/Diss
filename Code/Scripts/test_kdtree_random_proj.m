% Test k-d tree on random projections.
clear all; close all; clc;

global pos_best;
global d_best;
global contor;
global ii;
global kdtree;

d = [2 3 4 5 6 7 8 9 10 11 12 13];
nr_repetitions = 5;

[X, c] = load_data_set('usps');
[X_train, c_train, X_test, c_test] = load_usps_paper(X,c);

[D, nr_train] = size(X_train);

for idx = 1:numel(d),

  disp(d(idx));
  
  for i = 1:nr_repetitions,
    
    disp(i);
    
    kdtree = [];

    A = randn(d(idx),D);
    AX_test = A*X_test;
    AX_train = A*X_train;

    build_kdtree(AX_test + eps*randn(size(AX_test)), 1);

    contor = zeros(1,nr_train);
    for ii = 1:nr_train,
      d_best = Inf;
      NN_search( AX_train(:,ii), kdtree, 1 );
    end

    cntrs_mean(d(idx), i) = mean(contor);
    cntrs_std(d(idx),i) = std(contor);

  end

end

dlmwrite('usps-contors.txt', cntrs_mean, 'delimiter', '&');