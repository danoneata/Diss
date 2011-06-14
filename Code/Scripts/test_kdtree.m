close all; clear all;
% 
% [X, c] = load_data_set('landsat-train');
% X(3:end,:) = [];
% X = normalize_data(X);
X = rand(2,1e5);
[D,N] = size(X);

% Construct k-d tree:
depth = floor(log2(N));

% The number of nodes of a complete balanced tree with depth "depth":
nr_nodes = 2^(depth+1) - 1;

% Pre-allocations:
global kdtree;
kdtree(nr_nodes).point = [];
kdtree(nr_nodes).split_dir = [];

build_kdtree(X, 1);

global pos_best;
global d_best;

tic;
for i = 1:N,
  d_best = Inf;
  NN_search(X(:,i), kdtree, 1);
end
toc;