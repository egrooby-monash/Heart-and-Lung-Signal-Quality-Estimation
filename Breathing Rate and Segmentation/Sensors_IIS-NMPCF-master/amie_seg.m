function [div_segf] = amie_seg(Xabs, N, S, fs)
%
%
% Objetive:  this function implements the respiratory stage segmenter defined 
%            in reference "Automatic Multi-level In-Exhale Segmentation and Enhanced 
%            Generalized S-Transform for whezing detection". Specifically, this function
%            allows to segment the mixture spectrogram X into inspiratory and expiratory stages.
%
%
% Input: 
% - Xabs:    mixture spectrogram
% - N:       hamming window sample length
% - S:       overlap (between 0 and 1)
% - fs:      sample rate (Hz)
%
% Output: 
% - div_segf: vector that indicates the separation frames between segments.
%
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% spectral energy
E=sum(Xabs,1);
%% Initial thresholds (Th1, Th2)
Th1 = max(E)/4;
Th2 = mean(E)/2;
%% Adaptive threshold
Th_ad = 0.5;
Th_add = zeros(1,100); 
Th_add(1) = Th_ad;
cont = 2;
while Th_ad<Th2
    Th_ad = Th_ad + (Th1-Th2);
    Th_add(cont) = Th_ad;
    cont = cont + 1;
end
Numb = length(find(Th_add>0));
Th_ad = Th_add(1:Numb);
%% Annotation (Silent Frame, Potential-breath Frame and Breath Frame)
Flag_S = zeros(Numb,length(E));
Flag_P = zeros(Numb,length(E));
Flag_B = zeros(Numb,length(E));
for i = 1:Numb
    Flag_S(i,:) = E<Th_ad(i);
    Flag_P(i,:) = E>Th_ad(i) & E<Th1;
    Flag_B(i,:) = E>Th1;
end
if length(Th_ad)>=3
decision = E>Th_ad(3);
decision =decision';
else
decision = E>Th_ad(2);
decision =decision';
end
%% Identification of the initial and final frame of each segment
flancos = [ 0; decision(2:end)-decision(1:(end-1)) ];
inicios = (find(flancos==1));
finales = (find(flancos==-1)); 
if (finales(1) < inicios(1))
    inicios = [1; inicios];
end
if (finales(end) < inicios(end))
    finales = [finales; length(decision)+1];
end
tiempos = [inicios finales];
tiempos = tiempos((tiempos(:,2)-tiempos(:,1))>10,:);
%% Segmentation
for k = 1:size(tiempos,1)-1
   div_seg(k) =  tiempos(k,2)+round((tiempos(k+1,1)-tiempos(k,2))/2);
end
%%  Annotation 
ntx = size(Xabs,2);
div_segf = ones(1,length(div_seg)+2);
div_segf(1) = 1;
div_segf(end) = ntx;
div_segf(2:end-1) = div_seg;
div_s = div_segf.*(N*S)/fs;
