%% Load data:
clear all; close all;

d = 2;
idxs = [1 4 5 6 11 150];
[X,c] = load_data_set('wine');
X = normalize_data(X);
[D,N] = size(X);

A = randn(d*D,1);
% A = eye(d); A = A(:);

%% Apply NCA:
tic; [f, df] = nca_kde(A,X,c,idxs); toc;
tic; [f2,df2] = nca_obj_o1(A,X,c,idxs); toc;