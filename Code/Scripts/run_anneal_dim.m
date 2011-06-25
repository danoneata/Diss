%% Perform dimensionality annealing:
close all; clear all; 

dataset = 'pima';
[X, c] = load_data_set(dataset);
d = 2;

[AX, mapping, ff, xLabels] = anneal_dim(X, c, d);

plot3_data(AX, c, ...
  ['NCA transformation by annealing the dimensionality on \texttt{' dataset '}'], 1);
hh = plot_anneal_dim(ff, xLabels);

%% Save images:
fn = ['nca-sa-' dataset '-d-' num2str(d)];
print(1, '-depsc2', fn);
print(1, '-dpdf', fn);
print(hh, '-depsc2', [fn '-score']);
print(hh, '-dpdf', [fn '-score']);

%% Compare to simple NCA transformation:
[AX, mapping] = run_nca(X, c, d, 'nca_obj_simple', [0 0]);
plot3_data(AX, c, ['NCA transformation on \texttt{' dataset '}'], 1);
fn = ['nca-' dataset '-d-' num2str(d)];

%% Save images for comparison:
print(gcf, '-depsc2', fn);
print(gcf, '-dpdf', fn);

