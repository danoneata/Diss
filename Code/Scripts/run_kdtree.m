% points = [2 5 9 4 8 7
%           3 4 6 7 1 2];

points = rand(5,1e5);
        
[M N] = size(points);
depth = floor(log2(N));

% The number of nodes of a complete balanced tree with depth "depth":
nr_nodes = 2^(depth+1) - 1;

% Pre-allocations:
global kdtree;
kdtree(nr_nodes).point = [];
kdtree(nr_nodes).split_dir = [];

build_kdtree(points, 1);