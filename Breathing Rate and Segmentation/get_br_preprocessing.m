
function [audio_2000_f,Fs]=get_br_preprocessing(audio_data,Fs,Fs_new)
%% Purpose
% Preprocessing of lung sound to calculate breathing rate
%% Inputs
% audio_data= lung sound
% Fs= current sampling frequnecy 
% Fs_new= desired sampling frequency
%% Outputs
% audio_2000_f= filtered and resampled lung sound
% Fs= new sampling frequency

% dealing with padded zeros and instances of zeros
audio_data(audio_data==0)=min(abs(audio_data(audio_data~=0)));

audio_2000 = resample(audio_data,Fs_new,Fs);
Fs=Fs_new;

% >150Hz 2nd order Butterworth band pass
audio_2000_f = butterworth_high_pass_filter(audio_2000,2,150,Fs);
end