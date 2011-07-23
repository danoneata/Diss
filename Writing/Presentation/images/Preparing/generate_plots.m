slide_number = 1;
sw_save = true;

set(0,'defaulttextinterpreter','latex')

switch slide_number,
  case 1
    [X,c] = load_data_set('fruit');
    X(1,:) = [];
    X(:,c==1) = [];
    c(c==1) = [];
    
    plot_(X,c,'',1); hold on;
    
    if sw_save,
      print -depsc2 'knn-init.eps'
      system('epstopdf knn-init.eps');
    end
     
     q = [7.8 9.3];
     hE = plot(q(1),q(2),'p','MarkerFaceColor' ,[0.5 0 .5],...
        'MarkerEdgeColor' , [0.5 0 0.5]);
     
%      hLegend = legend( ...
%       [hE], ...
%       'Query point $x^*$');
%        set(hLegend, 'interpreter', 'latex', 'location', 'SouthEast')
       
    if sw_save,
      print -depsc2 'knn-query.eps'
      system('epstopdf knn-query.eps');
    end
end