function plot3_data(X, c, title_, flags)
%PLOT3_DATA 
%
%     plot3_data(X, c, title_, flags)
%
% Inputs:
%          X DxN data. D is the dimensionality and N represents the number
%            of data points.
%          c 1xN class labels for each of the N data points.
%     title_ string to be displayed above the plot.
%      flags 1x1. If flags(1) is non-zero then axis are removed and the
%            plot is boxed.

% Dan Oneata, June 2011

  if ~exist('title_','var'),
    title_ = '';
  end
  
  if ~exist('flags','var'),
    flags = 0;
  end

  cc = unique(c);
  len_cc = length(cc);
  D = size(X,1);
  
  colors = [1 0 0; 0 1 0; 0 0 1; 1 1 0; 1 0 1; 0 1 1];
  if len_cc > 6,
    colors = [colors; rand(len_cc-6,3)];
  end
  
  style = ['.' 'o' 'x' '+' '*' 's' 'd' 'v' '^' '<' '>' 'p' 'h'];
  if len_cc > length(style),
    style = repmat(style, 1, ceil(len_cc/length(style)));
  end
  
  if D <= 1,
    help('plot3_data');
    error('Number of dimensions is 1 or less.');
  else
    
    figure; 
    axis auto;
    title(title_, 'interpreter', 'latex');
    
    if flags(1),
      set(gca, 'XTick', [], 'YTick', []);
      set(gca, 'Box', 'on');
    end
    
    hold on;
    if D == 2,    % Two dimensional plot.
      for idx = 1:len_cc,
        x = X(1:2, c==cc(idx));
        plot(x(1,:), x(2,:), style(idx), 'Color', colors(idx,:));
      end
      hold off;
    else    % Three dimensional plot; plotting the first 3 dimensions.
      for idx = 1:len_cc,
        x = X(1:3, c==cc(idx));
        plot3(x(1,:), x(2,:), x(3,:), style(idx), 'Color', colors(idx,:));
      end
    end
    hold off;
  end

end