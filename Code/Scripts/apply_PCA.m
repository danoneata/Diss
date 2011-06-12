[X, c] = load_data_set('olivetti-0.25');
X = double(X);
[E, lambda] = PCA(X);
Y = E(:,1:3)'*bsxfun(@minus, X, mean(X,2));
plot3_data(Y, [],c);