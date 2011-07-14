function [d_best, nn] = NN_search_box(q, kdtree, pos_curr, d_best, nn)
%NN_SEARCH Finds nearest neighbour of the query point from the data that is
%stored into the given k-d tree.
%
%     NN_search(q, kdtree, pos_curr)
%
% Inputs:
%             q Dx1 query point. 
%        kdtree array of structures that stores the k-d tree. 
%      pos_curr 1x1 index that retains the current position. Initialise 
%               this with 1. 

% Dan Oneata, April 2011

  if pos_curr > numel(kdtree) || isempty(kdtree(pos_curr).point),
    return;
  end  

  nd = pos_curr;
  x = kdtree(nd).min(1);
  y = kdtree(nd).min(2);
  w = kdtree(nd).max(1) - x;
  h = kdtree(nd).max(2) - y;
  rr = rectangle('Position', [x y w h]);
  pause;
  
  if mindist(kdtree,pos_curr,q) > d_best,
    set(rr, 'EdgeColor', [1 0 0]);
    return;
  end
  
  set(rr, 'EdgeColor', [0 1 0]);
  
  % Check if leaf:
  if ~kdtree(pos_curr).split_dir,
    dists = square_dist(kdtree(pos_curr).point, q);
    [dd, min_idx] = min(dists,[],1);
    if dd < d_best,
      d_best   = dd;
      nn = kdtree(pos_curr).point(:,min_idx);
    end
  else
    mindist_left = mindist(kdtree, 2*pos_curr, q);
    mindist_right = mindist(kdtree, 2*pos_curr + 1, q);
    
    if mindist_left < mindist_right,
      nd_near = 2*pos_curr;
      nd_far = 2*pos_curr + 1;
    else
      nd_near = 2*pos_curr + 1;
      nd_far = 2*pos_curr;
    end    
    [d_best, nn] = NN_search_box(q, kdtree, nd_near, d_best, nn);
    [d_best, nn] = NN_search_box(q, kdtree, nd_far, d_best, nn);
  end
  
end

function d = mindist(kdtree,i,q)
  diff = max(q-kdtree(i).max, kdtree(i).min-q);
  diff = max(diff,0);
  d = diff'*diff;
end