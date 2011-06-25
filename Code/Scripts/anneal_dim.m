function [AX, mapping, ff, xLabels] = anneal_dim(X, c, d, sw_type)
%ANNEAL_DIM 
%
%     [AX, mapping, ff, xLabels] = anneal_dim(X, c, d, sw_type)
%
% Inputs:
%            X DxN data.
%            c 1xN labels.
%            d 1x1 number of dimensions to reduce to. (Default d = 2.) 
%      sw_type 1x1 switch that selects one of the two possible ways to
%              perform the dimensionality annealing. If sw_type == 1
%              (default), we remove the dimension that presents the least
%              variabliality. In the other case sw_type ~= 1, the
%              dimensions are annealed in order.
%
% Outputs:
%           AX dxN projected data into the sub-space.
%      mapping structure that contains the learnt transformation: mean and 
%              linear projection A. The two fields of the structure are:
%              mapping.mean and mapping.A.
%           ff 1x? vector that stores the values of the function through 
%              out the optimization process. 
%      xLabels structure that contains xTick and xTickLabel that are going 
%              to be used for plotting purposes. 

% Dan Oneata, June 2011


  if ~exist('sw_type','var'),
    sw_type = 1;
  end
  if ~exist('d','var'),
    d = 2;
  end

  % Parameters:
  pp = 100;
  iters = 1;
  ll = 1e-2;
  randn('seed',100);

  % Load and pre-process data:
  [X tr] = normalize_data(double(X));
  [D, N] = size(X);

  % Initializations. Start with the identity matrix (original space):
  A = eye(D);
  A = A(:);
  ff = [];

  lambda = zeros(D,1);
  nr_dim = D;
  
  ii = 1;
  xLabels.xTick(ii) = 1;
  xLabels.xTickLabels = [sprintf('%2d',nr_dim)];

  while nr_dim > d,

    if sw_type == 1,
      % Select dimension with the least variance:
      [dummy, dim] = min( max(X,[],2) - max(X,[],2) );
    else
      % Select the next dimension:
      dim = nr_dim;
    end
    
    l_old = length(ff);
    for jj = 1:pp,
      % Gradually anneal one dimension at a time:
      lambda(dim) = lambda(dim) + ll;
      [A, f] = minimize(A, 'nca_obj_reg', iters + (D - nr_dim) , X, c, lambda);
      if isempty(f),                              % || f(end) - f0 > -1e-4
        break;
      end
      ff = [ff f'];
    end
    l_new = length(ff);
    % Update labels:
    ii = ii + 1;
    xLabels.xTick(ii) = (l_new - l_old) + xLabels.xTick(ii-1);
    xLabels.xTickLabels = [xLabels.xTickLabels; sprintf('%2d',nr_dim-1)];

    if sw_type == 1,
      A = reshape(A,nr_dim,D);
      A(dim,:) = [];
      lambda(dim) = [];
      A = A(:);
    end
    nr_dim = nr_dim - 1;

  end

  % Final optimization:
  [A, f] = minimize(A, 'nca_obj_reg', 100, X, c, lambda);
  ff = [ff f'];

  A = reshape(A,[],D);
  A = A(1:d,:);
  AX = A*X;
  
  mapping.mean = tr.mean;
  mapping.A = A*tr.std;
  
end