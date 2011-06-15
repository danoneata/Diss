clear all; close all;

d = 2;
MAX_NR_ITER = 10;
BATCH_SIZE = 30;

[X, c] = load_data_set('iris');
X = normalize_data(X);
[D, N] = size(X);
A = randn(D*d, 1);

iter = 0;

while iter < MAX_NR_ITER,
  
  iter = iter + 1;
  idxs = randperm(N);
  
  iter
  
  for i = 1:BATCH_SIZE:N,
    batch = X(:,idxs(i:min(N,i+BATCH_SIZE)));
    batch_labels = c(:,idxs(i:min(N,i+BATCH_SIZE)));
    
    fn = @(A)nca_obj_reg(A, batch, batch_labels, 1e-2);
    A = gd(A(:), fn);
  end
  
end

Y = reshape(A, [d D])*X;
plot3_data(Y, c);