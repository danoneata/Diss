%% Load data:
clear all; close all;

d = 2;
[X,c] = load_data_set('landsat-test');
X = normalize_data(X);
[D,N] = size(X);

A = randn(d,D);
AX = A*X;
% q = randn(d,1); 
q = AX(:,100);

%% Build k-d tree:
kdtree = build_kdtree_box(AX,30);

%% Plot k-d tree results:
plot3_data(AX,c);hold on;
for nd = 1:length(kdtree),
%   if ~isempty(kdtree(nd).split_dir),
  if kdtree(nd).split_dir == 0,
    x = kdtree(nd).min(1);
    y = kdtree(nd).min(2);
    w = kdtree(nd).max(1) - x;
    h = kdtree(nd).max(2) - y;
    rectangle('Position', [x y w h]);
%     pause(0.3);
  end
end
hold off;

%% Nearest neighbour search:
plot3_data(AX,c);hold on; 
plot(q(1),q(2),'ko');
[d_min X_min] = NN_search_box(q, kdtree, 1, Inf, []);
[d_min_2 X_min_2] = NN_naive_search(AX, q);
X_min
X_min_2