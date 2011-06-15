close all; clear all;
% 
[X, c] = load_data_set('landsat-train');
% X = X+1e-6*rand(size(X));
% X = [2 5 9 4 8 7
%     3 4 6 7 8 2];
% rand('seed',1);
% X = rand(2,17);
% X(3:end,:) = [];
% X = normalize_data(X);
% X = rand(2,7);
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
% return;

global pos_best;
global d_best;
global contor;

correct_pnts = 0;
tic;
[Y, c] = load_data_set('landsat-test');
[D,N] = size(Y);
for i = 1:10,
  contor = 0;
  d_best = Inf;
  NN_search(Y(:,i), kdtree, 1);
  if d_best < 1e-10,
    correct_pnts = correct_pnts + 1;
  end
  contor
  d_best
end
toc;
% correct_pnts