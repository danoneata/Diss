function [X_train, c_train, X_test, c_test] = load_usps_paper(X,c)
% LOAD_USPS_PAPER
% Splits the USPS data as described in the paper: 200 images for each of
% the 10 classes for training and 500 for testing.
% Also, downscales it image to 8x8 from 64x64.

  d = 8;
  n_test = 500;
  n_train = 200;

  [X,c] = load_data_set('usps');

  X_train = zeros(d*d, n_train*10);
  c_train = zeros(  1, n_train*10);

  X_test = zeros(d*d, n_test*10);
  c_test = zeros(  1, n_test*10);

  for dd = 0:9,
    id = find(c==dd+1);
    id = id(randperm(numel(id)));

    X_train_scaled = resize_images( X(:, id(1:n_train)), 64 );
    X_test_scaled  = resize_images( X(:, id(n_train+1:n_test+n_train)), 64 ); 

    c_train( :, dd*n_train + 1:(dd+1)*n_train ) = c( 1, id(1:n_train) );
    c_test( :, dd*n_test + 1:(dd+1)*n_test )  = c( 1, id(n_train+1:n_test+n_train) );

    X_train( :, dd*n_train + 1:(dd+1)*n_train ) = X_train_scaled;
    X_test( :, dd*n_test + 1:(dd+1)*n_test ) = X_test_scaled;
  end

end