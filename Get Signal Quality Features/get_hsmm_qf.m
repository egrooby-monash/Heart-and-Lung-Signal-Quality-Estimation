function [hsmm_qf_s1,hsmm_qf_s2] = get_hsmm_qf(assigned_states,signal_envelope)
%% Paper Information
% Automatic signal quality index determination of radar-recorded heart sound signals using ensemble classification
% https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=8731709  

%% Description 
%HSMM Quality Factor (HSMM-QF)
% heart sound segmentation
% dividing the mean height of the envelope during S1/S2 by the
% average mean height of diastole and systole. Two features, one
% for each heart sound, result from this. The correctness of the
% segmentation is not crucial since a wrong segmentation, e.g.,
% in case of noise, also indicates a low signal quality which in
% that case would lead to a low HSMM-QF value. Since in this case
% the envelope height during S1/S2 would roughly be equal to that
% during the diastole/systole, the HSMM-QF would be approximately
% 1. High-quality heart sounds signals however are expected to
% result in a high HSMM-QF values > 1.

%% INPUTS:
% assigned_states: segmented heart sound
% audio_data: the audio data from a PCG recording
% Fs: sampling frequency
%% OUTPUTS:
% hsmm_qf_s1/s2= Quality factor for S1 and S2

locS1=assigned_states==1;
locSys=assigned_states==2;
locS2=assigned_states==3;
locDia=assigned_states==4;
locSysDia= (locSys|locDia);

t_env=signal_envelope;
t_env=t_env-min(t_env);
hsmm_qf_s1=abs(mean(t_env(locS1))/mean(t_env(locSysDia)));
hsmm_qf_s2=abs(mean(t_env(locS2))/mean(t_env(locSysDia)));
