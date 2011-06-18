clear all; close all;

[X, c] = load_data_set('landsat-train');
X = double(X);
X = normalize_data(X);
[D, N] = size(X);

d = 2;
A = randn(D*d, 1);

[A,f_all,step_all] = sgd(A, 'nca_obj', X, c);
loocv(reshape(A,d,D)*X,c)
% fn = @(A)nca_obj(A,X,c);
% A = minimize(A,fn,300);

Y = reshape(A, [d D])*X;
plot3_data(Y, c);
figure, plot(f_all);
figure, plot(step_all);