d = 2;
pp = 1e2;
iters = 10;
ll = 1e-2;
randn('seed',10);

[X, c] = load_data_set('glass');
X = normalize_data(double(X));
[D, N] = size(X);

A = 0.01*randn(D*D,1);

lambda = zeros(D,1);
for j = D:-1:d+1,
  for jj = 1:pp,%+(D-j)*20,
    lambda(j) = lambda(j) + ll;
    [A, f] = minimize(A, 'nca_obj_reg', iters, X, c, lambda);
%     if isempty(f) || f(end) - f(1) > -1e-10
%       break;
%     end
  end
end
A = reshape(A,D,D)
AA = A(1:d,:)
plot3_data(AA*X,c);