% EXaMPLE Simple demo of the MFCC function usage.
%
%   This script is a step by step walk-through of computation of the
%   mel frequency cepstral coefficients (MFCCs) from a speech signal
%   using the MFCC routine.
%
%   See also MFCC, COMPaRE.

%   author: Kamil Wojcicki, September 2011


    % Clean-up MaTLaB's environment
%     clear all; close all; clc;  

 function [mean_mfcc,mean_mfcc_systole, mean_mfcc_diastole]=calculating_mfcc(signal_s1 ,signal_s2 ,signal_systole, signal_diastole,a)
    % Define variables
    Tw =20;                % analysis frame duration (ms)
    Ts = 5;                % analysis frame shift (ms)
%  Tw=5;
%  Ts=1;
    alpha = 0.97;           % preemphasis coefficient
%     M = 20;                 % number of filterbank channels 
    M=14;
%     C = 12;                 % number of cepstral coefficients
C=13;
    L = 22;                 % cepstral sine lifter parameter
%     LF = 300;               % lower frequency limit (Hz)
%     HF = 3700;              % upper frequency limit (Hz)

LF=20;
HF=900;

Fs=2000;
%     wav_file = 'b0001.wav';  % input audio filename
% 
% 
%     % Read speech samples, sampling rate and precision from file
%     [ speech, fs, nbits ] = wavread( wav_file );


    % Feature extraction (feature vectors as columns)
%     [ MFCCs, FBEs, frames ] = ...
%                     mfcc( speech, fs, Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
                
 %% mfcc for systoles               
j=1;
seperate_systoles=cell(size(a,1),1);
MFCCs_systole=cell(size(a,1),1);
for i=1:size(a,1)
seperate_systoles{j,1}=signal_systole(a(i,2):a(i,3));
j=j+1;

end

 for k=1:size(a,1)
 [ MFCCs_systole{k,1}, FBEs_systole, frames_systole ] = ...
                    mfcc(seperate_systoles{k,1}, Fs, Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L ); 


 end 
  
 %% mfcc for diastole
 
 j=1;
seperate_diastoles=cell(size(a,1),1);
MFCCs_diastole=cell(size(a,1),1);
for i=1:size(a,1)
seperate_diastoles{j,1}=signal_diastole(a(i,4):a(i,5));
%   seperate_diastoles{j,1}=seperate_diastoles{j,1}(1:end-30);
j=j+1;

end

 for k=1:size(a,1)
 [ MFCCs_diastole{k,1}, FBEs_diastole, frames_diastole ] = ...
                    mfcc(seperate_diastoles{k,1}, Fs, Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L ); 


 end 
  %% mfcc for s1
  j=1;
seperate_s1=cell(size(a,1),1);
MFCCs_s1=cell(size(a,1),1);
for i=1:size(a,1)
seperate_s1{j,1}=signal_s1(a(i,1):a(i,2));
j=j+1;

end


 for k=1:size(a,1)
 [ MFCCs_s1{k,1}, FBEs_s1, frames_s1 ] = ...
                    mfcc(seperate_s1{k,1}, Fs, Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L ); 


 end 
  %% mfcc for s2
  j=1;
seperate_s2=cell(size(a,1),1);
MFCCs_s2=cell(size(a,1),1);
for i=1:size(a,1)
seperate_s2{j,1}=signal_s2(a(i,3):a(i,4));
j=j+1;

end

 for k=1:size(a,1)
 [ MFCCs_s2{k,1}, FBEs_s2, frames_s2 ] = ...
                    mfcc(seperate_s2{k,1}, Fs, Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L ); 


 end 
 
 
 
 
 
 
 %% mean_mfcc_S1
g1=cell(1,size(a,1));
for i=1:length(MFCCs_s1)
 
   g1{1,i}=trimmean( MFCCs_s1{i,1},10,2);
 
end
d1=cell2mat(g1);
 mean_mfcc_s1=trimmean(d1,10,2);
 
%% mean_mfcc_s2

g2=cell(1,size(a,1));
for i=1:length(MFCCs_s2)
 
   g2{1,i}=trimmean( MFCCs_s2{i,1},10,2);
 
end
d2=cell2mat(g2);
 mean_mfcc_s2=trimmean(d2,10,2);
%% mean_mfcc_systole
g3=cell(1,size(a,1));
for i=1:length(MFCCs_systole)
 
   g3{1,i}=trimmean( MFCCs_systole{i,1},10,2);
 
end
d3=cell2mat(g3);
 mean_mfcc_systole=trimmean(d3,10,2);
 
 %% mean_mfcc_diastole
 g4=cell(1,size(MFCCs_diastole,2));
 
for i=1:length(MFCCs_diastole)
 
   g4{1,i}=trimmean( MFCCs_diastole{i,1},10,2);
 
end
%d4=cell2mat(g4(1,1:end-1));
d4=cell2mat(g4);
 mean_mfcc_diastole=trimmean(d4,10,2); 
 mean_mfcc=[mean_mfcc_s1 mean_mfcc_s2 mean_mfcc_systole mean_mfcc_diastole];
 end