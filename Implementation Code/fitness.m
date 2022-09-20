function fit=fitness(int)

% trust measurement
alpha=0.6;
beta=0.4;
DP_f=1;
CP_f=1;
T_ab=alpha*DP_f + beta*CP_f;

% residual battery life
% E=input('Enter power for each node: ');
% Ef=input('Enter power required to forward single packet: ');
% Eq=input('Enter dissipated power of the equipment: ');
E=100;
Ef=60;
Eq=30;
RBL=E/(Ef+Eq);

% hop count
Hopcount=int;

% fitness function
k1=0.1;
fit=(Hopcount*k1) + (1-T_ab) + (1/RBL);

% disp(['Fitness function value for the route= ' num2str(fit)])

end