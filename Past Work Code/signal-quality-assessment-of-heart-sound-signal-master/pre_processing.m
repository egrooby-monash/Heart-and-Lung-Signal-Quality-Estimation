function [output_signal]=pre_processing(input_signal,fs)
% preporcessing to input signal, includes reomve spikes, remove baseline
% wandering and normalization

input_signal=input_signal/std(input_signal);

% remove spikes 
dspike_signal = remove_spike(input_signal);

%% remove baseline wandering, pass a high pass filter with cut-off frequency 2 Hz
  fc=2;
  [b,a]=butter(3, 2*fc/fs,'high');
  dwander=filtfilt(b, a, dspike_signal);
  
%% normalize the signal to stardand deviation
 output_signal=dwander/std(dwander);
