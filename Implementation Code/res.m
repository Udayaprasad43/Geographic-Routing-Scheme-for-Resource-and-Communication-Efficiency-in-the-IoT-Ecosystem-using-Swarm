function res(handles)

% disp('---------------------------------------------------------------------')
% disp('Final results')
% disp('---------------------------------------------------------------------')

P_sleep=handles.P_sleep;
gamma=handles.gamma;
delta=handles.delta;
beta=handles.beta;

 pdr_final = handles.pdr_final;
 avgdelay_final = handles.avgdelay_final;
throughput_final = handles.throughput_final;
 detection_ratio_final = handles.detection_ratio_final;

load coeff

figure
plot(rssi_186.*P_sleep,'bo')
hold on
plot(rssi_214.*P_sleep,'b>')
plot(rssi_247.*P_sleep,'b*')
% axis([0 40 -140 20])
x=[0 20 40];
ax = gca;
set(gca,'XTick',x)
ax.XAxis.TickLabel = {'10^0','10^1','10^2'};
title('The average RSSI reading as a function of the distance (on logarithmic scale)')
xlabel('Distance(meter)')
ylabel('RSSI(dBm)')
legend('pathloss exponent 1.86','pathloss exponent 2.14','pathloss exponent 2.47')


figure
plot(snr_186.*gamma,'bo')
hold on
plot(snr_214.*gamma,'b>')
plot(snr_247.*gamma,'b*')
% axis([0 40 -20 130])
x=[0 20 40];
ax = gca;
set(gca,'XTick',x)
ax.XAxis.TickLabel = {'10^0','10^1','10^2'};
title('The SNR reading as a function of the distance (on logarithmicscale) for MHC')
xlabel('Distance(meter)')
ylabel('SNR(dBm)')
legend('pathloss exponent 1.86','pathloss exponent 2.14','pathloss exponent 2.47')



figure
plot(mhc_186.*delta,'bo-')
hold on
plot(mhc_214.*delta,'b>-')
plot(mhc_247.*delta,'b*-')
% axis([1 15 0 110])
x=[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15];
ax = gca;
set(gca,'XTick',x)
ax.XAxis.TickLabel = {'1','5','10','15','20','25','30','35','40','45','50','55','60','65','70'};
title('The path-loss versus the log-distance for MHC')
xlabel('Distance(meter)')
ylabel('Path loss(dBm)')
legend('pathloss exponent 1.86','pathloss exponent 2.14','pathloss exponent 2.47')




figure
plot(e_cons(1,:).*beta,'b+-')
hold on
plot(e_cons(2,:).*beta,'m+--')
plot(e_cons(3,:).*beta,'b*-')
plot(e_cons(4,:).*beta,'m*--')
% axis([1 15 0 0.1])
title('The energy consumption of both retransmission schemes')
xlabel('Distance(meter)')
ylabel('Path loss(dBm)')
legend('End-to-end energy transmission Schema with NRZ encoding','Hop-by-hop energy transmission Schema with NRZ encoding','% End-to-end energy transmission Schema with Manchester encoding','Hop-by-hop energy transmission Schema with Manchester encoding','Location','southeast')


figure
x=[1 2 3];
bar(pdr_final);
ax = gca;
set(gca,'XTick',x)
ax.XAxis.TickLabel = {'Route 1','Route 2','Route 3'};
title('Packet delivery ratio')
xlabel('Route no.')
ylabel('Packet delivery ratio')

figure
x=[1 2 3];
bar(avgdelay_final);
ax = gca;
set(gca,'XTick',x)
ax.XAxis.TickLabel = {'Route 1','Route 2','Route 3'};
title('Average delay')
xlabel('Route no.')
ylabel('Delay (seconds)')

figure
x=[1 2 3];
bar(throughput_final);
ax = gca;
set(gca,'XTick',x)
ax.XAxis.TickLabel = {'Route 1','Route 2','Route 3'};
title('Throughput')
xlabel('Route no.')
ylabel('Average throughput (kbps)')


figure
x=[1 2 3];
bar(detection_ratio_final);
ax = gca;
set(gca,'XTick',x)
ax.XAxis.TickLabel = {'Route 1','Route 2','Route 3'};
title('Malacious node detection ratio')
xlabel('Route no.')
ylabel('Detection ratio')