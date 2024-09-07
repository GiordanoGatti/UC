clear all
close all
clc

                            %%parameters%%
%A1 = 7
%A2 = 7

el_size_start = 1;
el_size_end = 0.5;
el_size_qty = 10;
sizes = el_size_start:(el_size_end-el_size_start)/el_size_qty:el_size_end;


b=1;
for el_size=sizes
    
f = 647; %[Hz]
w = 2*pi*f; %[rad/s]

c1 = 1563; %[m/s]
wl1 = c1/f;
rho1 = 1000; %[kg/m^3]
L1 = 34; %[m]
n_el_1 = round(L1/el_size);

c2 =  1947 + 90.452i; %[m/s]
wl2 = c2/f;
rho2 = 1000; %[kg/m^3]
L2 = 39; %[m]
n_el_2 = round(L2/el_size);
%max([round(L2/(wl2/sample_wl)) 5]);

n_el(b,1) = n_el_1+n_el_2;
n_el(b,1);


                            %%mesh%%
                            
dx1=L1/n_el_1; %length of the elements
dx2=L2/n_el_2;
xn=[0:dx1:L1 (L1+dx2):dx2:(L1+L2)]; %node positions
ndof = numel(xn);
nx0=1:1:n_el(b,1); %left nodes
nx1=2:1:(n_el(b,1)+1); %right nodes

                    %%calculation of K and M%%
                    
K=zeros(ndof,ndof);
M=zeros(ndof,ndof);
F=zeros(ndof,1);
for ii=1:n_el(b,1)
   n0=nx0(ii);
   n1=nx1(ii); 
   Le=xn(n1)-xn(n0);
   if (xn(n0)<L1)
     k=ke(Le,rho1,c1);
     m=me(Le,rho1,c1);
   else
     k=ke(Le,rho2,c2);
     m=me(Le,rho2,c2);       
   end
   %assembly of K
   K(n0,n0)=K(n0,n0)+k(1,1);
   K(n0,n1)=K(n0,n1)+k(1,2);
   K(n1,n0)=K(n1,n0)+k(2,1);
   K(n1,n1)=K(n1,n1)+k(2,2);
   %assembly of M
   M(n0,n0)=M(n0,n0)+m(1,1);
   M(n0,n1)=M(n0,n1)+m(1,2);
   M(n1,n0)=M(n1,n0)+m(2,1);
   M(n1,n1)=M(n1,n1)+m(2,2);
end

%imposition of boundary conditions
KM=zeros(ndof,ndof);
KM = K-(w^2)*M;
%Dirichlet on left boundary
KM(1,:)=0;
KM(1,1)=1;
F(1)=1;
%Neumann on right boundary
%F(end)=-1i*w;
%Robin boundary conditions
KM(end,end) = KM(end,end)+1i*w/(rho2*c2);
%solve the system
P=KM\F;
P_an = solution_1D(f,c1,c2,L1,L2,xn);

E_fem(b,1) = (sum(abs(P_an-P)))/n_el(b,1);
b=b+1;

end

                        %%plot the solution%%
                        
figure(1)
%plot(xn,abs(P),xn,real(P),xn,imag(P))
%legend('abs','real','imaginary')
plot(xn,abs(P),'red',xn,abs(P_an),'blue')
legend('FEM','analitical')
xlabel('Length [m]')
ylabel('Absolute P[Pa]')

figure(2)
%plot(xn,abs(P),xn,real(P),xn,imag(P))
%legend('abs','real','imaginary')
plot(xn,real(P),'red',xn,real(P_an),'blue')
legend('FEM','analitical')
xlabel('Length [m]')
ylabel('Real P[Pa]')

figure(3)
%plot(xn,abs(P),xn,real(P),xn,imag(P))
%legend('abs','real','imaginary')
plot(xn,imag(P),'red',xn,imag(P_an),'blue')
legend('FEM','analitical')
xlabel('Length [m]')
ylabel('Imaginary P[Pa]')

figure(4)
loglog(n_el,E_fem,'blue')
xlabel('number of samples')
ylabel('average absolute error')
%legend('FEM error', 'FDM error')
grid on

                           %%Functions%%

%function for ke
function k=ke(L,rho,c)
    k=1/rho*[1/L -1/L;-1/L 1/L];
end

%function for me
function m=me(L,rho,c)
    m=1/rho/(c^2)*[L/3 L/6;L/6 L/3];
end

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