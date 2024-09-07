clear all
close all
clc

%          ONE SOURCE
one_source = importdata('NF_FF_1_Source/Caja 3 Labo 1 way/SPL_CC-WC.txt'); %near field
f = one_source(:,1);
spl_1 = one_source(:,2);

spl_1_ff_calc = spl_1+20*log10(0.18/1)-6

one_source_ff_measured = importdata('NF_FF_1_Source/Caja 3 Labo 1 way/SPL_FF_Measured_1M_WH.txt'); %far field measured
spl_1_ff_m = one_source_ff_measured(:,2)

figure()
semilogx(f,spl_1,'green',f,spl_1_ff_calc,'red',f,spl_1_ff_m,'blue')
xlabel('frequency [Hz]')
ylabel('SPL [dB]')
xlim([10,22400])
ylim([0,130])
legend('near field','far field calculated','far field measured');



%           THREE SOUCES
ts_s1 = importdata('NF_FF_3_Sources/SS1.txt');
spl_3_1 = ts_s1(:,2);
ts_s2 = importdata('NF_FF_3_Sources/SS3.txt');
spl_3_2 = ts_s2(:,2);
ts_s3 = importdata('NF_FF_3_Sources/SS2.txt');
spl_3_3 = ts_s3(:,2);

spl_3_1_ff = spl_3_1+20*log10(0.025/1)-6;
spl_3_2_ff = spl_3_2+20*log10(0.11/1)-6;
spl_3_3_ff = spl_3_3+20*log10(0.025/1)-6;

spl_3 = 10*log10((10.^((spl_3_1_ff)/10))+(10.^((spl_3_2_ff)/10))+(10.^((spl_3_3_ff)/10)));

figure()
semilogx(f,spl_3_1,'green',f,spl_3_2,'red',f,spl_3_3,'blue',f,spl_3,'black')
xlabel('frequency [Hz]')
ylabel('SPL [dB]')
xlim([10,22400])
ylim([0,130])
legend('source 1','source 2','source 3','far field response');