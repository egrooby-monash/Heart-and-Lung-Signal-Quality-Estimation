function heartRate=get_hr_freq(envelope,max_HR,min_HR,Fs)
%% Purpose
% calculate heart rate
%% Input
% envelope= envelope of heart sound
% min_HR and max_HR= minimum and maximum range of heart rate
% Fs= sampling frequecy
%% Output
% heartRate= heat rate

y=envelope-mean(envelope);
%max frequency
Y = fft(y);
L=length(y);
P2 = abs(Y/L);
P1 = P2(1:round(L/2)+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;

reduced_f=f(f>min_HR/60 & f<max_HR/60);
reduced_P1=P1(f>min_HR/60 & f<max_HR/60);
heartRate=reduced_f(reduced_P1==max(reduced_P1))*60;
end