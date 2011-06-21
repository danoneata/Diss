% Select randomly nd digits from first digit fd to last digit ld:
clear all; close all;
fd = 1;
ld = 5;
dif = ld - fd + 1;
nd = 50;

% Prepare data:
% rand('seed',100);
% randn('seed',100);

[X,c] = load_data_set('usps');
[D, N] = size(X);

XX = zeros(D, nd*dif);
cc = zeros(1, nd*dif);

for dd = fd:ld,
  id = find(c==dd+1);
  id = id(randperm(numel(id)));
  XX( :, (dd-fd)*nd + 1:(dd-fd+1)*nd ) = X( :, id(1:nd) );
  cc( 1, (dd-fd)*nd + 1:(dd-fd+1)*nd ) = c( 1, id(1:nd) );
end

XX = resize_images(XX, 8);
% [mX,mp] = nca(XX',cc',2);

XX = normalize_data(XX);
[AX, mapping] = run_nca(XX, cc, 2, [0 0]);
plot3_data(AX, cc);