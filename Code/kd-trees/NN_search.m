function NN_search(q, kdtree, pos_curr)
%NN_SEARCH 
%
%     NN_search(q, kdtree, pos_curr)
%
% Inputs:
%             q ?x? 
%        kdtree ?x? 
%      pos_curr ?x? 

% Dan Oneata, April 2011
  
  global pos_best;
  global d_best;

  if isempty(kdtree(pos_curr).point),
    return;
  end
  
  % Check if leaf:
  if ~kdtree(pos_curr).split_dir,
    dd = dist2(kdtree(pos_curr).point, q);
    if dd < d_best,
      pos_best = pos_curr;
      d_best   = dd;
    end
    return;
  end
  
  % Choose the nearer child:
  if q(kdtree(pos_curr).split_dir) < ...
      kdtree(pos_curr).point(kdtree(pos_curr).split_dir),
    NN_search(q, kdtree, 2*pos_curr);
  else
    NN_search(q, kdtree, 2*pos_curr+1);
  end
  
  % Compute distance:
  dd = dist2(kdtree(pos_curr).point, q);
  if dd < d_best,
    pos_best = pos_curr;
    d_best   = dd;
  end

  % Distance from query to splitting plane:
  ds = (q(kdtree(pos_curr).split_dir) - ...
          kdtree(pos_curr).point(kdtree(pos_curr).split_dir))^2;
        
  if ds < d_best,
    % Choose the further child:
    if q(kdtree(pos_curr).split_dir) < ...
        kdtree(pos_curr).point(kdtree(pos_curr).split_dir),
      NN_search(q, kdtree, 2*pos_curr+1);
    else
      NN_search(q, kdtree, 2*pos_curr);
    end
  end

end

function dd = dist2(p,q)
% DIST Returns squared Euclidean distance between two points.
%   p - Dx1 vector
%   q - Dx1 vector
  dif = p-q;
  dd  = dif'*dif;
end

  