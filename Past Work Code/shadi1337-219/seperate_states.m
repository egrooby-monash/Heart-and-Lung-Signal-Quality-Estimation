function[signal_s1s2 signal_systole signal_diastole]=seperate_states(assigned_states,denoised_signal,figures)
% clear all 
% clc 
% close all
% %% load data
% [PCG, Fs1, nbits1] = wavread(['a0001.wav']);  % load data
% PCG_resampled      = resample(PCG,1000,Fs1)
% load('assigned_states.mat')
x=assigned_states;
y=assigned_states;
z=assigned_states;
%  %% denoised
% audio_data = butterworth_low_pass_filter(PCG_resampled ,2,400,1000, false);
% audio_data = butterworth_high_pass_filter(audio_data,2,25,1000,false);
% audio_data = schmidt_spike_removal(audio_data,1000);
%% signal only with s1 and s2
    for i=1:length(assigned_states)
    if x(i)==2 || x(i)==4
      x(i)=0;
        
    end 
    end
   
  signal_s1s2=0;
  j=0;
    for i=1:length(assigned_states)
        j=j+1;
        if x(i)~=0
        signal_s1s2(j)=denoised_signal(i);
        else 
            signal_s1s2(j)=0;
        end
    end
 %% signal only sistole
 
 i=0;
  for i=1:length(assigned_states)
    if y(i)==1 || y(i)==3 || y(i)==4
      y(i)=0;
        
    end 
  end
      signal_systole=0;
   
  j=0;
    for i=1:length(assigned_states)
        j=j+1;
        if y(i)~=0
        signal_systole(j)=denoised_signal(i);
        else 
            signal_systole(j)=0;
        end
    end
 %% signal only diastole
 i=0;
   for i=1:length(assigned_states)
    if z(i)==1 ||z(i)==2 ||z(i)==3
     z(i)=0;
        
    end 
  end
      signal_diastole=0;
  j=0;
    for i=1:length(assigned_states)
        j=j+1;
        if z(i)~=0
        signal_diastole(j)=denoised_signal(i);
        else 
            signal_diastole(j)=0;
        end
    end
    if figures
        figure
    plot(signal_s1s2)
    hold on 
    plot(signal_systole,'r')
    hold on 
    plot(signal_diastole,'g')
  
    end

        


