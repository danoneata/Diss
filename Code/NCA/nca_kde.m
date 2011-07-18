function [f, df] = nca_kde(A, X, c, idxs)
%NCA_KDE Neighbourhood Component Analysis objective function casted as a
%kernel density estimation problem.
%Returns function value and the first order derivatives.
%
%     [f, df] = nca_kde(A, X, c, idxs)
%
% Inputs:
%       A dxD - projection matrix (d <= D).
%       X DxN - data.
%       c 1xN - class labels.
%
% Outputs:
%       f 1x1   - function value. 
%      df 1xD*d - derivative values.

% Dan Oneata, June 2011
  global contor;
  global sw_plot;
  
  f  = 0;
  df = 0;

  [D N] = size(X);
  A = reshape(A,[],D);
  d = size(A,1);
  C =max(c);
  
  AX = A*X;
  
  if ~exist('idxs','var'),
    idxs = 1:N;
  end
  
  class(C).kdtree = [];
  for i = 1:C,
    ids = c == i;
    class(i).kdtree = build_kdtree_box(AX(:,ids), X(:,ids));
  end
    
  p = zeros(1,C);
  dp = zeros(d*D,C);
  
  for i=1:length(idxs),
    for j = 1:C,
      if sw_plot,
        plot3_data(AX, c); 
        hold on;
        plot(AX(1,idxs(i)),AX(2,idxs(i)),'gx','MarkerSize',15);
      end
      contor = 0;
      [p(j) dp(:,j)] = kde(AX(:,idxs(i)), X(:,idxs(i)), class(j).kdtree, 1, 0, 1e-2);
      if sw_plot,
        hold off;
      end
    end
    if sw_plot,
      close all;
    end

    ci = c(idxs(i));
    sum_p = sum(p);
    pi = max( p(ci) / sum_p, eps );
    f = f - pi;
    df_temp = ( - dp(:,ci) + pi*sum(dp,2) ) / sum_p;
    if isnan(df_temp),
      df_temp = eps;
    end
    df = df + df_temp;
  end

end

function [p dp] = kde(Aq, q, kdtree, i, p, epsilon)
  global contor;
  global sw_plot;
  
  if i > numel(kdtree) || isempty(kdtree(i).split_dir),
    return;
  end 
  
  if sw_plot,
    nd = i;
    x = kdtree(nd).min(1);
    y = kdtree(nd).min(2);
    w = kdtree(nd).max(1) - x;
    h = kdtree(nd).max(2) - y;
    rr = rectangle('Position', [x y w h]);
  end
  
  min_dist = mindist(kdtree,i,Aq);
%   if min_dist > 30,
%     if sw_plot,
%       set(rr, 'EdgeColor', 'r'); pause(.1);
%     end
%     
%     p = 0;
%     dp = 0;
%     return;
%   end
  
  max_dist = maxdist(kdtree,i,Aq);
  p_max = exp(-min_dist);
  p_min = exp(-max_dist);
  
  if p_max - p_min <= 2*epsilon*(p + kdtree(i).nr_points*p_min),
    if sw_plot,
      set(rr, 'EdgeColor', 'm'); pause(.1);
    end
        
    Adiff = Aq - kdtree(i).Amu;
    diff = q - kdtree(i).mu;
    p = kdtree(i).nr_points * exp(-Adiff'*Adiff);
    dp = kdtree(i).nr_points * exp(-Adiff'*Adiff) * (-2) * Adiff * diff';
    dp = dp(:);
    return;
  end
  
  if ~kdtree(i).split_dir,
    if sw_plot,
      set(rr, 'EdgeColor', 'b'); pause(.1);
    end
    
    diff = bsxfun(@minus, kdtree(i).Apoints, Aq);
    d = sum(diff.*diff,1);
    idx = d == 0;
    if nnz(idx) == 1,
      contor = contor + 1;
    elseif nnz(idx) > 1 || contor >= 2,
      error('Multiple points with the same value!\n');
    end
    
    % ? Eliminate current point:
    d(idx) = [];
    k = exp(-d);
    p = sum(k);
    
    x_ik = bsxfun(@minus, kdtree(i).points, q);
    x_ik(:,idx) = [];
    Ax_ik = bsxfun(@minus, kdtree(i).Apoints, Aq);
    Ax_ik(:,idx) = [];
    dp = -2*bsxfun(@times, k, Ax_ik)*x_ik';
    dp = dp(:);
    
    return;
  end  

  if sw_plot,
    set(rr, 'EdgeColor', 'g'); pause(.1);
  end
  
  mindist_left = mindist(kdtree, 2*i, Aq);
  mindist_right = mindist(kdtree, 2*i+1, Aq);
  
  if mindist_left < mindist_right,
    [p_left dp_left] = kde(Aq, q, kdtree, 2*i, p, epsilon);
    [p_right dp_right] = kde(Aq, q, kdtree, 2*i+1, p_left, epsilon);
  else
    [p_right dp_right] = kde(Aq, q, kdtree, 2*i+1, p, epsilon);
    [p_left dp_left] = kde(Aq, q, kdtree, 2*i, p_right, epsilon);
  end
  
  p = p_left + p_right;
  dp = dp_left + dp_right;
end

function d = mindist(kdtree,i,q)
  diff = max(q-kdtree(i).max, kdtree(i).min-q);
  diff = max(diff,0);
  d = diff'*diff;
end

function d = maxdist(kdtree,i,q)
  diff = max(kdtree(i).max-q, q-kdtree(i).min);
  d = diff'*diff;
end