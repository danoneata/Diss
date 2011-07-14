%% Load data:
clear all; close all;

d = 3;
[X,c] = load_data_set('iris');
X = normalize_data(X);
[D,N] = size(X);

A = randn(d,D);

%% Apply NCA:
tic; [f, df] = nca_kde(A,X,c); toc;
tic; [f2,df2] = nca_obj_simple(A,X,c); toc;