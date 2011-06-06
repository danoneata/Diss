function [X, c] = load_synthetic_data(N, D, type, seed)

  if exist('seed','var'),
    rand('seed',seed);
    randn('seed',seed);
  end

  switch type
    case 'circles'
      % Generate random angles:
      theta = 2*pi*rand(1,N);
      
      % Radii for the two clases:
      r1 = 10*rand;
      r2 = 10*rand;
      
      % Number of points in the two classes:
      nr1 = floor(N/2);
      nr2 = N - nr1;
      
      theta1 = theta(1:nr1);
      theta2 = theta(nr1+1:N);

      % Class labels:
      c = [zeros(1,nr1) ones(1,nr2)];
      assert(length(c)==N);

      % Data:
      X = [r1*cos(theta1) r2*cos(theta2); r1*sin(theta1) r2*sin(theta2)];
      
      % Add extra D-2 dimensions of Gaussian noise:
      X = [X; randn(D-2,N)];
    otherwise
      help('load_synthetic_data');
      error('Error: undefined type!');
  end

end