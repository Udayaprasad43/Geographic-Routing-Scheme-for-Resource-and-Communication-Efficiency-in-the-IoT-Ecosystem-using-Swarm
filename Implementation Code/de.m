function [ind2,M]=de(link,ind)

% Problem Definiion
CostFunction=@(x) fitness(x);    % Fitness Function

nVar=4;            % Number of Decision Variables

VarSize=[1 nVar];   % Decision Variables Matrix Size

VarMin=0;          % Lower Bound of Decision Variables
VarMax=5;          % Upper Bound of Decision Variables

% DE Parameters

MaxIt=3;      % Maximum Number of Iterations
% MaxIt=size(link,1);

% nPop=5;        % Population Size
nPop=size(link,1);

beta_min=0.1;   % Lower Bound of Scaling Factor F
beta_max=0.2;   % Upper Bound of Scaling Factor

pCR=0.2;        % Crossover Probability

% Initialization

empty_individual.Position=[];
empty_individual.Cost=[];

BestSol.Cost=inf;

pop=repmat(empty_individual,nPop,1);

for i=1:nPop

    pop(i).Position=unifrnd(VarMin,VarMax,VarSize);
%     pop(i).Position=selected;
    
    pop(i).Cost=CostFunction(pop(i).Position);
    
    if pop(i).Cost<BestSol.Cost
        BestSol=pop(i);
    end
    
end

% BestCost=zeros(MaxIt,1);%intialize first colom as 0s

% DE Main Loop

for it=1:MaxIt
%     it
    
    for i=1:nPop
%         i
        
        x=pop(i).Position;
%         disp('pos')
%         disp(x)
        A=randperm(nPop);
        A(A==i)=[];%%i=1 remove 1 from matrix if i=2 remove 2 from matrix
%         disp('matrix position')
%         disp(A)
        a=A(1);
        b=A(2);
        c=A(3);
        
        % Mutation
        %beta=unifrnd(beta_min,beta_max);
        beta=unifrnd(beta_min,beta_max,VarSize);%generate beta as scaling factor
%         disp('F')
%         disp(beta)
%         disp('position(i)')
%         disp(pop(a).Position)
%         disp(pop(b).Position)
%         disp(pop(c).Position)
        y=pop(a).Position+beta.*(pop(b).Position-pop(c).Position);
%         disp('result')
%         disp(y)
        y = max(y, VarMin);
		y = min(y, VarMax);
		
        % Crossover
        z=zeros(size(x));
        j0=randi([1 numel(x)]);
        for j=1:numel(x)
            if j==j0 || rand<=pCR
                z(j)=y(j);
            else
                z(j)=x(j);
            end
        end
        
        NewSol.Position=z;
        NewSol.Cost=CostFunction(NewSol.Position);
%         pause
        if NewSol.Cost<pop(i).Cost
            pop(i)=NewSol;   
            if pop(i).Cost<BestSol.Cost
               BestSol=pop(i);
            end
        end
        
    end
    
    % Update Best Cost        
    BestCost(it,:)=BestSol.Cost;
    
    % Show Iteration Information
%     disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCost(it))]);
%     pause
end
% BestCost
% BestCost_final=BestCost(end);

% Show Results
% 
% figure;
% %plot(BestCost);
% semilogy(BestCost, 'LineWidth', 2);
% xlabel('Iteration');
% ylabel('Best Cost');
% grid on;

for i=1:size(link,1)    
    mins(i)=min(pop(i,:).Cost);
end
[M,I]=min(mins);

eligible=link(I,:);

ind2=[];
for i=1:length(eligible)    
    if eligible(i)==1
        ind2=[ind2 ind(i)];
    end
end



