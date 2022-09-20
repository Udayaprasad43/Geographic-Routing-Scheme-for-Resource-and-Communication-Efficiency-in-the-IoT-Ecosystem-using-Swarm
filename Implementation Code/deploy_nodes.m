function [nodex_g,nodey_g,nodex_e,nodey_e,nodex,nodey]=deploy_nodes

high=10; % upper bound for node value
low=0; % lower bound for node value
% promt='Enter the number of nodes to be deployed: '; % asks the user to enter the total number of nodes to be deployed
% good_node=input(promt); % node count (good nodes)
good_node=100;

for i=1:good_node % x and y coordinates for good node nodes, calculating all the good nodes coordinates
    nodex_g(i)=low+(high-low).*rand(1,1); 
    nodey_g(i)=low+(high-low).*rand(1,1);
end

perc=10; % 10% are bad nodes, this value can be changed as per requirement
enc=ceil((perc*good_node)/100); % error node count

for i=1:enc % x and y coordinates for error node, calculating all bad nodes coordinates
    nodex_e(i)=low+(high-low).*rand(1,1);
    nodey_e(i)=low+(high-low).*rand(1,1);
end

if perc==0 % in case no bad node is added
    nodex_e=[];
    nodey_e=[];
end

nodex=[nodex_g nodex_e]; % all x coordinates nodes, this includes good and bad nodes
nodey=[nodey_g nodey_e]; % all y coordinates nodes
    
figure(1) % figure to display all the nodes at once. 
hold on
for i=1:good_node
    plot(nodex_g(i),nodey_g(i),'b*') % good nodes are shown in blue
    text(nodex_g(i)+0.05,nodey_g(i),num2str(i))
end
for i=1:enc
    plot(nodex_e(i),nodey_e(i),'r*') % bad nodes are shown in red
    text(nodex_e(i)+0.05,nodey_e(i),num2str(i+good_node))
end
hold off
title('Placement of all nodes')
axis equal

   