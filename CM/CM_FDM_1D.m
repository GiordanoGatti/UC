clear all
close all
clc

          							%1D FDM HELMHOLTZ EQUATION%

%A1 = 7
%A2 = 7

c1 = 1563; %[m/s]
rho1 = 1000; %[kg/m^3]
L1 = 34; %[m]

c2 =  1947 + 90.452i; %[m/s]
rho2 = 1000; %[kg/m^3]
L2 = 39; %[m]

f = 647; %[Hz]
w = 2*pi*f; %[rad/s]
k1 = w/c1;
k2 = w/c2;

%boundary conditions
P0 = 1; %[Pa]
Z = rho2*c2;

n_pt_start = 100; %number of points to begin with
n_pt_end = 500; %number of points to end with
n_pt_error = 10; %number of error points to analyse
x_error = n_pt_start:(n_pt_end-n_pt_start)/n_pt_error:n_pt_end; %x axis for nuber of points analysed
E = zeros(length(x_error),1);

b=1;
for n_pt = x_error

deltax = (L1+L2)/n_pt;

x=[0:deltax:(L1+L2)];
M=zeros(numel(x));
B=zeros(numel(x),1);
for ii=2:numel(x)-1
    pm=1/deltax^2;
    if x(ii) < L1
    		p=-2/deltax^2+k1^2;
    else 
       p=-2/deltax^2+k2^2;
    end
    pM=1/deltax^2;
    M(ii,ii-1)=pm;
    M(ii,ii)=p;
	 M(ii,ii+1)=pM;
end

%boundary conditions
M(1,1)= 1;%P0
M(end, end-1)= -1/deltax; %rightmost boundary condition
M(end, end)= (i*k2) + (1/deltax);
B(1)=P0;
B(numel(x)) = 0;

P_fdm=M\B;
P_an = solution_1D(f,c1,c2,L1,L2,x);

E(b,1) = (sum(abs(P_an-P_fdm)))/n_pt;
b=b+1;
end


figure(1)
plot(x,abs(P_fdm),'red',x,abs(P_an),'blue')
xlabel('position [m]')
ylabel('absolute sound pressure [Pa]')
legend('FDM', 'analitical')
grid on

figure(2)
plot(x,real(P_fdm),'red',x,real(P_an),'blue')
xlabel('position [m]')
ylabel('real sound pressure [Pa]')
legend('FDM', 'analitical')
grid on

figure(3)
plot(x,imag(P_fdm),'red',x,imag(P_an),'blue')
xlabel('position [m]')
ylabel('imaginary sound pressure [Pa]')
legend('FDM', 'analitical')
grid on


figure(4)
loglog(x_error,E,'blue')
xlabel('number of samples')
ylabel('average absolute error')
grid on



function P=solution_1D(f,c1,c2,L1,L2,x)
% f-frequency
% c1,c2 – propagation velocities
% L1,L2 – length of each médium
% x – position of receivers
w=2*pi*f;
k1=w/c1;
k2=w/c2;
A=complex(zeros(4));
A(1,:)=[1 exp(-1i*k1*L1) 0 0];
A(2,:)=[exp(-1i*k1*L1) exp(0) -exp(0) -exp(-1i*k2*(L2))];
A(3,:)=[(-1i*k1)*exp(-1i*k1*L1) -(-1i*k1)*exp(0) -(-1i*k2)*exp(0) (-1i*k2)*exp(-1i*k2*(L2))];
A(4,:)=[0 0 (-1/1i/w)*(-1i*k2)*exp(-1i*k2*L2)*c2-exp(-1i*k2*L2) -(-1/1i/w)*(-1i*k2)*c2-1];
B=[1;0;0;0];
X=A\B;
P=zeros(numel(x),1);
for ii=1:numel(x)
if(x(ii)<=L1 & x(ii)>=0)
P(ii)=X(1)*exp(-1i*k1*x(ii))+X(2)*exp(-1i*k1*abs(x(ii)-L1));
elseif(x(ii)<=L1+L2)
P(ii)=X(3)*exp(-1i*k2*abs(x(ii)-L1))+X(4)*exp(-1i*k2*abs(x(ii)-L1-L2));
else
P(ii)=NaN;
end
end
return
end