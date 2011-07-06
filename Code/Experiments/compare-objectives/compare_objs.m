datasets = {'wine', 'iris', 'glass', 'balance', 'ionosphere', 'yeast', ...
            'segment', 'transfusion', 'pima'};
objs = {'nca_obj_simple', 'nca_obj_cs', 'nca_obj_cs_back'};
% objs = {'nca_obj_cs_back'};
T = 20;

for idd = 1:length(datasets),
  [X, c] = load_data_set(datasets{idd});
  D = size(X, 1);
  if D == 4,
    dims = [2 3 D]; 
  elseif D == 5,
    dims = [2 3 4 D];
  else 
    dims = [2 3 4 5 D];
  end
  for id = 1:length(dims),
    d = dims(id);
    scores = zeros(T,2*length(objs) + 2);
    for t = 1:T,
      [Xtrain, ctrain, Xtest, ctest] = split_data(X, c);
      for oo = 1:length(objs),
        [AXtrain, mapping] = run_nca(objs{oo}, Xtrain, ctrain, d, [-50 0 350]);
        AXtest = transform(Xtest, mapping);
        % Compute scores:
        nns = NN_score(AXtrain, ctrain, AXtest, ctest);
        ncs = nca_cls(objs{oo}, AXtrain, ctrain, AXtest, ctest);
        scores(t,2*oo-1:2*oo) = [nns ncs];
      end
      % nca_obj_simple trained using bolddriver
      [AXtrain, mapping] = run_nca(objs{1}, Xtrain, ctrain, d, [-50 2 500]);
      AXtest = transform(Xtest, mapping);
      % Compute scores:
      nns = NN_score(AXtrain, ctrain, AXtest, ctest);
      ncs = nca_cls(objs{1}, AXtrain, ctrain, AXtest, ctest);
      scores(t,2*oo-1:2*oo) = [nns ncs];      
    end
    mean_scores = mean(scores,1);
    std_scores = std(scores,1);
    % Save results:
    scores = [mean_scores std_scores];
    fn = [datasets{idd} '-' d '.txt'];
    dlmwrite([root fn], scores, '-append', 'delimiter', '&');
  end
end