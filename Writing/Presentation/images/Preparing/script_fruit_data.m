% data file is tab separated with the following fields:
% fruit type
% mass /g (rounded to nearest even number of grams)
% "height"/cm (to nearest mm but probably less reliable than that)
% "width"/cm

% Fruit types
fruits={'Granny smith apple',...
        'Mandarin',...
        'Braeburn apple',...
        'Golden delicious apple',...
        'Cripps Pink Washington USA apple',...
        'Lane Late Spanish jumbo orange',...
        'Morrisons "selected seconds" orange',...
        'Turkey Navel class 1 cal 6 orange',...
        'Belsan Spanish lemons',...
        'lemons unknown type from local shop'};

data=load('fruit_data.txt');
m=data(:,2); % mass
w=data(:,3); % width
h=data(:,4); % height
l=data(:,1); % label
idx_apples=[find(data(:,1)==1);find(data(:,1)==3);find(data(:,1)==4);find(data(:,1)==5)];
idx_orange=[find(data(:,1)==2);find(data(:,1)==6);find(data(:,1)==7);find(data(:,1)==8)];
idx_lemons=[find(data(:,1)==9);find(data(:,1)==10)];
clf; hold on;
plot(w(idx_orange,:),h(idx_orange,:),'ro')
plot(w(idx_apples,:),h(idx_apples,:),'b+')
plot(w(idx_lemons,:),h(idx_lemons,:),'kx')

% Show more scatter in the "selected seconds" oranges. These were cheap becaue
% they were weird or battered.
idx_orange2=[find(data(:,1)==7)];
plot(w(idx_orange2,:),h(idx_orange2,:),'mo')

legend({'oranges','apples','lemons','weird oranges'});
