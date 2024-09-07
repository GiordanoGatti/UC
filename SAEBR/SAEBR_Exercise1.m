clear all
close all
clc

						%DATA

F = [100 125 160 200 250 315 400 500 630 800 1000 1250 1600 2000 2500 3150 4000 5000]; %1/3 octave bands
v = 8.8*5.59*3;
s = 2*(8.8*5.59)+2*(8.8*3)+2*(5.59*3);
t0 = 0.15*(v^(1/3));

h_slab = 0.24;%[m]
rho_slab = 1400;%[kg/m^3]
m_slab = h_slab*rho_slab;%[kg/m^2]
h_brick = 0.15+(2*0.02);%[m]
rho_brick = 1400;%[kg/m^3]
h_mortar = 0.02;
rho_mortar = 2000;
m_wall = (h_brick*rho_brick)+(2*h_mortar*rho_mortar);%[kg/m^2]
%0.15*1400 + 2*(0.02*2000) = 290 -> Rw = 48 (simplified method)

DntBA = [31.6 32.1 32.5 33.1 33.8 36.7 38.9 41.3 42.6 43.8 44.9 45.6 45.3 45.1 44.1 45.2];
DntCA = [20.6 21.3 22.2 21.3 20.2 20.9 21.2 21.6 22.5 23.1 23.7 23.6 23.2 23.2 22.3 21.6];
D2mnT = [22.5 23 22.8 22.3 21.9 22.1 23 22.9 23.5 21.5 20.2 22.3 24.6 27.3 29.1 30];
Lnt = [55.1 56.7 57.2 57.8 58.2 59.9 61.1 62.7 64.5 67.2 68.1 69.9 71.2 72 70.8 66.2];

						%AIRBORNE

display('Airborne sound pressure:')

display('Wall')
R_wall = meisser(F,m_wall);
Rw_wall = Rw_calc(F(1:(end-2)),R_wall(1:(end-2)),-20,'R'); %calculates Rw
k_wall = 3;
Dntw_wall = Rw_wall - k_wall + 10*log10(v/(6.25*t0*s))
display('in situ')
DntwBA = Rw_calc(F(1:(end-2)),DntBA,-20,'D')

display('Corridor - in situ')
DntwCA = Rw_calc(F(1:(end-2)),DntCA,-35,'D')

display('Facade - in situ')
D2mnTw = Rw_calc(F(1:(end-2)),D2mnT,-35,'D2m')



						%IMAPCT

display('Impact sound pressure:')
display('slab')
%Lnw_slab = 164-35*log10(m_slab)
Lnw_slab = 169-35*log10(m_slab)
display('in situ')
Lntw = Lnw_calc(F(1:(end-2)),Lnt,0);


						%FUNCTIONS

function R = meisser(F, m)
	R500 = 13.3*log10(m)+13.4;
	R = 13.3*log10(F/500)+R500;
figure();
semilogx(F,R,'- .red','LineWidth',1.5);
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
semilogx(F,Ln,'- .red','LineWidth',1.5);
grid on;
xlabel('frequency [Hz]');
ylabel('Ln [dB]');
xlim([F(1),F(end)]);
xticks(F)
legend('invariant method');
end

function Rw = Rw_calc(F, R, x, type) 
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
semilogx(F,R,'- .red',F,Ref_x,'- .blue',F,Ref,'- .black','LineWidth',1.5);
hold on
semilogx(F(index),Rw, '.magenta','MarkerSize',30);
grid on;
xlabel('frequency [Hz]');
if type=='R'
	  ylabel('R [dB]');
elseif type=='D'
    ylabel('Dnt [dB]');
elseif type=='D2m'
    ylabel('D2m,nt');
end
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
semilogx(F,L,'- .red',F,Ref_x,'- .blue',F,Ref,'- .black','LineWidth',1.5);
hold on
semilogx(F(index),Lnw, '.magenta','MarkerSize',30);
grid on;
xlabel('frequency [Hz]');
ylabel('Lnt [dB]');
xlim([100,3150]);
xticks(F)
legend('prediction','shifted reference curve', 'reference curve');
end