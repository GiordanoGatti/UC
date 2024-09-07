function Rw = Rw_calc(F, R, x) %creating a fuction dependant on R and the x start value
Ref = [33 36 39 42 45 48 51 52 53 54 55 56 56 56 56 56]; %reference values ISO717.1

sum_delta=0; %initiating variable
it = 0; %initiate a control variable used in line 11
while sum_delta < 32 %
   Ref_x = Ref+x; %sums the start value of x to every refence value
   delta = Ref_x-R; %calculate the difference between the reference 
   delta = max(delta,0); %replaces negative values to 0
   sum_delta = sum(delta); %sums all the values of the dalta array
   if ((sum_delta>=10)&(it==0)) %checks if the loop was executed more that one time
       disp('initial value x too large, did not enter the loop!')
   end
   x = x+1; %increments x
   it=it+1;
end
x %displays the final value of x

index = find(F==500); %finds the index of 500Hz in the frequency array
Rw = Ref_x(index) %takes the value of the same index of 500Hz in the dislocated reference curve

figure()
semilogx(F,R,'- .green',F,Ref_x,'- .blue',F,Ref,'- .black');
hold on
semilogx(F(index),Rw, '*r');
grid on;
xlabel('frequency [Hz]');
ylabel('R [dB]');
xlim([100,3150]);
set(gca,'XTick',F)
set(gca,'XTickLabel',sprintf('%3.0f|',F))
legend('prediction','shifted reference curve', 'reference curve');

end