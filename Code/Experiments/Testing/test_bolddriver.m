%% Clear all:
clc; clear all; close all;

%% Load data:
[X,c] = load_data_set('ecoli');
D = size(X,1);
d = 2;

X = normalize_data(X);

A = randn(d,D);

%% Optimize function:
[A] = bolddriver(A(:), 'nca_obj_simple', 1000, X, c);
AA = reshape(A,d,D);

%% Plot results:
% plot(f);
plot3_data(AA*X,c);

[A] = minimize(A(:), 'nca_obj_simple', 300, X, c);
AA = reshape(A,d,D);
plot3_data(AA*X,c);