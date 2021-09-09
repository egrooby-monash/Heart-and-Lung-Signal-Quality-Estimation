%% Preprocessing
function [audio_1000_f,Fs]=get_hr_preprocessing(audio_data,Fs,Fs_new)
%% Purpose
% clean up heart sound to calcualte heart rate
%% Inputs
% audio_data= heart sound
% Fs= current sampling frequency
% Fs_new= desired sampling frequency
%% Outputs
% audio_1000_f= filtered and resampled heart sound
% Fs= sampling frequency

% dealing with padded zeros and instances of zeros
audio_data(audio_data==0)=min(abs(audio_data(audio_data~=0)));

audio_1000 = resample(audio_data,Fs_new,Fs);
Fs=Fs_new;

% 25-400Hz 4th order Butterworth band pass
audio_1000_f = butterworth_low_pass_filter(audio_1000,2,400,Fs, false);
audio_1000_f = butterworth_high_pass_filter(audio_1000_f,2,25,Fs);

% Spike removal from the original paper:
audio_1000_f = schmidt_spike_removal(audio_1000_f,Fs);

end