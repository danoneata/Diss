clear all; close all; clc;

% [X,c] = load_synthetic_data(150,7,'circles',2);
% load('../Datasets/iris.mat');
load('../Datasets/wine.mat');
% load('../Datasets/transfusion.mat');
% load('../Datasets/pima.mat');
% [X c] = load_usps;

% break;
% 
% X = X(:,1:20:end);
% c = c(:,1:20:end);

[D N] = size(X);
% Plot initial data:
plot3_data(X,c);

fn = @(A)nca_obj(A, X, c);

d = 2;
A = minimize(randn(D*d,1), fn, 50);
A = reshape(A, [], D);

X2 = A*X;
plot3_data(X2,c);

return;

% Construct k-d tree:
depth = floor(log2(N));

% The number of nodes of a complete balanced tree with depth "depth":
nr_nodes = 2^(depth+1) - 1;

% Pre-allocations:
global kdtree;
kdtree(nr_nodes).point = [];
kdtree(nr_nodes).split_dir = [];

build_kdtree(X2, 1);