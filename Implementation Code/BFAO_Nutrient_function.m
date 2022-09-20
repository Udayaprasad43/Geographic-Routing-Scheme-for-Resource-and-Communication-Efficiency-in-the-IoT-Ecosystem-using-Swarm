function CF = BFAO_Nutrient_function (ch,xy,E,BSx,BSy)

% no of clusters
chn = length(ch)/2;

% no of nodes
n = size(xy,1);

% Parameter 1: Centrality
xs = repmat(xy(:,1),1,chn);
ys = repmat(xy(:,2),1,chn);

chx = repmat(ch(1:2:end-1),n,1);
chy = repmat(ch(2:2:end),n,1);

d = sqrt((xs-chx).^2+(ys-chy).^2);

% min dist
mind =  min(d,[],2);

cent = sum(mind);

% Parameter 2: Distance to Basestation
BSdist = sum(sqrt((ch(1:2:end-1)-BSx).^2+(ch(2:2:end)-BSy).^2));


% Cost function
CF = cent;

Did = find(E<=0);


% Parameter 3: Remaining energy
E1 = determine_Energy(ch,chn,xy,Did,E);

CF = CF/(mean(E1)+1);


