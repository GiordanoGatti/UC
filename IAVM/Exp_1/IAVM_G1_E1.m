clc
close all
clear all

S1M1D1 = importdata('SWEEP_3avg_S1_M1_D1.txt');
S1M1D2 = importdata('SWEEP_3avg_S1_M1_D2.txt');
S1M1D3 = importdata('SWEEP_3avg_S1_M1_D3.txt');

S1M2D1 = importdata('SWEEP_3avg_S1_M2_D1.txt');
S1M2D2 = importdata('SWEEP_3avg_S1_M2_D2.txt');
S1M2D3 = importdata('SWEEP_3avg_S1_M2_D3.txt');

S1M3D1 = importdata('SWEEP_3avg_S1_M3_D1.txt');
S1M3D2 = importdata('SWEEP_3avg_S1_M3_D2.txt');
S1M3D3 = importdata('SWEEP_3avg_S1_M3_D3.txt');

S2M1D1 = importdata('SWEEP_3avg_S2_M1_D1.txt');
S2M1D2 = importdata('SWEEP_3avg_S2_M1_D2.txt');
S2M1D3 = importdata('SWEEP_3avg_S2_M1_D3.txt');

S2M2D1 = importdata('SWEEP_3avg_S2_M2_D1.txt');
S2M2D2 = importdata('SWEEP_3avg_S2_M2_D2.txt');
S2M2D3 = importdata('SWEEP_3avg_S2_M2_D3.txt');

S2M3D1 = importdata('SWEEP_3avg_S2_M3_D1.txt');
S2M3D2 = importdata('SWEEP_3avg_S2_M3_D2.txt');
S2M3D3 = importdata('SWEEP_3avg_S2_M3_D3.txt');

S1M1D1.textdata
%S1M1D1.data;

F = S1M1D1.data(:,1);

Param = ["T30","rT30","T20","rT20","T10","rT10","EDT","C80","C50","D50","Ts","BR"];

for a=1:length(Param)-1
    Param_val(:,:,a)= [S1M1D1.data(:,a+1).'; S1M1D2.data(:,a+1).'; S1M1D3.data(:,a+1).';S1M2D1.data(:,a+1).'; S1M2D2.data(:,a+1).';S1M2D3.data(:,a+1).'; S1M3D1.data(:,a+1).';S1M3D2.data(:,a+1).'; S1M3D3.data(:,a+1).'; S2M1D1.data(:,a+1).'; S2M1D2.data(:,a+1).';S2M1D3.data(:,a+1).'; S2M2D1.data(:,a+1).';S2M2D2.data(:,a+1).'; S2M2D3.data(:,a+1).';S2M3D1.data(:,a+1).'; S2M3D2.data(:,a+1).';S2M3D3.data(:,a+1).'];
end

T30avg = avg(F,Param_val(:,:,1),Param(1))
%rT30avg = avg(F,Param_val(:,:,2),Param(2))
T20avg = avg(F,Param_val(:,:,3),Param(3))
%rT20 = avg(F,Param_val(:,:,4),Param(4))
%T10avg = avg(F,Param_val(:,:,5),Param(5))
%rT10avg = avg(F,Param_val(:,:,6),Param(6))
%EDTavg = avg(F,Param_val(:,:,7),Param(7))
%C80avg = avg(F,Param_val(:,:,8),Param(8))
%C50avg = avg(F,Param_val(:,:,9),Param(9))
%D50avg = avg(F,Param_val(:,:,10),Param(10))
%Tsavg = avg(F,Param_val(:,:,11),Param(11))

BR = [S1M1D1.data(1,13), S1M1D2.data(1,13), S1M1D3.data(1,13),S1M2D1.data(1,13), S1M2D2.data(1,13), S1M2D3.data(1,13) S1M3D1.data(1,13), S1M3D2.data(1,13), S1M3D3.data(1,13), S2M1D1.data(1,13), S2M1D2.data(1,13), S2M1D3.data(1,13), S2M2D1.data(1,13), S2M2D2.data(1,13), S2M2D3.data(1,13), S2M3D1.data(1,13), S2M3D2.data(1,13), S2M3D3.data(1,13),];

BR_mean = mean(BR)



function par_mean = avg(Freq,par,labely)
figure()
grid on
hold on 
for i=1:length(par(:,1))
    plot(Freq,par(i,:),'- .','LineWidth', 2, 'MarkerSize',25)
end
xlabel('F [Hz]')
ylabel(labely)

for j=1: length(par(1,:))
    par_mean(j) = mean(par(:,j));
end
figure()
plot(Freq,par_mean,'- .','LineWidth', 2, 'MarkerSize',30)
grid on
xlabel('F [Hz]')
ylabel(strcat('mean: ',labely))
end
