close all;clear all;clc;
A = [1 1 1 1 1 1 1 1 1 1 1 1];
a = [0.030 0.030 0.030 0.030 0.030 0.030 0.030 0.030];
d = [0.075 0.075 0.075 0.075 0.075 0.075 0.075];
dx = 0.005;
dy = 0.005;
f = 5000;
Lx = 4;
Ly = 2;
phi = [0 0 0 0 0 0 0 0 0 0 0 0];
c = 343;
d = [-sum(d)/2 d];
k = 2*pi*f/c;
lambda = c/f;
N = length(a);
p = 0;
rho = 1.18;
[x,y] = meshgrid(dx:dx:Lx,-Ly/2:dy:Ly/2);
h = waitbar(0,'Calculando...');
for ii = 1:N
%y0 = sum(d(1:ii));
y0 = sum(d(1:ii))-a(ii):dy:sum(d(1:ii))+a(ii);
for jj = 1:length(y0)
r = eps+sqrt((x-0).^2+(y-y0(jj)).^2);
theta = 0.0001+atan((y-y0(jj))./(x-0));
p = p + A(ii)*exp(j*phi(ii))*j*rho*c*k*a(ii)^2*exp(-j*k*r).*(2*besselj(1,k*a(ii)*sin(theta))./(k*a(ii)*sin(theta)))./(2*r);
waitbar((ii-1+jj/length(y0))/N,h);
end
end
close(h);
figure,imagesc(x(1,:),y(:,1),20*log10(abs(p)/max(max(abs(p))))),axis xy,axis
equal,caxis([-60 0]),colorbar,axis([dx Lx -Ly/2 Ly/2])