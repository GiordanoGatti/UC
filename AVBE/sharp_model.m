function R = sharp_model(F, m, eta, c, ro, v, E, h)
Fc = (c^2)*((ro*(1-v^2)/E)^0.5)/(1.8138*h)
f_c = 0.443*(Fc/eta)

i=1;
for f = F
   if f <= (0.5*Fc)
       r = 20*log10(f*m) - 47; %[dB]
   elseif ((f>(0.5*Fc))&(f<=Fc))
       r = 20*log10(Fc*m) - 53 + log10(2*(f/Fc))*(26.58+(33.22*log10(eta))); %[db]
   elseif ((f>Fc)&(f<=f_c))
       r = 20*log10(f*m) - 44.4 + 10*log10(eta*(f/Fc)); %[dB]
   elseif (f>f_c)
       r = 20*log10(f*m) - 47; %[dB]
   end
   R(i) = r;
   i = i+1;
end

end