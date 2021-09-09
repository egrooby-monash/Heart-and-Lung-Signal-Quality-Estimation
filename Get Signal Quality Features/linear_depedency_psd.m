function [rho1,rho2,rho3,noise] = linear_depedency_psd(psd_full,psd_full_freq)
%% Paper Information
% Noise detection during heart sound recording using periodicity signatures
% https://www.researchgate.net/publication/51037539_Noise_detection_during_heart_sound_recording_using_periodicity_signatures

%% Inputs
% psd_full: power spectral density function
% psd_full_freq: associated frequencies

num_freq=length(psd_full_freq);

psd=zeros(15,size(psd_full,2));
for i=1:15
    start_point=round(num_freq/15*(i-1)+1);
    end_point=round(num_freq/15*i);
    psd(i,:)=mean(psd_full(start_point:end_point,:));
end

Y1=psd(1:5,:);
Y2=psd(6:10,:);
Y3=psd(11:15,:);
S1=svd(Y1');
S2=svd(Y2');
S3=svd(Y3');

rho1=((S1(2))/(S1(1)))^2;
rho2=((S2(2))/(S2(1)))^2;
rho3=((S3(2))/(S3(1)))^2;

if rho2>rho1 && rho2>rho3
    noise=1;
elseif rho3>rho1
    noise=0.5; 
else
    noise=0;
end
end
