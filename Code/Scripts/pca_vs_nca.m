% Contrast PCA and NCA linear projections on some simple data sets:
close all; clear all; clc;

% Load data:
[Y,l] = load_data_set('landsat_train');
Y = double(Y);

% Sub-sample data set;
X = Y(:,1:10:end);
c = l(1:10:end);

% Reduce to dimension d:
d = 2;
D = size(X,1);

% Apply PCA:
[E, lambda] = PCA(X);
Xpca = E(:,1:d)'*bsxfun(@minus, X, mean(X,2));

% Apply NCA:
[X, transf] = normalize_data(X);
fn = @(A)nca_obj(A, X, c);
Ainit = E(:,1:d);
A = minimize(Ainit(:), fn, 300);
A = reshape(A, [], D);
Xnca = A*X;

% Transformation of the sub-sample data set:
plot3_data(Xpca, Xnca, c, 'PCA', 'NCA');

% Apply obtained transformation to the whole data set:
% Y = Y(:,1:5500);
% l = l(1:5500);

Ypca = Ainit'*bsxfun(@minus, Y, mean(X,2));

Ynca = transf.std*bsxfun(@minus, Y, transf.mean);
Ynca = A*Ynca;

plot3_data(Ypca, Ynca, c, 'PCA', 'NCA');
