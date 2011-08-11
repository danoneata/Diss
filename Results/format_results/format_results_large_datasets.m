if unix,
  rt = '~/Documents/Diss/Results/';
else
  rt = 'D:/Diss/Results/';
end

pths = {'subsample/','minibatches/','stochastic-nca/','stochastic-nca-cs/'};

DATASET   = {'usps','magic','mnist'};
fid = fopen('formated-results.txt', 'a');

for i = 1:length(DATASET),
  fprintf(fid, '\\texttt{%s}', DATASET{i});
  for j = 1:length(pths),
    FILE_NAME = [rt pths{j} DATASET{i} '-results-windows.txt'];
    data = dlmread(FILE_NAME);
 
    fprintf(fid, '&$%s$&$%s$&$%s&$%s$'   ,...
     errorbar_str(data(:,1)), errorbar_str(data(:,2)),...
     errorbar_str(data(:,3)), errorbar_str(data(:,4))...
     );
  end
  fprintf(fid,'\\\\midrule\n');
end
fclose(fid);

