% Title :    "Wheezing sound separation based on Informed Inter-Segment 
%                  Non-negative Matrix Partial Co-Factorization"
%
%
% Objetive: In this work, an extended version of Non-negative Matrix Partial 
%           Co-Factorization (NMPCF) is proposed to suppress RS while preserving 
%           the wheezing acoustic content. Here, we assume that RS can be 
%           considered as repetitive sound events during breathing so, RS 
%           can be modeled by sharing together the spectral patterns found 
%           in each respiratory stage (segment), inspiration or expiration, 
%           with a respiratory training signal. However, this sharing of patterns 
%           can not be applied to wheezes since WS could not be present at 
%           each segment due to their unpredictable nature in time motivated 
%           by the pulmonary disorder. To improve the sound separation performance 
%           of the conventional NMPCF that treats equally all segments of 
%           the spectrogram, the main contribution of the proposed method 
%           adds higher importance to those segments classified as non-wheezing 
%           using inter-segment information informed by a wheezing detection 
%           system. As a result, our proposal is able to characterize RS more 
%           accurately by forcing to model more on those non-wheezing segments 
%           in the bases sharing process into the NMPCF decomposition. Specifically,
%           IIS-NMPCF consists of three stages: i) Segmentation; ii) Classification 
%           between presence/absence of WS (second stage) and finally iii) Adding 
%           weighting into the NMPCF decomposition (third stage)
%
%
% Journal: Sensors
% Authors: Juan De La Torre Cruz, Francisco Jesus Canadas Quesada, Nicolas 
%          Ruiz Reyes Julio, Pedro Vera Candeas and Jose Carabias Orti.

%-------------------------------------------------------------------------%
clear all;close all;clc;
%-------------------------------------------------------------------------%


%-------------------------------------------------------------------------%
%%                    Parameter initialization (Optimal values)           %
%-------------------------------------------------------------------------%
% Number of wheezing components
Kw = 64;
% Number of respiratory components
Kr=32;              
% Weighting factors
alpha=1;      
lamR_0=10; 
lamR_1=0.1; 
lamW=0.01;
% Sampling rate
sr=2048; 
% Hamming window sample length 
N = 256;  
% Overlap
S = 0.25;           
%-------------------------------------------------------------------------%

%-------------------------------------------------------------------------%
%%                         Input signals                                  %
%-------------------------------------------------------------------------%
% Select input mixture signal x(t) (audio file .wav) 
% Note that x(t) must be composed of wheezing and respiratory sounds.
[filename_x,pathname_x] = uigetfile('*.wav','Select the input mixture signal x(t)');
[x,fs]=audioread([pathname_x filesep filename_x]); disp([' Name: ' filename_x]);
if size(x,2)==2
   x=(x(:,1)+x(:,2))/2;
end
x=x'; 
 if fs~=sr
    x=resample(x,fsre,fs); 
 end
 Lx=length(x);
% Select respiratory training signal y(t) (audio file .wav)
% Note that y(t) must be composed of only respiratory sounds.
[filename_y,pathname_y] = uigetfile('*.wav','Select respiratory training signal y(t)');
[y,fs]=audioread([pathname_y filesep filename_y]); disp([' Name: ' filename_y]);
if size(y,2)==2
   y=(y(:,1)+y(:,2))/2;
end
y=y'; 
 if fs~=sr
    y=resample(y,fsre,fs); fs=sr;
 end
Ly=length(y);
%-------------------------------------------------------------------------%

%-------------------------------------------------------------------------%
%%                         Time-Frequency Representation                  %
%-------------------------------------------------------------------------%
Hop_samples=round(S*N); 
window=hamming(N); 
noverlap=N-Hop_samples; 
nfft=2*N; 
% Magnitude spectrogram X
[Xcomplex,fox,tox]=sg(x,nfft,fs,window,noverlap); 
Xabs=abs(Xcomplex); Xang=angle(Xcomplex); 
nfx=size(Xabs,1);         %Bins 
ntx=size(Xabs,2);         %Frames
% Magnitude spectrogram Y
[Ycomplex,foy,toy]=sg(y,nfft,fs,window,noverlap); 
Yabs=abs(Ycomplex); Yang=angle(Ycomplex); 
nfy=size(Yabs,1);         %Bins
nty=size(Yabs,2);         %Frames
%-------------------------------------------------------------------------%

%-------------------------------------------------------------------------%
%%                    i) Segmentation (AMIE_SEG)                          %
%-------------------------------------------------------------------------%
div_segf = amie_seg(Xabs, N, S, fs);
%-------------------------------------------------------------------------%

%-------------------------------------------------------------------------%
%%           ii) Classification between presence/absence of WS            %
%-------------------------------------------------------------------------%
Nseg = length(div_segf) - 1;                   % Number of segments
for l = 1 : Nseg
    % Selection of each segment
    Xsabs = Xabs(:,div_segf(l):div_segf(l+1));
    Xsang = Xang(:,div_segf(l):div_segf(l+1));
    % Annotation of the type of segment (wheezing or non-wheezing)
    %  1 --> wheezing segment.
    %  0 --> non-wheezing segment.
    C(l) =class_segment(Xsabs,Xsang,N,S,fs);
end
%-------------------------------------------------------------------------%

%-------------------------------------------------------------------------%
%%            iii) Adding weighting into the NMPCF decomposition          %
%-------------------------------------------------------------------------%
[Xr, Xw] = nmpcf_weight(Xabs,Yabs,Nseg,div_segf, Kw, Kr, alpha ,...
                            lamR_0, lamR_1, lamW, C);
%-------------------------------------------------------------------------%

%-------------------------------------------------------------------------%
%%                      Reconstruction signal                             %
%-------------------------------------------------------------------------%
% Denormalization of estimated spectrograms
normaYn = sum(sum(Xabs));
Xw = Xw.*normaYn;
Xr = Xr.*normaYn;
% Time domain signals
x_r = invspecgram((Xr).*exp(j*Xang),nfft,fs,window,noverlap);
x_w = invspecgram((Xw).*exp(j*Xang),nfft,fs,window,noverlap);
% Saving the audio signals
audiowrite([cd filesep filename_x(1:end-4) '_R.wav'],x_r,fs);
audiowrite([cd filesep filename_x(1:end-4) '_W.wav'],x_w,fs);
%-------------------------------------------------------------------------%

%=========================================================================%
%                              Figure                                     %
%-------------------------------------------------------------------------%
border = max(max(Xabs)); 
imagesc((0:Lx-1)/fs,(0:nfx-1)*(fs/2)/size(Xabs,1),Xabs);
title('Input mixture spectrogram');
xlabel('Time(s)');ylabel('Frequency(Hz)');caxis([0 border]);
figure;
imagesc((0:Lx-1)/fs,(0:nfx-1)*(fs/2)/size(Xabs,1),Xr);
title('Estimated respiratory spectrogram');
xlabel('Time(s)');ylabel('Frequency(Hz)');caxis([0 border]);
figure;
imagesc((0:Lx-1)/fs,(0:nfx-1)*(fs/2)/size(Xabs,1),Xw);
title(' Estimated wheezing spectrogram');
xlabel('Time(s)');ylabel('Frequency(Hz)');caxis([0 border]);
%=========================================================================%



