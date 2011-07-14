function [f, df] = nca_kde(A, X, c)
%NCA_KDE Neighbourhood Component Analysis objective function casted as a
%kernel density estimation problem.
%Returns function value and the first order derivatives.
%
%     [f, df] = nca_kde(A, X, c)
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

  f  = 0;
  df = 0;

  [D N] = size(X);
  A = reshape(A,[],D);
  d = size(A,1);
  C =max(c);
  
  AX = A*X;
  
  class(C).kdtree = [];
  for i = 1:C,
    idxs = c == i;
    class(i).kdtree = build_kdtree_box(AX(:,idxs), X(:,idxs));
  end
    
  p = zeros(1,C);
  dp = zeros(d*D,C);
  
  for i=1:N,
    for j = 1:C,
      [p(j) dp(:,j)] = kde(AX(:,i), X(:,i), class(j).kdtree, 1);
    end

    ci = c(i);
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

function [p dp] = kde(Aq, q, kdtree, i)
  if i > numel(kdtree) || isempty(kdtree(i).split_dir),
    return;
  end 
  
  if mindist(kdtree,i,Aq) > 30,
    p = 0;
    dp = 0;
    return
  end
  
  if ~kdtree(i).split_dir,
    diff = bsxfun(@minus, kdtree(i).Apoints, Aq);
    d = sum(diff.*diff,1);
    idx = d == 0;
    % ?
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
  
  [p_left dp_left] = kde(Aq, q, kdtree, 2*i);
  [p_right dp_right] = kde(Aq, q, kdtree, 2*i+1);
  
  p = p_left + p_right;
  dp = dp_left + dp_right;
end

function d = mindist(kdtree,i,q)
  diff = max(q-kdtree(i).max, kdtree(i).min-q);
  diff = max(diff,0);
  d = diff'*diff;
end