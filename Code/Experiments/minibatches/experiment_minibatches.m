clear all; clc;

d = 5;            % Dimensionality to reduce to.
init = 3;         % randn, PCA, LDA or RCA.
m = 2000;         % Number of points to look at per iteration.
p = 5/100;        % Percentage of points used for cross-validation.
lambda = 1;       % Learning rate first hyperparameter.
t0 = 50;          % Learning rate second hyperparameter.
max_iter = 3000;  % Maximum number of iterations.
window_len = 25;  % Window length---after how many iterations we stop the optimisation.
sw_plot = 0;      % Switch for plotting

DATASET = {'usps','magic'};                    % Data set name.
NCA_OBJ = 'nca_obj_simple';                           % Objective function.
NR_REPEATS = 5;                                       % Number of repeats.

if ~isunix,
  root_path = 'D:\Diss\Results\minibatches\';
  ff = 'results-windows.txt';
else
  root_path = '~/Documents/Diss/Results/minibatches/';
  ff = 'results-unix.txt';
end

for i = 1:length(DATASET),
  for j = 1:NR_REPEATS,
    % [X,c] = load_data_set('mnist-train-256');   % Train data set.
    % [Xt,ct] = load_data_set('mnist-test-256');  % Test data set.

    [X,c] = load_data_set(DATASET{i});
    % [Xt,ct] = load_data_set('landsat-test');
    [X,c,Xt,ct]=split_data(X,c);

    tic;
    [mapping, to_plot] = run_nca_minibatches(NCA_OBJ, X, c, d, [init m p lambda t0 max_iter window_len]);
    total_time = toc;
    AX = transform(double(X), mapping);
    AXt = transform(double(Xt), mapping);

    if d <= 3 && sw_plot,
      plot3_data(AX,c,'',1);
      plot3_data(AXt,ct,'',1);
    end

    score_nn  = NN_score(AX,c,AXt,ct);
    score_nca = nca_score(AX,c,AXt,ct);

%     image_nr = ceil(rand*1000);
    fid = fopen([root_path DATASET{i} '-' ff], 'a');
    fprintf(fid, '%2.2f %2.2f %2.2f %10.3f 3\n',...
                 100*to_plot.score_best, 100*score_nn, 100*score_nca, total_time); 
%     fprintf(fid, 'im_nr = %d\nd = %d\ninit = %d\nm = %d\np = %2.3f\nlambda = %2.3f\nt0 = %2.3f\n'...
%              , image_nr, d, init, m, p, lambda, t0); 
%     fprintf(fid, 'time = %10.15f\n', total_time);
%     fprintf(fid, 'NN score: %2.3f\nNCA score: %2.3f\n',score_nn*100,score_nca*100);
%     fprintf(fid, '---\n');
    fclose(fid);

    if sw_plot,
      figure(3);
      pp = plot(-to_plot.score_cv(1:min(to_plot.it,max_iter))); hold on;
      set(pp, 'LineWidth', 1.4);
      p_best = plot(to_plot.it_best,-to_plot.score_best,...
              'o','Color',[.6 0 0],'MarkerSize', 5, 'MarkerFaceColor',[.8 .2 .2]);
      xlabel('iterNumber');
      ylabel('error');

      set(gcf, 'PaperPositionMode', 'auto');
      print(gcf, '-depsc2', [root_path  num2str(image_nr) '.eps']);
      close all;
    end
  end
end