function plot3_data(X,c)
% PLOT3_DATA Plots data in 3D space.
%   X - DxN matrix representing the data. If D > 3 then only the first 3
%   dimensions are used for plotting (i.e., X(1:3,:)).
%   c - 1xN vector that specifies the class of each point from X.
%
% Dan Oneata
% 03/04/2011

  cc = unique(c);
  D = size(X,1);
  if D <= 1,
    help('plot3_data');
    error('Number of dimensions is 1 or less.');
  elseif D == 2,
    figure; hold on;
    for idx = 1:length(cc),
      x = X(1:2, c==cc(idx));
      plot(x(1,:), x(2,:), 'o', 'Color', rand(1,3));
    end
    hold off;
  elseif D >= 3,
    figure; hold on;
    for idx = 1:length(cc),
      x = X(1:3, c==cc(idx));
      plot3(x(1,:), x(2,:), x(3,:), 'o', 'Color', rand(1,3));
    end
    hold off;
  end

end