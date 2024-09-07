function Ctr = Ctr_adapt(R, Rw)
Ctr_ref = [-20 -20 -18 -16 -15 -14 -13 -12 -11 -9 -8 -9 -10 -11 -13 -15 -16 -18];

Xaj = -10*log10(sum(10.^((Ctr_ref-R)/10)));
Ctr = Xaj - Rw;
Ctr = round(Ctr)
end