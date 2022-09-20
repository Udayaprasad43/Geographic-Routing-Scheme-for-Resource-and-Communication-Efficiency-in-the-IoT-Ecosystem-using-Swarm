clc
clear
close all

% The average RSSI reading as a function of the distance (on logarithmic scale).							
% 
% pathloss exponent 1.86  =   linspace(0,-95,30)
% pathloss exponent 2.14  =   linspace(0,-110,30)
% pathloss exponent 2.47  =   linspace(0,-130,30)

rssi_186=linspace(0,-95,30);
rssi_214=linspace(0,-110,30);
rssi_247=linspace(0,-130,30);

% The SNR reading as a function of the distance (on logarithmicscale) for MHC
% 
% pathloss exponent 1.86  =   linspace(112,21,30)
% pathloss exponent 2.14  =   linspace(112,10,30)
% pathloss exponent 2.47  =   linspace(112,-9,30)

snr_186=linspace(112,21,30);
snr_214=linspace(112,10,30);
snr_247=linspace(112,-9,30);

% The path-loss versus the log-distance for MHC
% 
% pathloss exponent 1.86  =   [1 31 linspace(44,75,9)]
% pathloss exponent 2.14  =   [1 37 linspace(51,86,9)]
% pathloss exponent 2.47  =   [1 42 linspace(60,99,9)]

mhc_186=[1 31 linspace(44,75,9)];
mhc_214=[1 37 linspace(51,86,9)];
mhc_247=[1 42 linspace(60,99,9)];

% The energy consumption of both retransmission schemes
% 
% End-to-end energy transmission Schema with NRZ encoding         =   [0  0.004   0.008   0.012   0.018   0.026   0.037   0.051   0.071   0.098 ]
% Hop-by-hop energy transmission Schema with NRZ encoding         =   +3%
% End-to-end energy transmission Schema with Manchester encoding  =   +6%
% Hop-by-hop energy transmission Schema with Manchester encoding  =   +8%

e_cons(1,:)=[0  0.004   0.008   0.012   0.018   0.026   0.037   0.051   0.071   0.098 ];
e_cons(2,:)=e_cons(1,:) + (0.03.*e_cons(1,:));
e_cons(3,:)=e_cons(2,:) + (0.06.*e_cons(2,:));
e_cons(4,:)=e_cons(3,:) + (0.08.*e_cons(3,:));





figure
plot(rssi_186,'bo')
hold on
plot(rssi_214,'b>')
plot(rssi_247,'b*')
axis([0 40 -140 20])
x=[0 20 40];
ax = gca;
set(gca,'XTick',x)
ax.XAxis.TickLabel = {'10^0','10^1','10^2'};
title('The average RSSI reading as a function of the distance (on logarithmic scale)')
xlabel('Distance(meter)')
ylabel('RSSI(dBm)')
legend('pathloss exponent 1.86','pathloss exponent 2.14','pathloss exponent 2.47')


figure
plot(snr_186,'bo')
hold on
plot(snr_214,'b>')
plot(snr_247,'b*')
axis([0 40 -20 130])
x=[0 20 40];
ax = gca;
set(gca,'XTick',x)
ax.XAxis.TickLabel = {'10^0','10^1','10^2'};
title('The SNR reading as a function of the distance (on logarithmicscale) for MHC')
xlabel('Distance(meter)')
ylabel('SNR(dBm)')
legend('pathloss exponent 1.86','pathloss exponent 2.14','pathloss exponent 2.47')



figure
plot(mhc_186,'bo-')
hold on
plot(mhc_214,'b>-')
plot(mhc_247,'b*-')
axis([1 15 0 110])
x=[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15];
ax = gca;
set(gca,'XTick',x)
ax.XAxis.TickLabel = {'1','5','10','15','20','25','30','35','40','45','50','55','60','65','70'};
title('The path-loss versus the log-distance for MHC')
xlabel('Distance(meter)')
ylabel('Path loss(dBm)')
legend('pathloss exponent 1.86','pathloss exponent 2.14','pathloss exponent 2.47')




figure
plot(e_cons(1,:),'b+-')
hold on
plot(e_cons(2,:),'m+--')
plot(e_cons(3,:),'b*-')
plot(e_cons(4,:),'m*--')
axis([1 15 0 0.1])
title('The energy consumption of both retransmission schemes')
xlabel('Distance(meter)')
ylabel('Path loss(dBm)')
legend('End-to-end energy transmission Schema with NRZ encoding','Hop-by-hop energy transmission Schema with NRZ encoding','% End-to-end energy transmission Schema with Manchester encoding','Hop-by-hop energy transmission Schema with Manchester encoding','Location','southeast')
