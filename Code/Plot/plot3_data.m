function plot3_data(X, Y, c, titleX, titleY)
% PLOT3_DATA Plots data in 3D space.
%   X - DxN matrix representing the data. If D > 3 then only the first 3
%   dimensions are used for plotting (i.e., X(1:3,:)).
%   Y - DxN Additional data. It will be plotted in a subfigure.
%   c - 1xN vector that specifies the class of each point from X.
%   titleX - text for data set X.
%   titleY - text for data set Y.
%
% Dan Oneata
% 03/04/2011

  if ~exist('titleX','var'),
    titleX = '';
  end
  
  if ~exist('titleY','var'),
    titleY = '';
  end
  
  nr_subplots = 1;
  if ~isempty(Y),
    nr_subplots = 2;
  end

  cc = unique(c);
  len_cc = length(cc);
  D = size(X,1);
  
  colors = [1 0 0; 0 1 0; 0 0 1; 1 1 0; 1 0 1; 0 1 1];
  if len_cc > 6,
    colors = [colors; rand(len_cc-6,3)];
  end
  
  if D <= 1,
    help('plot3_data');
    error('Number of dimensions is 1 or less.');
  elseif D == 2,    % Two dimensional plot.
    figure; 
    % First data set.
    subplot(1,nr_subplots,1);
    axis square;
    title(titleX, 'interpreter', 'latex');
    set(gca,'XTick',[],'YTick',[])
    hold on;
    for idx = 1:len_cc,
      x = X(1:2, c==cc(idx));
      plot(x(1,:), x(2,:), 'o', 'Color', colors(idx,:));
    end
    hold off;
    
    if nr_subplots == 2,
      % Second data set.
      subplot(1,nr_subplots,2);
      axis square;
      set(gca,'XTick',[],'YTick',[])
      title(titleY, 'interpreter', 'latex');
      hold on;
      for idx = 1:len_cc,
        x = Y(1:2, c==cc(idx));
        plot(x(1,:), x(2,:), 'o', 'Color', colors(idx,:));
      end
      hold off;
    end
    
  elseif D >= 3,    % Three dimensional plot; plotting the first 3 dimensions.
    figure; 
    % First data set.
    subplot(1,nr_subplots,1);
    axis square;
%     set(gca,'XTick',[],'YTick',[])
    title(titleX, 'interpreter', 'latex');
    hold on;
    for idx = 1:len_cc,
      x = X(1:3, c==cc(idx));
      plot3(x(1,:), x(2,:), x(3,:), 'o', 'Color', colors(idx,:));
    end
    hold off;
    
     if nr_subplots == 2,
      % Second data set.
      subplot(1,nr_subplots,2);
      axis square;
%       set(gca,'XTick',[],'YTick',[])
      title(titleY, 'interpreter', 'latex');
      hold on;
        for idx = 1:len_cc,
          x = Y(1:3, c==cc(idx));
          plot3(x(1,:), x(2,:), x(3,:), 'o', 'Color', colors(idx,:));
        end
      hold off;
    end
  end
  
  set(gca, ...
  'Box'         , 'on');

end