function plot_metric(A,q,options)

  if nargin < 3, options=[]; end
  if ~isfield(options,'fill'), options.fill=0; end
  if ~isfield(options,'gridx'), options.gridx = 200; end
  if ~isfield(options,'gridy'), options.gridy = 200; end
  if ~isfield(options,'line_style'), options.line_style = 'k'; end
  if ~isfield(options,'dist'), options.dist = 15; end

  V = axis;
  dx = (V(2)-V(1))/options.gridx;
  dy = (V(4)-V(3))/options.gridy;
  
  [X,Y] = meshgrid(V(1):dx:V(2),V(3):dy:V(4));
  
  tst_data=[reshape(X',1,prod(size(X)));reshape(Y',1,prod(size(Y)))];
  N = size(tst_data,2);
  S = A'*A;
  
  ll = zeros(1,N);
  aa = zeros(1,N);
  for i = 1:N,
    diff = tst_data(:,i) - q;
    if abs(sqrt(diff'*S*diff) - options.dist) < 0.45,
      ll(i) = 1;
    end
  end
  
  % Select and order points according to the angle:
  tst_data = tst_data(:,ll == 1);
  tt = bsxfun(@minus, tst_data, mean(tst_data,2));
  [th, r] = cart2pol(tt(1,:),tt(2,:));
  [dummy, order] = sort(th);
  tst_data = tst_data(:,order);
  
  % Do a little blur:
%   mask = fspecial('gauss',[5 5], 1);
  
  
  plot(tst_data(1,:),tst_data(2,:),'k-');
  
end