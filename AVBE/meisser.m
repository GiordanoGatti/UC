function R = meisser(F, m)
R500 = 13.3*log10(m)+13.4;
R = 13.3*log10(F/500)+R500;
end