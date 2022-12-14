function CH = determine_new_CH2(CC,Nch,xy,Did,E)

% No of rounds starts here
%% Plot

% For each cluster center find nearest node.
CCx = CC(1:2:end);
CCy = CC(2:2:end);

% Intialise empty CH
CH = zeros(1,Nch);
for ii = 1:Nch

    % Calculate distance of iith cluster center to all nodes
    dist = sqrt((CCx(ii)-xy(:,1)).^2 + (CCy(ii)-xy(:,2)).^2);

    % Remove previously selected CHs
    dist(CH(1:ii-1)) = Inf;
    
    % Remove dead nodes
    dist(Did) = Inf;

    % find nearest node to iith cluster center
    [v, ix] = sort(dist);

    % Find maxiimum energy in nearest 5 nodes
    [v2,ix2] = max(E(ix(1:5)));
    
    % Store nearest neighbour as cluster head
    CH(ii) = ix(ix2(1));
end