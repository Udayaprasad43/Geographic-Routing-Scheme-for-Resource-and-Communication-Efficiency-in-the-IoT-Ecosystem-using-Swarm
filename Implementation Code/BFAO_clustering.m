function BestSol = BFAO_clustering(bacteria,xy,VarMax,VarMin,VarSize,GlobalBest,E,BSx,BSy,plotting,handles)

%% PSO Parameters

% No of swimming steps
Ns = 4;

% No of chemotactic steps
Nc = 100;

% No of reproduction steps
Nre = 4;

% No of elimination-dispersal steps
Ned = 2;


S=100;        % No of bacteria

% PSO Parameters
w=1;            % Inertia Weight
wdamp=0.99;     % Inertia Weight Damping Ratio
Dattractant=1.5;         % Personal Learning Coefficient
Hrepellant=2.0;         % Global Learning Coefficient

% % Jcc Limits
VelMax=0.1*(VarMax-VarMin);
VelMin=-VelMax;


GlobalBest.Cost=inf;
BestCost=zeros(Ned*Nre*Nc,1);

N = size(xy,1);

for i = 1:S
    bacteria(i).Best.Cost = Inf;
end
%% PSO Main Loop
tt = 1:N;
it = 0;
% Elimination Disperal loop
for l = 1:Ned
    
    % Reproduction loop
    for k = 1:Nre
        
        % Chemotactic loop
        for j = 1:Nc
            it = it+1;
            for i=1:S

                % Update Jcc
                bacteria(i).Jcc = w*bacteria(i).Jcc ...
                    +Dattractant*rand(VarSize).*(bacteria(i).Best.Position-bacteria(i).Position) ...
                    +Hrepellant*rand(VarSize).*(GlobalBest.Position-bacteria(i).Position);

                % Apply Jcc Limits
                bacteria(i).Jcc = max(bacteria(i).Jcc,VelMin);
                bacteria(i).Jcc = min(bacteria(i).Jcc,VelMax);

                % Update Position
                bacteria(i).Position = bacteria(i).Position + bacteria(i).Jcc;

                % Jcc Mirror Effect
                IsOutside=(bacteria(i).Position<VarMin | bacteria(i).Position>VarMax);
                bacteria(i).Jcc(IsOutside)=-bacteria(i).Jcc(IsOutside);

                % Apply Position Limits
                bacteria(i).Position = max(bacteria(i).Position,VarMin);
                bacteria(i).Position = min(bacteria(i).Position,VarMax);

                % Evaluation
        %         bacteria(i).Cost = CostFunction(bacteria(i).Position);
                bacteria(i).Cost = BFAO_Nutrient_function(bacteria(i).Position,xy,E,BSx,BSy);


                % Update Personal Best
                if bacteria(i).Cost<bacteria(i).Best.Cost

                    bacteria(i).Best.Position=bacteria(i).Position;
                    bacteria(i).Best.Cost=bacteria(i).Cost;

        %             plot(xy(:,1),xy(:,2),'.');
        %             hold on
        %             CC =  bacteria(i).Best.Position;
        %             plot(CC(1:2:end),CC(2:2:end),'rs','markerfacecolor','g','markersize',12);
        %             pause(0.1)
        %             hold off

                    % Update Global Best
                    if bacteria(i).Best.Cost<GlobalBest.Cost

                        GlobalBest=bacteria(i).Best;

                         if plotting == 0
%                             axes(handles.axes3)
% figure(3)
axes(handles.axes2)
                            % ----------- Visualise ------------------------------
                            plot(xy(:,1),xy(:,2),'b*');
                            hold on
            %                 text(x+1,y,num2str(tt'))
                            CC = GlobalBest.Position;
                            plot(CC(1:2:end),CC(2:2:end),'rs','markerfacecolor','g','markersize',12);

                            voronoi(CC(1:2:end),CC(2:2:end))
                            pause(0.00000000000001)
                            hold off
                            axis([0 12 0 12])
                        % ---------------------------------------------------------
                        end
                    end

                end

            end

            BestCost(it)=GlobalBest.Cost;
 txt = sprintf('Ned=%d, Nre=%d, Nc=%d : Best Cost= %f\n',l,k,j,BestCost(it));
%             set(handles.text25,'String',txt);
   

            pause(0.0000000000000000000000000000001)
            w=w*wdamp;

            if it>20
                if BestCost(it) == BestCost(it-5) || it>100
                    break;
                end
            end
    
        end
    end
end

BestSol = GlobalBest;