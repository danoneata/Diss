function view_results(type_transform, dataset, subsample, init, d)

  [X, c] = load_data_set(dataset);
  X = double(X);
  X = X(:,1:subsample:end);
  c = c(1:subsample:end);

  % Normalize data?
  X = normalize_data(X);
  
  D = size(X,1);

  file_name = ['~/Documents/Diss/Results/' type_transform '-' ...
              dataset '-ss-' num2str(subsample) '-' init '-d-' num2str(d) '.txt'];
            
  rr = dlmread(file_name);
  score = ceil(rr(1,1));
  
  title = [upper(type_transform) ' on \textit{' dataset '}. Score: ' num2str(-score) '.'];

  A = reshape(rr(2,:), [], D);            
  plot3_data(A*X, [], c, title);

end