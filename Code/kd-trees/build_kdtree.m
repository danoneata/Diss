function build_kdtree(points, i)
%BUILD_KDTREE Constructs k-d tree from the given points.
%
%     build_kdtree(points, i)
%
% Inputs:
%     points DxN matrix, where D is the dimensionality of the data and N is
%                the number of points.
%          i 1x1 specifies the splitting direction (not properly 
%                implemented yet). 

% Dan Oneata, April 2011

  global kdtree;

  if isempty(points),
    return;
  end
  
  N = size(points,2);
  if N == 1,
    % Mark leaf accordingly as no split is needed:
    kdtree(i).point = points;
    kdtree(i).split_dir = 0;
    return;
  end

  % Get splitting direction:
  k = get_direction(points, i);
  % Find pivot:
  [dummy, idxs] = sort(points(k,:));
  idx_median = idxs(ceil((N+1)/2));
  val_median = points(k, idx_median);
%   points_sorted = points(:, idxs);
%   idx_half = ceil((N+1)/2);
  
  kdtree(i).point = points(:,idx_median);
  kdtree(i).split_dir = k;

  points(:,idx_median) = [];
  points_left  = points(:, points(k,:) <= val_median);
  points_right = points(:, points(k,:) >  val_median);
%   points_left  = points_sorted(:, 1:idx_half-1);
%   points_right = points_sorted(:, idx_half+1:end);
  
  build_kdtree(points_left, 2*i);
  build_kdtree(points_right, 2*i+1);

end

function k = get_direction(points, idx)
% GET_DIRECTION Returns splitting direction.
%   points - DxN matrix.
%   type:
%     -1 - argmax (max points(i,k) - min points(i,k) )
%     -2 - PCA
%     otherwise - cycle directions

  switch idx,
    case -1
      [dummy, k] = max(max(points, [], 2) - min(points, [], 2));
    case -2
    otherwise
      depth = floor(log2(idx));
      k = mod(depth, size(points,1)) + 1;
  end

end

function [m m_idx idxs] = get_median(points, k)
% GET_MEDIAN Returns the median and its position on the direction k.
  
  N = size(points,2);

  [dummy idxs] = sort(points(k,:));
  % Or use floor insted of cell:
  m_idx = idxs(ceil((N+1)/2));
  m = points(k, m_idx);

end
