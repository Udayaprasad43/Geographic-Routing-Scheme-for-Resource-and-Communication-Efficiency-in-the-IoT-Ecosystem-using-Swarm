function [P,M,N,pi,n,Power,Energy_e2e,d_queque,Th,Th_mhc,P_rx2,TR,beta,delta,gamma,P_sleep]=markovmodel(P_tx,P_rx,P_idle,P_startup)

% -------------------------------------------------------------------------
% Pre-requisites
% -------------------------------------------------------------------------
M=10;
% Expected data packet arrival rate at the MAC layer
lambda=rand(1,M);
% the time of inter arrival of packet arrival
delta=rand;
% the independently probability of transmitting DATA packet
beta=rand;
% number of nodes
N=100;

% The steady state probability and the transition probabilities of moving 
% from one state to another can be described as follows:-

% Eq 1-6
for i=1:M
    P=lambda.*delta;
    if i>2
        for j=1:(i-2)
            P=beta.* lambda.* delta ;          
            if j>i
                P(i,j)=(beta.*delta.*lambda(j-i+1).*delta) + (1-(beta.*delta)).*lambda(j-1);
            end
            P(i,M)=(beta.*delta.*lambda(M-i+1).*delta) + (1-(beta.*delta)).*lambda(M-1);
        end
    end
end


% The steady state equations for each schedule-driven
% duty-cycle node operation are described as follows:

% Eq 7-9
pi=(1-(lambda.*delta)) + (beta.*delta) ;
for i=2:(M-1);
    pi(i,:)=(pi(i-1).*beta.*delta) + pi(i).*(1-(lambda.*delta)-(beta.*delta)) + pi(i+1).*beta.*delta;
end

% -------------------------------------------------------------------------
% ENERGY CONSUMPTION MODELLING
% -------------------------------------------------------------------------
% Total power consumption for the four power states during the transmission period
% 1- P_tx
% 2- P_rx
% 3- P_idle
% 4- P_sleep

% Eq 10
% Number of hops
n=10;
% Power for startup radio frequency(RF)
% P_startup=rand/2;
% Power amplifier
c=rand;
gamma=rand;
Dmax=rand;
alpha=rand;
N=rand;
P_amp=(c.*gamma.*((Dmax/n).^alpha))./N;
PACKETLen=10;
R=rand;
% P_rx=rand;
% P_tx=rand;
% P_idle=rand;
P_sleep=rand;

for i=1:n
    Power(i)=(2.*P_startup) + ((PACKETLen/R).*((i-1).*P_rx)) + (i.*P_tx) + (2.*P_tx) + P_idle + P_amp + P_sleep;
end

% the total expected energy consumption of transmitting a packet from the 
% source to the sink can obtained as

% Eq 15
Pst=rand;
Energy_e2e=(1/Pst).*sum(sum(pi));


% -------------------------------------------------------------------------
% DELAY MODELLING
% -------------------------------------------------------------------------
% the mean queue delay of the DATA packet 

% Eq 16
d_queque=(sum(sum(pi)))./(lambda.*delta);

% -------------------------------------------------------------------------
% THROUGHPUT MODELLING
% -------------------------------------------------------------------------

% the throughput is given by a fraction of the length of the node cycle time

% Eq 27
Th= 1- pi(1,1);

% the throughput of the multi hop network can be determined 

% Eq 28
Th_mhc= N.*(1-pi(1,1)).*Pst;

% -------------------------------------------------------------------------
% THE LOG-NORMAL PATH-LOSS MODEL
% -------------------------------------------------------------------------
% the relationship between the path-loss and the multi-hop-distance
% may be obtained by

% Eq 31,32
d=rand(1,10);
PL=rand(1,10);
for i=1:(n-1)
    PL(i+1)=PL(i) + 20.*log((i+1)/i);
    P_rx2(i)=P_tx.*(i-PL(i));
end

% the transmission range (TR) of any single-hop-distance is given as

% Eq 34
TR = sqrt(((P_rx2 + P_tx).*N)./(1-2));
     








