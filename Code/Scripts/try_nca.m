clear all; close all; clc;

[X, c] = load_data_set('wine');
% Subsample training set:
% X = X(:,1:10:end);
% c = c(:,1:10:end);

[X] = normalize_data(X);
[D N] = size(X);

% Plot initial data:
plot3_data(X, c);

d = 2;
A = minimize(randn(D*d,1), 'nca_obj', 300, X, c);
A = reshape(A, [], D);

AX = A*X;
plot3_data(AX,c);

% Construct k-d tree:
depth = floor(log2(N));

% The number of nodes of a complete balanced tree with depth "depth":
nr_nodes = 2^(depth+1) - 1;

% Pre-allocations:
global kdtree;
kdtree(nr_nodes).point = [];
kdtree(nr_nodes).split_dir = [];

build_kdtree(AX, 1);