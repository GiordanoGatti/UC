function C = C_adapt(R, Rw)
C_ref = [-29 -26 -23 -21 -19 -17 -15 -13 -12 -11 -10 -9 -9 -9 -9 -9 -10 -10];

Xaj = -10*log10(sum(10.^((C_ref-R)/10)));
C = Xaj - Rw;
C = round(C)
end