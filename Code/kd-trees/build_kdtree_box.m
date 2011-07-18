function kdtr = build_kdtree_box(Apoints, points, size_bucket)
%BUILD_KDTREE Constructs k-d tree from the given points.
%
%     build_kdtree_box(points, i, size_bucket)
%
% Inputs:
%     points DxN matrix, where D is the dimensionality of the data and N is
%                the number of points.
%size_bucket 1x1 specifies number of points in the leaves.

% Dan Oneata, June 2011

  global kdtree;
  if ~exist('size_bucket','var'),
    size_bucket = 50;
  end
  if ~exist('points','var'),
    points = Apoints;
  end
  build_kdtree_bounding_boxes(Apoints, points, 1, size_bucket);
  kdtr = kdtree;

end

function build_kdtree_bounding_boxes(Apoints, points, i, size_bucket)

  global kdtree;
  
  if isempty(points),
    return;
  end
  
  if i > 10000,
    return;
  end
  
  N = size(Apoints,2);
  if N < size_bucket,
    % Mark leaf accordingly as no split is needed:
    kdtree(i).Apoints = Apoints;
    kdtree(i).points = points;
    kdtree(i).nr_points = N;
    kdtree(i).split_dir = 0;
    kdtree(i).mu = mean(points,2);
    kdtree(i).Amu = mean(Apoints,2);
    kdtree(i).min = min(Apoints,[],2);
    kdtree(i).max = max(Apoints,[],2);
    return;
  end
  
  k = get_direction(Apoints, -1);
  % Find pivot:
  [dummy, idxs] = sort(Apoints(k,:));
  idx_median = idxs(ceil((N+1)/2));
  val_median = Apoints(k, idx_median);
%   val_median = mean(points(k,:));
  
  kdtree(i).Apoints = [];
  kdtree(i).points = [];
  kdtree(i).nr_points = N;
  kdtree(i).split_dir = k;
  kdtree(i).mu = mean(points,2);
  kdtree(i).Amu = mean(Apoints,2);
  kdtree(i).min = min(Apoints,[],2);
  kdtree(i).max = max(Apoints,[],2);
  
  Apoints_left  = Apoints(:, Apoints(k,:) <= val_median);
  Apoints_right = Apoints(:, Apoints(k,:) >  val_median);
  
  points_left  = points(:, Apoints(k,:) <= val_median);
  points_right = points(:, Apoints(k,:) >  val_median);
  
  build_kdtree_bounding_boxes(Apoints_left, points_left, 2*i, size_bucket);
  build_kdtree_bounding_boxes(Apoints_right, points_right, 2*i+1, size_bucket);

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
    otherwise
      depth = floor(log2(idx));
      k = mod(depth, size(points,1)) + 1;
  end

end