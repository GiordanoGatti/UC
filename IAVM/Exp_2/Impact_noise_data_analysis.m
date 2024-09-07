clear all
close all
clc
%% The data of the impact sound pressure level with background noise 
load SPL_S1_M1.mat
load SPL_S1_M2.mat
load SPL_S2_M2.mat
load SPL_S2_M3.mat
load SPL_S3_M3.mat
load SPL_S3_M4.mat
load SPL_S4_M4.mat
load SPL_S4_M1.mat
%% The data of the background noise 
load SPL_BCKG_M1.mat
load SPL_BCKG_M2.mat
load SPL_BCKG_M3.mat
load SPL_BCKG_M4.mat
%% The data of the reverberation time
load Average_RT.mat
% load RT_S3_M1_D1.mat
% load RT_S3_M1_D2.mat
% load RT_S3_M2_D1.mat
% load RT_S3_M2_D2.mat
% load RT_S3_M3_D1.mat
% load RT_S3_M3_D2.mat
%% the average sound pressure level for each frequancy.
N=8; % the total number of measurements
f=[100 125 160 200 250 315 400 500 630 800 1000 1250 1600 2000 2500 3150 4000 5000];
n=numel(f);
SPL=zeros(numel(f),N);
SPL(:,1)=SPL_S1_M1;
SPL(:,2)=SPL_S1_M2;
SPL(:,3)=SPL_S2_M2;
SPL(:,4)=SPL_S2_M3;
SPL(:,5)=SPL_S3_M3;
SPL(:,6)=SPL_S3_M4;
SPL(:,7)=SPL_S4_M4;
SPL(:,8)=SPL_S4_M1;
SPL_average=zeros(1,numel(f)); % this vector used to save the average sound pressure level for each frequancy.
for ii=1:n;
     SPL_average(ii)=10*log10((1/N)*sum(10.^(SPL(ii,:)/10)));
end
%% the average sound pressure level for the background noise.
N_BG=4; % the total number of measurements the background noise.
SPL_BG=zeros(numel(f),N_BG);
SPL_BG(:,1)=SPL_BCKG_M1;
SPL_BG(:,2)=SPL_BCKG_M2;
SPL_BG(:,3)=SPL_BCKG_M3;
SPL_BG(:,4)=SPL_BCKG_M4;
SPL_BG_average=zeros(1,numel(f)); % this vector used to save the average  sound pressure level 
                               % for the background at each frequancy.

for ii=1:n;
     SPL_BG_average(ii)=10*log10((1/N_BG)*sum(10.^(SPL_BG(ii,:)/10)));
end

%% the correction of the impact sound pressure level
Def=SPL_average-SPL_BG_average;
SPL_corrected_average=zeros(1,numel(f));
for ii=1:n;
    if Def(ii)>=10
    SPL_corrected_average(ii)=SPL_average(ii);
elseif Def(ii)<10 && Def(ii)>6
    SPL_corrected_average(ii)=10*log10(10.^(SPL_average(ii)/10)-10.^(SPL_BG_average(ii)/10));
else
  SPL_corrected_average(ii)= SPL_average(ii)-1.3;
end
     
end
%% the average reverbration time
N_TR=6; % the total number of measurements the background noise.
% TR=zeros(numel(f),N_TR);
% TR(:,1)=RT_S3_M1_D1;
% TR(:,2)=RT_S3_M1_D2;
% TR(:,3)=RT_S3_M2_D1;
% TR(:,4)=RT_S3_M2_D2;
% TR(:,5)=RT_S3_M3_D1;
% TR(:,6)=RT_S3_M3_D2;
% TR_average=zeros(1,numel(f));
% for ii=1:n;
%      TR_average(ii)=(sum(TR(ii,:))/N_TR);
% end
% T_60=sum(TR_average)/numel(TR_average)
% the average reverberation time for 500Hz, 1000Hz, and 2000Hz

T30_average=(Average_RT(find(f==500))+Average_RT(find(f==1000))+Average_RT(find(f==2000)))/3
P_T30 = ['The reverbration time: T30=', ...
    num2str(T30_average)];
disp(P_T30)
%% Evaluation of the equivalent sound absorption area
V=(6.34*5.45*3.28)
A=0.16*V/T30_average
P_A = ['The equivalent sound absorption area: A=', ...
    num2str(A)];
disp(P_A)
%% the Evaluation of the standardized impact sound pressure level
T0=0.5;
LnT=SPL_corrected_average-10*log10(T30_average/T0)
P_LnT = ['The standardized impact sound pressure level: LnT=', ...
    num2str(LnT)];
disp(P_LnT)
%% the Evaluation of the normalized impact sound pressure level
A0=10;
Ln=SPL_corrected_average+10*log10(A/A0)
P_Ln = ['The normalized impact sound pressure level: Ln=', ...
    num2str(Ln)];
disp(P_Ln)
%% the weighted standardized impact sound pressure level
L_ref=[62 62 62 62 62 62 61 60 59 58 57 54 51 48 45 42];
k=1;
M=sum(LnT(:,1:16)-L_ref(:,1:16));
L_ref_shift=zeros(1,18);
delta=zeros(1,16);
if M>0
    while(M>=32)
        L_ref_shift(:,1:16)=L_ref(:,1:16)+k*ones(1,16);
        delta=LnT(:,1:16)-L_ref_shift(:,1:16);
        delta_positive=delta(delta>=0);
        M=sum(delta_positive);
        k=k+1;
    end
end

if M<0
    while(M<=32)
        L_ref_shift(:,1:16)=L_ref(:,1:16)-k*ones(1,16);
        delta=LnT(:,1:16)-L_ref_shift(:,1:16);
        delta_positive=delta(delta>=0);
        M=sum(delta_positive);
        k=k+1;
    end
end 
LnTw=L_ref_shift(find(f==500)) % Lntw' for the slab
P_LnTw = ['The weighted standardized impact sound pressure level: LnTw=', ...
    num2str(LnTw)];
disp(P_LnTw)
%% the weighted normalized impact sound pressure level
L_ref=[62 62 62 62 62 62 61 60 59 58 57 54 51 48 45 42];
k=1;
M=sum(Ln(:,1:16)-L_ref(:,1:16))
L_ref_shift1=zeros(1,18);
delta=zeros(1,16);
if M>0
    while(M>=32)
        L_ref_shift1(:,1:16)=L_ref(:,1:16)+k*ones(1,16);
        delta=Ln(:,1:16)-L_ref_shift1(:,1:16);
        delta_positive=delta(delta>=0);
        M=sum(delta_positive);
        k=k+1;
    end
end

if M<0
    while(M<=32)
        L_ref_shift1(:,1:16)=L_ref(:,1:16)-k*ones(1,16);
        delta=Ln(:,1:16)-L_ref_shift1(:,1:16);
        delta_positive=delta(delta>=0);
        M=sum(delta_positive);
        k=k+1;
    end
end 
Lnw=L_ref_shift1(find(f==500)) % Lntw' for the slab
P_Lnw = ['The weighted normalized impact sound pressure level: Lnw=', ...
    num2str(Lnw)];
disp(P_Lnw)

%% The adaptation term CI for LnTw
L=10*log10(sum(10.^(0.1*LnT)));
CI=round(L-15-LnTw)
P_CI = ['The adaptation term for LnTw: CI=', ...
    num2str(CI)];
disp(P_CI)
%% The adaptation term CI for Lnw
L=10*log10(sum(10.^(0.1*Ln)));
CI1=round(L-15-Lnw)
P_CI1 = ['The adaptation termfor LnT: CI1=', ...
    num2str(CI1)];
disp(P_CI1)
%% All results
disp(P_T30)
disp(P_A)
disp(P_LnT)
disp(P_LnTw)
disp(P_CI)
disp(P_Ln)
disp(P_Lnw)
disp(P_CI1)
%% Figures
%% The reverbration time
figure()
semilogx(f(:,1:16),Average_RT(1:16,:),'.-','LineWidth',2, 'MarkerSize',16,'MarkerEdgeColor','k')
%xlim([0 3150])
%ylim([55 80])
grid on
title('The reverbration time','FontSize', 12)
xlabel('Frequency[Hz]','FontSize', 12)
ylabel('The reverbration time T30 [s]','FontSize', 12)
%legend('the slab','first solution','the second solution','FontSize', 10)
set(gca, 'XTick',f)

%% The standardized impact sound pressure level
figure()
semilogx(f(:,1:18),LnT(:,1:18),'.-','LineWidth',2, 'MarkerSize',16,'MarkerEdgeColor','k')
xlim([0 f(end)])
ylim([48 70])
grid on
title('The standardized impact sound pressure level of the slab','FontSize', 12)
xlabel('Frequency[Hz]','FontSize', 12)
ylabel('Sound pressure level LnT [dB]','FontSize', 12)
%legend('the slab','first solution','the second solution','FontSize', 10)
set(gca, 'XTick',f)

%% the weighted The standardized impact sound pressure level
figure()
semilogx(f(:,1:16),LnT(:,1:16),'.-','LineWidth',2, 'MarkerSize',16,'MarkerEdgeColor','k')
hold on
semilogx(f(:,1:16),L_ref(:,1:16),'.-','LineWidth',2, 'MarkerSize',16,'MarkerEdgeColor','k')
hold on
semilogx(f(:,1:16),L_ref_shift(:,1:16),'.-','LineWidth',2, 'MarkerSize',16,'MarkerEdgeColor','k')
xlim([0 3150])
ylim([40 80])
grid on
%title('Sound reduction index curve using Meisser model for 1/3 octave frequency bands of R','FontSize', 24)
xlabel('Frequency[Hz]','FontSize', 12)
ylabel('Sound pressure level [dB]','FontSize', 12)
axLims = [f(1) f(16) 40 80];  %[x-min, x-max, y-min, y-max] axis limits
xlim(axLims(1:2)); 
ylim(axLims(3:4));
hold on
plot([f(8) f(8)], [axLims(3), L_ref_shift(8)], 'k-','LineWidth',2)  %vertical line
plot([f(1), f(8)], [L_ref_shift(8), L_ref_shift(8)], 'k-','LineWidth',2)  %horizontal line
legend('the slab','the reference','the shifted reference','FontSize', 10)
set(gca, 'XTick',f)

%% The normalized impact sound pressure level
figure()
semilogx(f(:,1:18),Ln(:,1:18),'.-','LineWidth',2, 'MarkerSize',16,'MarkerEdgeColor','k')
xlim([0 5000])
ylim([53 75])
grid on
title('The normalized impact sound pressure level of the slab','FontSize', 12)
xlabel('Frequency[Hz]','FontSize', 12)
ylabel('Sound pressure level Ln [dB]','FontSize', 12)
%legend('the slab','first solution','the second solution','FontSize', 10)
set(gca, 'XTick',f)

%% the weighted The normalized impact sound pressure level
figure()
semilogx(f(:,1:16),Ln(:,1:16),'.-','LineWidth',2, 'MarkerSize',16,'MarkerEdgeColor','k')
hold on
semilogx(f(:,1:16),L_ref(:,1:16),'.-','LineWidth',2, 'MarkerSize',16,'MarkerEdgeColor','k')
hold on
semilogx(f(:,1:16),L_ref_shift1(:,1:16),'.-','LineWidth',2, 'MarkerSize',16,'MarkerEdgeColor','k')
xlim([0 3150])
ylim([40 85])
grid on
%title('Sound reduction index curve using Meisser model for 1/3 octave frequency bands of R','FontSize', 24)
xlabel('Frequency[Hz]','FontSize', 12)
ylabel('Sound pressure level [dB]','FontSize', 12)
axLims = [f(1) f(16) 40 85];  %[x-min, x-max, y-min, y-max] axis limits
xlim(axLims(1:2)); 
ylim(axLims(3:4));
hold on
plot([f(8) f(8)], [axLims(3), L_ref_shift1(8)], 'k-','LineWidth',2)  %vertical line
plot([f(1), f(8)], [L_ref_shift1(8), L_ref_shift1(8)], 'k-','LineWidth',2)  %horizontal line
legend('the slab','the reference','the shifted reference','FontSize', 10)
set(gca, 'XTick',f)
%% The normalized and standerdized impact sound pressure level
figure()
semilogx(f(:,1:18),LnT(:,1:18),'.-','LineWidth',2, 'MarkerSize',16,'MarkerEdgeColor','k')
hold on 
semilogx(f(:,1:18),Ln(:,1:18),'.-','LineWidth',2, 'MarkerSize',16,'MarkerEdgeColor','k')
grid on
xlabel('Frequency[Hz]','FontSize', 12)
ylabel('Sound pressure level [dB]','FontSize', 12)
xlim([0 5000])
ylim([43 77])
legend('LnT','Ln','FontSize', 10)
set(gca, 'XTick',f)


