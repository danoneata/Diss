%% Load data:
[X,c] = load_data_set('wine');
[D,N] = size(X);

d = 2;
sw_print = 0;

A = randn(D*d,1);

figure(1), plot_(X,c,'',1);
if sw_print,
  print -depsc2 's5-1.eps'
end



if sw_print,
  system('epstopdf *.eps');
end