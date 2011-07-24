close all; clear all;

sw_print = 0;
[X,c] = load_data_set('fruit');
X(1,:) = [];
[X tr] = normalize_data(X);
tr.A = tr.std;
% X(:,c==1) = [];
% c(c==1) = [];

data.X = X;
data.y = c;

figure(1); set(gca, 'XTick',[], 'YTick', []); set(gca, 'Box', 'on'); axis equal;
ppatterns(data);

q = [7.7 9.5];
q = transform(q', tr);
hold on; plot(q(1),q(2),'cp','MarkerSize',15,'MarkerFaceColor','c');

[AX, mp] = run_nca('nca_obj_simple', X, c, 2, [3,0,100]);

options.dist = 15;
% plot_metric(mp.A,q, options);
A = 1/20*mp.A;
S = A'*A;
Ellipse_plot(S,q);

if sw_print,
  figure(1);
  set(gcf, 'PaperPositionMode', 'auto');
   print -depsc2 'mahalanobis.eps'
   system('epstopdf mahalanobis.eps');
end

data2.X = AX;
data2.y = c;

figure; set(gca, 'XTick',[], 'YTick', []); set(gca, 'Box', 'on'); axis equal;
ppatterns(data2);

Aq = mp.A*q;
hold on; plot(Aq(1),Aq(2),'cp','MarkerSize',15,'MarkerFaceColor','c');

% plot_metric(eye(2), Aq, options);
Ellipse_plot(1/5e2*eye(2),Aq);

if sw_print,
  figure(2);
  set(gcf, 'PaperPositionMode', 'auto');
   print -depsc2 'euclidean.eps'
   system('epstopdf euclidean.eps');
end