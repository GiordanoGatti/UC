clear all
close all
clc

%Group 4 - Giordano, N.2023184877 | Yassine, N.2023184866
%Homogeneous concrete slab 0.3m

						%DATA

F = [100 125 160 200 250 315 400 500 630 800 1000 1250 1600 2000 2500 3150 4000 5000]; %1/3 octave bands
h = 0.3;%[m]
rho = 2400;%[kg/m^3]
m = h*rho;%[kg/m^2]

						%AIRBORNE

display('Airborne sound pressure:')
R = meisser(F,m); %predicts R using Meisser
Rw = Rw_calc(F(1:(end-2)),R(1:(end-2)),0); %calculates Rw
C = C_adapt(R,Rw); %calculates C
Ctr = Ctr_adapt(R,Rw); %calculates Ctr

						%IMPACT

display('Impact sound pressure:')
Ln = invariant(F,R);
Lnw = Lnw_calc(F(1:(end-2)),Ln(1:(end-2)),0);
CI = CI_adapt(Ln, Lnw);

%Ln_benchmark =[62.1 63.2 63.5 66.2 68.5 70 71.7 73.1 73.8 73.5 73.8 73.3 73.1 73 72.4 71.2];
%Ln_benchmark_2 = [59.1 59.5 61.6 63.2 65.3 66.5 67.7 67 67.1 66.5 66.1 62.5 57.9 52.7 47 48];

						%FUNCTIONS

function C = C_adapt(R, Rw)
C_ref = [-29 -26 -23 -21 -19 -17 -15 -13 -12 -11 -10 -9 -9 -9 -9 -9 -10 -10];
Xaj = -10*log10(sum(10.^((C_ref-R)/10)));
C = Xaj - Rw;
C = round(C)
end

function Ctr = Ctr_adapt(R, Rw)
Ctr_ref = [-20 -20 -18 -16 -15 -14 -13 -12 -11 -9 -8 -9 -10 -11 -13 -15 -16 -18];
Xaj = -10*log10(sum(10.^((Ctr_ref-R)/10)));
Ctr = Xaj - Rw;
Ctr = round(Ctr)
end

function CI = CI_adapt(L, Lnw)
Lsum = 10*log10(sum(10.^((L)/10)));
CI = round(Lsum)-15-Lnw
end

function R = meisser(F, m)
	R500 = 13.3*log10(m)+13.4;
	R = 13.3*log10(F/500)+R500;

figure();
semilogx(F,R,'- .red');
grid on;
xlabel('frequency [Hz]');
ylabel('R [dB]');
xlim([100,5000]);
xticks(F)
legend('Meisser');
end

function Ln = invariant(F,R)
    Ln = (38+30*log10(F)) - R;
figure();
semilogx(F,Ln,'- .red');
grid on;
xlabel('frequency [Hz]');
ylabel('Ln [dB]');
xlim([F(1),F(end)]);
xticks(F)
legend('invariant method');
end

function Rw = Rw_calc(F, R, x) 
Ref = [33 36 39 42 45 48 51 52 53 54 55 56 56 56 56 56]; %reference values ISO717.1
sum_delta=0; %initiating variable
it = 0; %initiate a control variable used in line 11
while sum_delta < 32 
   Ref_x = Ref+x; %sums the start value of x to every refence value
   delta = Ref_x-R; %calculate the difference to the reference 
   delta = max(delta,0); %replaces negative values to 0
   sum_delta = sum(delta); %sums all the values of the dalta array
   if ((sum_delta>=10)&(it==0)) %checks if the loop was executed more than one time
       disp('initial value x too large, did not enter the loop!')
   end
   x = x+1; %increments x
   it=it+1;
end
x %displays the final value of x
index = find(F==500); %finds the index of 500Hz in the frequency array
Rw = Ref_x(index) %takes the value of the same index of 500Hz in the dislocated reference curve
figure()
semilogx(F,R,'- .red',F,Ref_x,'- .blue',F,Ref,'- .black');
hold on
semilogx(F(index),Rw, '*r');
grid on;
xlabel('frequency [Hz]');
ylabel('R [dB]');
xlim([100,3150]);
xticks(F)
legend('prediction','shifted reference curve', 'reference curve');
end

function Lnw = Lnw_calc(F, L, x) 
Ref = [62 62 62 62 62 62 61 60 59 58 57 54 51 48 45 42]; %reference values ISO717.2
sum_delta=100; %initiating variable to forcibly enter the loop
it = 0;
while sum_delta > 32 
   Ref_x = Ref+x; %sums the start value of x to every refence value
   delta = L-Ref_x; %calculate the difference to the reference 
   delta = max(delta,0); %replaces negative values to 0
   sum_delta = sum(delta); %sums all the values of the dalta array
   if ((sum_delta<=32)&(it==0)) %checks if the loop was executed more than one time
       disp('initial value x too large, did not enter the loop!')
   end
   x = x+1; %increments x
   it=it+1;
end
xf = x-1 %displays the final value of x
index = find(F==500); %finds the index of 500Hz in the frequency array
Lnw = Ref_x(index) %takes the value of the same index of 500Hz in the dislocated reference curve
figure()
semilogx(F,L,'- .red',F,Ref_x,'- .blue',F,Ref,'- .black');
hold on
semilogx(F(index),Lnw, '*r');
grid on;
xlabel('frequency [Hz]');
ylabel('R [dB]');
xlim([100,3150]);
xticks(F)
legend('prediction','shifted reference curve', 'reference curve');
end