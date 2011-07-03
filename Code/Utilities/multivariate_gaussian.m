function background_dist = multivariate_gaussian(X, c, moments, A)
%MULTIVARIATE_GAUSSIAN Computes the contribution N(AX|A\mu, A\Sigma.A').
%
%     background_dist = multivariate_gaussian(X, c, moments, A)
%
% Inputs:
%                    X DxN data.
%                    c 1xN labels. 
%              moments structure that contains mean and cov for each class. 
%                    A dxD projection matrix. 
%
% Outputs:
%     background_dist  CxN contribution for each point given each class.

% Dan Oneata, July 2011

  N = size(X,2);
  C = length(unique(c));
  background_dist = zeros(C,N);
  
  AX = A*X;
  
  for cc = 1:C,
    m = A*moments(cc).mean;
    S = A*moments(cc).cov*A';
    background_dist(cc,:) = gaussian_dist(AX, m, S);
  end

end

function p = gaussian_dist(X, m, S)

  D = size(X,1);
  
  Xm = bsxfun(@minus, X, m);
  XmS = Xm'/S;
  p = (2*pi)^(-D/2)*det(S)^(-1/2)*exp(-1/2*sum(XmS'.*Xm,1));

end