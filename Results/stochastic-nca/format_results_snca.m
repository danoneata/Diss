DATASET   = {'balance', 'ionosphere', 'iris', 'wine'};
% DATASET = {'balance','glass','ionosphere','iris','wine','yeast'};
fid = fopen('formated-results.txt', 'a');

ALL_DIMS = 1;
T = 20;

for i = 1:length(DATASET),
  FILE_NAME = [DATASET{i} '-results-unix.txt'];
  data = dlmread(FILE_NAME);
  
  data_2 = data(data(:,end)==2,1:3);
  data_D = data(data(:,end)==data(end,end),1:3);

    fprintf(fid, '\\texttt{%s}', DATASET{i})
    fprintf(fid,'&$2$&$%s$&$%s$&$%s$\\\\ \n'   ,...
     errorbar_str(data_2(:,1)), errorbar_str(data_2(:,2)), errorbar_str(data_2(:,3))...
     );
   fprintf(fid,'&$D=%d$&$%s$&$%s$&$%s$\\\\ \n'   ,...
     data(end,end), errorbar_str(data_D(:,1)), errorbar_str(data_D(:,2)), errorbar_str(data_D(:,3))...
     );
  fprintf(fid,'\\midrule\n');
end
fclose(fid);

