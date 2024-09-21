clear all
close all
clc

                            %%parameters%%
                            
sample_wl = 18;
%air
c0 = 343; %[m/s]
rho0 = 1.21; %[kg/m^3]
f = 2000; %[Hz]
w = 2*pi*f; %[rad/s]
%material 1
rho1 = rho0;
c1 = c0;
L1 = 1; %[m]
wl1 = c1/f;
n_el_1 = round(L1/(wl1/sample_wl));
%Material 2
sigma = 5000; %rockwool
[rho2,c2] = DelanyBazley(rho0,c0,f,sigma);
L2 = 0.2; %[m]
wl2 = abs(c2)/f;
n_el_2 = max([round(L2/(wl2/sample_wl)) 5]);

n_el = n_el_1+n_el_2;


                            %%mesh%%   
                            
dx1=L1/n_el_1; %length of the elements
dx2=L2/n_el_2;
xn=[0:dx1:L1 (L1+dx2):dx2:(L1+L2)]; %node positions
ndof = numel(xn);
nx0=1:1:n_el; %left nodes
nx1=2:1:(n_el+1); %right nodes

                    %%calculation of K and M%%
                    
freqs=100:10:f;
nfreqs = numel(freqs);
node_p1=find(xn<0.75);node_p1=node_p1(end);
node_p2=find(xn>0.8);node_p2=node_p2(1);

alfa = zeros(nfreqs,1);

for ifreq=1:nfreqs
   K=zeros(ndof,ndof);
   M=zeros(ndof,ndof);
   F=zeros(ndof,1);
   f = freqs(ifreq);
   [rho2,c2] = DelanyBazley(rho0,c0,f,sigma);
   w = 2*pi*f; %[rad/s]
   
    for ii=1:n_el
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
    F(end)=-1i*w*0;

    %solve the system
    P=mldivide(KM,F); %or KM\F
    
    p1=P(node_p1);
    p2=P(node_p2);
    H=p2/p1;
    s = xn(node_p2)-xn(node_p1);
    k = w/c0;
    R = abs((H - exp(-1i*k*s))/(-H+exp(1i*k*s)));
    alfa(ifreq)=1-R^2;
end

                        %%plot the solution%%
figure
plot(freqs,alfa)

figure
plot(xn,abs(P),xn,real(P),xn,imag(P))
legend('abs','real','imaginary')
xlabel('Length [m]')
ylabel('P[Pa]')



                           %%Functions%%

function [rho,c]=DelanyBazley(rho0,c0,f,sigma)
%%%%% Delany and Bazley model
X=f/sigma;
w=2*pi*f;
Z_DB = rho0*c0*( 1 + 9.08*(X*1000).^(-0.75) ...
    - 1i*11.9*(X*1000).^(-0.73));

k_DB = w/c0 .* (-1i) .* ( 10.3*(X*1000).^(-0.59) ...
    + 1i* ( 1 + 10.8*(X*1000).^(-0.70)));

c=w/k_DB;
rho=Z_DB/c;
end



%function for ke
function k=ke(L,rho,c)
    k=1/rho*[1/L -1/L;-1/L 1/L];
end



%function for me
function m=me(L,rho,c)
    m=1/rho/(c^2)*[L/3 L/6;L/6 L/3];
end