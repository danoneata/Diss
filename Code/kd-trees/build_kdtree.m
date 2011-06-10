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


  if isempty(points),
    return;
  end
  
  global kdtree;
  
  k = get_direction(points, i);
  [m m_idx] = get_median(points, k);
  
  kdtree(i).point = points(:,m_idx);
  
  if size(points,2) == 1,
    % Mark leaf accordingly as no split is needed:
    kdtree(i).split_dir = 0;
    return;
  end
  
  kdtree(i).split_dir = k;
  
  points_left  = points(:, points(k,:) < m);
  points_right = points(:, points(k,:) > m);
  
  build_kdtree(points_left, 2*i);
  build_kdtree(points_right, 2*i+1);

end

function k = get_direction(points, type)
% GET_DIRECTION Returns splitting direction.
%   points - DxN matrix.
%   type:
%     -1 - argmax (max points(i,k) - min points(i,k) )
%     -2 - PCA
%     otherwise - cycle directions

  switch type,
    case -1
    case -2
    otherwise
      depth = floor(log2(type));
      k = mod(depth, size(points,1)) + 1;
  end

end

function [m m_idx] = get_median(points, k)
% GET_MEDIAN Returns the median and its position on the direction k.
  
  N = size(points,2);

  [dummy idxs] = sort(points(k,:));
  % Or use floor insted of cell:
  m_idx = idxs(ceil((N+1)/2));
  m = points(k, m_idx);

end
