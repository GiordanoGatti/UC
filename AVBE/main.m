clear all
close all
clc

%Single ceramic hollow brick wall 15cm mortar lined on both sides with 1.5cm

F = [100 125 160 200 250 315 400 500 630 800 1000 1250 1600 2000 2500 3150 4000 5000]; %1/3 octave bands
h = 0.15;%[m]
c = 340;%[m/s]
ro = 1200;%[kg/m³]
m = h*ro;%[kg/m²]
v = 0.2;%poisson coefficient (dimensionless)
E = 6*(10^9);%[N/m²]
eta = 0.01;%material loss factor (dimensionless)

display('Meisser:')
Rm = meisser(F,m) %predicts R using Meisser formula
display('Sharp Model:')
Rs = sharp_model(F,m,eta,c,ro,v,E,h) %predicts R using Sharp model

figure();
semilogx(F,Rm,'- .green',F,Rs,'- .blue');
grid on;
xlabel('frequency [Hz]');
ylabel('R [dB]');
xlim([100,5000]);
set(gca,'XTick',F)
set(gca,'XTickLabel',sprintf('%3.0f|',F))
legend('Meisser','Sharp Model');

display('Sharp Model:')
Rw = Rw_calc(F(1:(end-2)),Rs(1:(end-2)),-15); %calculates Rw of the Sharp model prediction
C = C_adapt(Rs,Rw); %calculates C of the Sharp model prediction
Ctr = Ctr_adapt(Rs,Rw); %calculates Ctr of the Sharp model prediction
display('Meisser:')
Rw = Rw_calc(F(1:(end-2)),Rm(1:(end-2)),-15); %calculates Rw of the Meisser prediction
C = C_adapt(Rm,Rw); %calculates C of the Meisser prediction
Ctr = Ctr_adapt(Rm,Rw); %calculates Ctr of the Meisser prediction
