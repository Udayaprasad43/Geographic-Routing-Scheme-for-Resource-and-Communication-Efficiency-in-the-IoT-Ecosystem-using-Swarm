function E1 = determine_Energy(CC,Nch,xy,Did,E)

% This function helps finding energy of nearest nodes

% No of rounds starts here
%% Plot

% For each cluster center find nearest node.
CCx = CC(1:2:end);
CCy = CC(2:2:end);

% Intialise empty energy vect
E1= zeros(1,Nch);
for ii = 1:Nch

    % Calculate distance of iith cluster center to all nodes
    dist = sqrt((CCx(ii)-xy(:,1)).^2 + (CCy(ii)-xy(:,2)).^2);

    % Remove dead nodes
    dist(Did) = Inf;
    
    % Get neighbour nodes energy
    neibour1 = find(dist<10);
%     [v, neibour1] = min(dist);
    
    % Store nearest neighbour as cluster head
    E1(ii) = sum(E(neibour1))/length(neibour1);


end