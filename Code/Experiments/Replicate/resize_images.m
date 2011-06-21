function [XX] = resize_images(X, d)
%RESIZE_IMAGES Resizes a data set of square images.
%
%     [XX] = resize_images(X, d),
%
% Inputs:
%          X DxN original data. In this case data consists of images that
%            are reshaped as column vectors as stacked inside of a matrix.
%          d 1x1 dimension to resize the images.
%
% Outputs:
%         XX dxN Resized images. 

% Dan Oneata, June 2011
  
  [D, N] = size(X);
  dim = sqrt(D);
  dim_r = sqrt(d);
  
  XX = zeros(d, N);
  
  for i = 1:N,
    im = reshape(X(:,i), dim, dim);
    im_r = imresize(im, [dim_r dim_r]);
    XX(:,i) = im_r(:);
  end

end