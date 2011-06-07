% load('../Datasets/wine.mat');
[X,c]=load_synthetic_data(100,7,'circles',2);
% X = X(:,1:30:end);
% c = c(1:30:end);
[E, lambda] = PCA(X);
Y = E(:,1:2)'*bsxfun(@minus, X, mean(X,2));
plot3_data(Y,c);