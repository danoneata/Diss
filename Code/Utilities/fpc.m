function [idx, yy] = fpc(xx, K)
%FPC farthest-point clustering
%
%     [idx, yy] = fpc(xx, K);
%
% Inputs:
%        xx DxN input points
%         K 1x1 number of clusters
%
% Outputs:
%       idx 1xK indices of points used as cluster centers
%        yy 1xN integers in {1,2,...K} labeling points.

% Iain Murray, August 2008, June 2011

[D, N] = size(xx);

% Naive O(NK) algorithm. Good enough for many purposes.
centers = zeros(D, K);
idx = ones(1, K);
if nargout > 1
    yy = ones(1, N);
end

sq_length = sum(xx.*xx, 1)'; % Nx1

idx(1) = ceil(rand*N);
centers(:, 1) = xx(:, idx(1));
dist_to_closest = sq_length - xx'*(2*xx(:, idx(1))) + sq_length(idx(1));

for kk = 2:K
    [dummy, idx(kk)] = max(dist_to_closest);
    centers(:, kk) = xx(:, idx(kk));
    dist_to_new = sq_length - xx'*(2*xx(:, idx(kk))) + sq_length(idx(kk));
    if nargout > 1
        [dist_to_closest, is_new] = min([dist_to_new, dist_to_closest], [], 2);
        yy(is_new == 1) = kk;
    else
        dist_to_closest = min(dist_to_new, dist_to_closest);
    end
end
