function bfoa(handles)

PL=2000;
stopsim = 0;
N=length(handles.nodex);
p=0.05;
Eo=0.5;
BSx=11.5;
BSy=11.5;

x=handles.nodex;
y=handles.nodey;

    % No of clusters
    Nch = round(p*N);

    % Initialise energy vector
    E = Eo*ones(1,N);

    nVar=Nch*2;            % Number of Decision Variables

    VarSize=[1 nVar];   % Size of Decision Variables Matrix

    VarMin=0;         % Lower Bound of Variables
    VarMax= 100;         % Upper Bound of Variables
    xy = [x(:) y(:)];
    x = xy(:,1);
    y = xy(:,2);

    % BFAO Parameters
    % No of chemotactic steps
    Nc = 100;

    % No of reproduction steps
    Nre = 4;

    % No of elimination-dispersal steps
    Ned = 2;

    % No of swimming steps
    Ns = 4;


    S=100;        % No of bacteria

    % BFAO Parameters
    w=1;            % Inertia Weight
    wdamp=0.99;     % Inertia Weight Damping Ratio
    Dattractant=1.5;         % Personal Learning Coefficient
    Hrepellant=2.0;         % Global Learning Coefficient

    % If you would like to use Constriction Coefficients for BFOA,
    % uncomment the following block and comment the above set of parameters.

    % Jcc Limits
    VelMax=0.5*(VarMax-VarMin);
    VelMin=-VelMax;

    % Initialization

    empty_bacteria.Position=[];
    empty_bacteria.Cost=[];
    empty_bacteria.Jcc=[];
    empty_bacteria.Best.Position=[];
    empty_bacteria.Best.Cost=[];

    bacteria=repmat(empty_bacteria,S,1);

    GlobalBest.Cost=inf;

    for i=1:S

        % Initialize Position
    %     bacteria(i).Position=unifrnd(VarMin,VarMax,VarSize);
        bacteria(i).Position=unifrnd(VarMin,10,VarSize);
        % Initialize Jcc
        bacteria(i).Jcc=zeros(VarSize);

        % Evaluation
         bacteria(i).Cost = BFAO_Nutrient_function(bacteria(i).Position,xy,E,BSx,BSy);

        % Update Personal Best
        bacteria(i).Best.Position = bacteria(i).Position;
        bacteria(i).Best.Cost = bacteria(i).Cost;

        % Update Global Best
        if bacteria(i).Best.Cost < GlobalBest.Cost

            GlobalBest=bacteria(i).Best;

        end

    end

    BestCost=zeros(Ned*Nre*Nc,1);

    % BFOA Main Loop
    tt = 1:N;
    it = 0;
%     set(handles.text24,'String','BFAO clustering')
    axes(handles.axes2)
    axis([0 12 0 12])
% figure(3)
    % Elimination Disperal loop
    for l = 1:Ned

        % Reproduction loop
        for k = 1:Nre;

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
    %                 bacteria(i).Cost = cost_function(bacteria(i).Position,xy);
                    bacteria(i).Cost = BFAO_Nutrient_function (bacteria(i).Position,xy,E,BSx,BSy);


                    % Update Personal Best
                    if bacteria(i).Cost<bacteria(i).Best.Cost

                        bacteria(i).Best.Position=bacteria(i).Position;
                        bacteria(i).Best.Cost=bacteria(i).Cost;

                        % Update Global Best
                        if bacteria(i).Best.Cost<GlobalBest.Cost

                            GlobalBest=bacteria(i).Best;

                            % ----------- Visualise ------------------------------
                            plot(xy(:,1),xy(:,2),'.');
                            hold on
                            text(x+1,y,num2str(tt'))
                            CC = GlobalBest.Position;
                            plot(CC(1:2:end),CC(2:2:end),'rs','markerfacecolor','g','markersize',12);

                            voronoi(CC(1:2:end),CC(2:2:end))
                            pause(0.001)
                            hold off
                            % ---------------------------------------------------------

                        end

                    end

                end

                BestCost(it)=GlobalBest.Cost;


                txt = sprintf('Ned=%d, Nre=%d, Nc=%d : Best Cost= %f\n',l,k,j,BestCost(it));
%                 set(handles.text25,'String',txt);

                w=w*wdamp;

                if it>20
                    if BestCost(it) == BestCost(it-5);
                        break;
                    end
                end

            end
        end
    end

    BestSol = GlobalBest;
%     set(handles.text24,'String','')
%     set(handles.text25,'String','')
    % Results
    figure(6);
    %plot(BestCost,'LineWidth',2);
    semilogy(BestCost,'LineWidth',2);
    xlabel('Iteration');
    ylabel('Best Cost');
    grid on;
    axes(handles.axes1)
    axis([0 12 0 12])
% figure(1)
    tt = 1:N;
    hold off
    plot(xy(:,1),xy(:,2),'b*');
    hold on
    text(xy(:,1)+1,xy(:,2),num2str(tt'))
    CC = BestSol.Position;
    plot(CC(1:2:end),CC(2:2:end),'rs','markerfacecolor','g','markersize',8);


    % No of rounds starts here
    % Plot

    % For each cluster center find nearest node.
    CCx = CC(1:2:end);
    CCy = CC(2:2:end);

    % Intialise empty CH
    CH = [];
    for ii = 1:Nch

        % Calculate distance of iith cluster center to all nodes
        dist = sqrt((CCx(ii)-xy(:,1)).^2 + (CCy(ii)-xy(:,2)).^2);

        % Remove previously selected CHs
        dist(CH) = Inf;

        % find nearest node to iith cluster center
        [v, ix] = min(dist);

        % Store nearest neighbour as cluster head
        CH = [CH ix];


    end

    plot(x(CH),y(CH),'ro','markerfacecolor','r','markersize',8)

    voronoi(x(CH),y(CH))
    legend('Nodes','BFOA cluster center','CH')
    Avec = zeros(1,10000);
    Evec = zeros(1,10000);
    Dvec = zeros(1,10000);
    Vvec = zeros(1,10000);
    Pvec = zeros(1,10000);

    tt = 1:N;

    colors = {'r','g','b','m','c','k','y'};

    showround = 2;

    for r11 = 1:10000

       % Variable for speed
%         if get(handles.checkbox1,'Value')==1 % Make it 1 for high speed or 0 for low speed
%             speed1 = 0;
%             pause(0.001)
%         else
%             speed1 = 1;
%         end

speed1=round(rand);

        % Perform communication
        % Cluster nodes as per current cluster head
        Cid = cluster_node(CH,xy);

        % Dead node id
        Did = find(E<=0);

        if speed1 ==0
          axes(handles.axes1)
          
% figure(1)
            hold off


        % ---------------- Plotting --------------- 
        plot(xy(:,1),xy(:,2),'b*');
        hold on
        text(xy(:,1)+1,xy(:,2),num2str(tt'))

        plot(CC(1:2:end),CC(2:2:end),'rs','markersize',12);

        plot(x(CH),y(CH),'ro','markerfacecolor','r','markersize',8)

        % Plot dead nodes
        plot(x(Did),y(Did),'ks','markerfacecolor','k','markersize',8)
        voronoi(x(CH),y(CH))

        % Plot basestation
        plot(BSx,BSy,'rs','markerfacecolor','c','markersize',10)
        text(BSx+0.5,BSy,'BS','fontsize',10,'fontweight','bold','color','b')

        for ii = 1:Nch

            % Get all index of iith cluster
            idx= find(Cid==ii);

            % highlight with respective color
            plot(x(idx),y(idx),'o','color',colors{ii})
        end
        title(['Round = ' num2str(r11)])
%         axis([-5 BSx+5 -5 BSy+5])
    axis([0 12 0 12])
        end
        % ----------------------------------------

        % Perform communcation

        % Packate count for cluster heads
        Pcount = zeros(1,length(CH));
        % From nodes to CH
        for ii = 1:N

            % if node is dead then dont perform any communication
            if ismember(ii,Did)
                continue;
            end
            % Get cluster ID
            idc = Cid(ii);

            % Get x and y cordinate of respective CH
            chx = x(CH(idc));
            chy = y(CH(idc));

           if  speed1 ==0
            % Perform communication
            plot([x(ii) chx],[y(ii) chy],'g-')
            end

            % Calculate travelling distance
            dist = sqrt((x(ii)-chx)^2+(y(ii)-chy)^2);

            % Calculate transmission energy
            Etx = calc_tx_energy(dist,PL);

            % Reduce it from transmitter node
            E(ii) = E(ii)- Etx;

            % Calcualte receiving energy
            Erx = calc_rx_energy(PL);

            % Reduce it from received cluster head
            E(CH(idc)) = E(CH(idc))-Erx;
    %         if ii~=CH(idc) % If not cluster head
    %             continue;
    %         end


                Pcount(idc) = Pcount(idc)+1;

        end


        % From CH to BS
        for ii = 1:length(CH)

            % Get cordinates of CH
            chx = x(CH(ii));
            chy = y(CH(ii));

            if  speed1 ==0
                % Show communication Line
                plot([BSx chx],[BSy chy],'m--','linewidth',2)
            end

            % Calculate transmission energy
            Etx = calc_tx_energy(dist,PL*Pcount(ii));

            % Reduce it from transmitter node
            E(CH(ii)) = E(CH(ii))- Etx;
        end

        % If any cluster head dies then run BFOA to find new CH
    %     if sum(E(CH)<=0)>=1
        if rem(r11,10) ==0

            disp('========= BFAO clustering ==================')
%              set(handles.text24,'String','Clustering using BFAO')
            % Remove died ID and create new cluster
            Did = find(E<=0);

            xtemp = x;
            ytemp = y;

            xtemp(Did) = [];
            ytemp(Did) = [];

            xytemp = [xtemp(:) ytemp(:)];

            BestSol = BFAO_clustering(bacteria,xytemp,VarMax,VarMin,VarSize,GlobalBest,E,BSx,BSy,speed1,handles);

            GlobalBest = BestSol;

            % Get new cluster center
            CC = BestSol.Position;

            CH = determine_new_CH2(CC,Nch,xy,Did,E);

            temp1 = [x(CH)';y(CH)'];

            newCC = temp1(:)';
            BestSol.Position = newCC;
        end
%         set(handles.text24,'String','')
%     set(handles.text25,'String','')
        % make negative values to zero
        E(E<0) = 0;

        % Calculate number of alive nodes
        Nalive = sum(E>0);

        % Calculate number of dead nodes
        Ndead = sum(E<=0);

        % Calcualte residual energy
        Renergy = sum(E);

        % Calculate variance
        var1 = var(E);

        % Throughput
        TP = sum(Pcount)*PL;

        if speed1==0
%            axes(handles.axes2)
figure(2)
           bar(1:N,E)
           xlabel('Node number');
           ylabel('Remaining Energy')
           hold off
        end

        Avec(r11) = Nalive;
        Evec(r11) = Renergy;
        Dvec(r11) = Ndead;
        Vvec(r11) = var1;
        Pvec(r11) = Avec(r11)*PL;

        fprintf('Round = %d, Alive node = %d, Residual Energy = %f\n',r11,Nalive,Renergy)
        if Nalive<Nch+2
            break;
        end
%         set(handles.text16,'String',num2str(r11))
%         set(handles.text18,'String',num2str(Avec(r11)))
%         set(handles.text20,'String',num2str(Evec(r11)))
%         set(handles.text22,'String',num2str(Vvec(r11)))
        if stopsim == 1
            disp('stopsim')
            break;
        end
        pause(0.00000000000000000000000000000000001)

    end



    % Get the values
    Evec1op = Evec(1:r11);
    Avec1op = Avec(1:r11);
    Dvec1op = Dvec(1:r11);
    Vvec1op = Vvec(1:r11);
    Pvec1op = Pvec(1:r11);
    Pvec1op = cumsum(Pvec1op);