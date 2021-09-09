function [pxx,f] = Welch_periodogram(x, fn, pass_band)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

wind = ones(1,floor(0.125*fn)); % 125 ms
nover = floor(length(wind)/4); % 25% overlap
nfft = 2^(nextpow2(length(wind))-1); % nfft
[pxx,f] = pwelch(x,wind,nover,nfft,fn); % Welch
% f = f(f>=pass_band(1) && f<=pass_band(end)); 
f = f(f<=pass_band(end)); % A MIEUX FAIRE
pxx=pxx(1:length(f)); % A MIEUX FAIRE NE PART PAS DE 1                

end

