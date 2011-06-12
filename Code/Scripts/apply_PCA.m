% [X,c] = load_data_set('olivetti');
% [X,c]=load_synthetic_data(100,7,'circles',2);
% X = X(:,1:30:end);
% c = c(1:30:end);
clear all; clc; close all;

X = dlmread('faithful.txt')';
X = double(X);
X = normalize_data(X);
[E, lambda] = PCA(X);
Y = E(:,1:2)'*bsxfun(@minus, X, mean(X,2));
xmin = -2; ymin = -2;
xmax = 2; ymax = 2;
plot3_data(X,ones(1,272)); 
axis([xmin xmax ymin ymax])
plot3_data(Y,ones(1,272)); 
axis([xmin xmax ymin ymax])