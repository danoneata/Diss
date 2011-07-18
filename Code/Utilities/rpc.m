function [ll] = rpc(xx, m)
%RPC Recursive projetion clustering. Wrapper for the recursive function.
%
%     [ll] = rpc(xx, m);
%
% Inputs:
%        xx DxN input points.
%         m 1x1 minimum size of a cluster.
%
% Outputs:
%        ll 1xN integers in {1,2,...K} labeling points.

% Dan Oneata, June 2011

  global label;
  label = 1;

  N = size(xx, 2);
  % Compute RPC clusters using the recursive function:
  [ll, sort_idxs] = rpc_fct(xx,1:N,m);
  
  % Now order the obtained labels using a reserve sorting:
  unsorted = 1:N;
  new_idxs(sort_idxs) = unsorted;
  ll = ll(new_idxs);

end

function [ll, sort_idxs] = rpc_fct(xx, idxs, m)
%RPC Recursive projetion clustering---recursive function.
%
%     [sort_labels, idxs] = rpc_fct(xx, labels, m);
%
% Inputs:
%        xx DxN input points.
%         m 1x1 minimum size of a cluster.
%      idxs 1xN indices of original points in xx.
%
% Outputs:
%        ll 1xN integers in {1,2,...K} labeling points.
% sort_idxs 1xN sorted indices of original points in xx.

% Dan Oneata, June 2011

  global label;
  N = size(xx,2);

  if N > m,
    % Randomly select two points from the given set:
    ii = ceil(rand(1,2)*N);
    A = xx(:,ii(1));
    B = xx(:,ii(2));
    BA = B - A;

    % Compute projections
    proj = sum( bsxfun( @times, bsxfun(@minus, xx, A), BA ), 1 );

    % Determine median:
    [dummy, proj_idxs] = sort(proj);
    xx = xx(:,proj_idxs);
    idxs = idxs(:,proj_idxs);
    mm = ceil((N+1)/2);

    [l1, y1] = rpc_fct(xx(:,1:mm), idxs(1:mm), m);
    [l2, y2] = rpc_fct(xx(:,mm+1:end), idxs(mm+1:end), m);
    
    ll = [l1 l2];
    sort_idxs = [y1 y2];
    
  else
    % Return curent points as a cluster.
    N = length(idxs);
    ll = label*ones(1,N);
    sort_idxs = idxs;
    label = label + 1;
  end

end