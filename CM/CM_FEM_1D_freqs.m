clear all
close all
clc

                            %%parameters%%
                            
f = 647; %[Hz]
w = 2*pi*f; %[rad/s]
step = 1; %[Hz]
f_start = 1; %[Hz]
el_size = 0.2; %[m]

%Fluid 1
c1 = 1563; %[m/s]
wl1 = c1/f;
rho1 = 1000; %[kg/m^3]
L1 = 34; %[m]
n_el_1 = round(L1/el_size);
%Fluid 2
c2 =  1947 + 90.452i; %[m/s]
wl2 = c2/f;
rho2 = 1000; %[kg/m^3]
L2 = 39; %[m]
n_el_2 = round(L2/el_size);

n_el = n_el_1+n_el_2;

                            %%mesh%%   
                            
dx1=L1/n_el_1; %length of the elements
dx2=L2/n_el_2;
xn=[0:dx1:L1 (L1+dx2):dx2:(L1+L2)]; %node positions
ndof = numel(xn);
nx0=1:1:n_el; %left nodes
nx1=2:1:(n_el+1); %right nodes

                    %%calculation of K and M%%
                    
freqs=f_start:step:f;
nfreqs = numel(freqs);
div_node = find(xn==L1);

b=1;
for ifreq=1:nfreqs
   K=zeros(ndof,ndof);
   M=zeros(ndof,ndof);
   F=zeros(ndof,1);
   f = freqs(ifreq);
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
    v=0;F(end)=-1i*w*v;
    %Robin boundary conditions
    %z=rho2*c2;KM(end,end) = KM(end,end)+1i*w/(z);

    %solve the system
    P(b,1:n_el+1)=mldivide(KM,F); %or KM\F
    
    p_div_node(b,1)=P(b,div_node);
    b=b+1;
end

                        %%plot the solution%%

figure(1)
plot(freqs,abs(p_div_node),freqs,real(p_div_node),freqs,imag(p_div_node))
xlabel('Frequency [Hz]')
xlim([f_start f])
ylabel('interface point pressure [Pa]')
legend('Absolute','Real','Imaginary')
grid on
                
figure(2)
surf(xn,freqs,20*log10(abs(P)), 'EdgeColor','none')
view(2)
colormap('jet')
colorbar
xlabel('Length [m]')
xlim([0 L1+L2])
ylabel('frequency [Hz]')
ylim([f_start f])
zlabel('SPL [dB]')

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