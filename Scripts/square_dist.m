function d2 = square_dist(x1, x2, inf_if_zero)
%SQUARE_DIST all NxM square dists between DxN and DxM vectors
%
%     d2 = square_dist(x1, x2[, inf_if_zero=false])
%
% Compute NxM matrix of square distances for DxN and DxM data x1 and x2.
%
% Inputs:
%               x1 DxN 
%               x2 DxM 
%      inf_if_zero 1x1 
%
% Outputs:
%              d2  NxM 
%
% WARNING 1: In my nearest neighbor experiments, I assume that distances of zero
% only occur when an item is compared with itself (no input location is ever
% repeated). I set these zero distances to Infinity by using the third flag of
% this function, rather than jumping through more elaborate hoops to do
% leave-one-out calculations. Not suitable for general use!
%
% WARNING 2: This routine is designed for speed, and loses precision for similar
% x1 and x2 (e.g. x1=1, x2=1+1e-9). I recommend centering your data, and using a
% different routine if accuracy is a primary concern.

% Iain Murray, May 2008
% Modified by Dan Oneata, June 2010

d2 = bsxfun(@plus, bsxfun(@minus, sum(x1.*x1,1)', x1'*(2*x2)), sum(x2.*x2,1));

% For more numerical stability uncomment the following:

% [D N] = size(x1);
% [d M] = size(x2);
% if D~=d,
%   help('squared_dist');
%   error('Error: Dimensons must agree.');
% end
% 
% d2 = zeros(N,M);
% for d = 1:D
%   d2 = d2 + (repmat(x2(d,:), N, 1) - repmat(x1(d,:)', 1, M)).^2;
% end

if (nargin > 2) && (inf_if_zero)
  d2(d2==0) = Inf; % Don't allow using points in exactly the same place.
end

