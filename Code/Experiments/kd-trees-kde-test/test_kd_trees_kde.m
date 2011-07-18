%% Load data:
[X, c] = load_data_set('iris');

[D N] = size(X);

id = ceil(N*rand);
Xq = X(:,id) + randn(D,1);

%% Test k-d tree:
tic;
tree = kdtree_build(X');
kde_value = kdtree_kde(tree, Xq);
toc;

%% Test naive approach:
tic;
kde_value_naive = sum( exp( - square_dist(X, Xq)  ) );
toc;

%% Final checking and cleaning:
assert(abs(kde_value - kde_value_naive) < 1e-10);
kdtree_delete(tree);
