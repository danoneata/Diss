%% Clear everything:
clear all; clc; close all;

%% Prepare data:

% Load data:
[X,c] = load_data_set('ecoli');
D = size(X,1);
d = 2;
  
% Standardize data:
X = normalize_data(X);

% Initialize projection matrix:
A = rand(d,D);

% Get moments of the data:
K = max(c);
moments(K).mean = zeros(D,1);
moments(K).cov = zeros(D,D);
for kk = 1:K,
  idxs = c == kk;
  moments(kk).mean = mean(X(:,idxs),2);
  moments(kk).cov = cov(X');
end

[~,bb,~] = unique(c);
Nc = diff([0 bb]);

%% Compute projection using compact-support kernels:

% [f,df] = nca_obj_cs_back(A(:), X, c, moments);
% checkgrad('nca_obj_cs_back', A(:), 1e-5, X, c, Nc, moments);
A = minimize(A(:),'nca_obj_cs_back', 1000, X, c, Nc, moments);

%% Plot results:

AA = reshape(A,d,D);
plot3_data(AA*X,c);
loocv(AA*X,c)