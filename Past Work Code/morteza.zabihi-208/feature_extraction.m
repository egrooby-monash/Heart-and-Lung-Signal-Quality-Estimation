
function [feature] = feature_extraction(x, hamming)
%%
% INPUT:
% x         ----> Raw data
% hamming   ----> hamming window
%
%
% OUTPUT:
% feature  ----> 18 features extracted from time-frequnecy domain
%
%
% Contact:
% Morteza Zabihi (morteza.zabihi@gmail.com) && Ali Bahrami Rad(abahramir@yahoo.com)
% Black Swan Team (July 2016)
% This code is released under the MIT License (MIT) (http://opensource.org/licenses/MIT)
%
%%
Fs = 2000;

[MFCCs, ~, ~ ] = mfcc( x, Fs, 0.025*Fs, 0.010*Fs, 0.97, hamming, [1 1000], 26, 14, 22 );

f1 = mean(min(MFCCs));                                      %1
m4 = moment((max(MFCCs)),4,2);       f5 = abs(m4.^(1/4));   %5
m4 = moment((skewness(MFCCs)),4,2);  f6 = abs(m4.^(1/4));   %6
%--------------------------------------------------------------------------
level = 5;
[c,l] = wavedec(x,level,'db4');

a5 = appcoef(c,l,'db4');
det5 = detcoef(c,l,level);
det4 = detcoef(c,l,level-1);
det3 = detcoef(c,l,level-2);
%--------------------------------------------------------------------------
f7 = log2(var(det3));                                       %7
%--------------------------------------------------------------------------
xx = downsample(x, 16);
[f14, ~, f15] = Spectral(xx);                               %13 14
%--------------------------------------------------------------------------
[lp,g] = lpc(double(x),10);
f161821232425 = lp([2 4 7 9 10 11]);                        %16 18 21 23 24 25
%--------------------------------------------------------------------------
N = length(x);
xdft = fft(x);
xdft = xdft(1:N/2+1);
psdx = (1/(2*pi*N)) * abs(xdft).^2;
psdx(2:end-1) = 2*psdx(2:end-1);

f = Fs*(0:(N/2))/N;
frequency_centroid = (sum(f'.*(psdx.^2)))/(sum(psdx.^2));   %26
%-------------------------------------------------------------
nbins = 50;
[counts,centers] = hist(x,nbins);
thr = mean((diff(centers))/2);
centers(2,:) = centers + thr;
for i=1:length(x)
    p1 = find(x(i)<=centers(2,:));
    if ~isempty(p1)
        p(i) = counts(p1(1));
    else
        p(i) = counts(end);
    end
end
p = p / length(x);
q = 2;
Shannon = -1*sum(p.*log(p));                                %29
Tsallis = (1/(q-1))*sum(1 - p.^q);                          %31
%-------------------------------------------------------------
clear p counts centers thr
[counts,centers] = hist(a5,nbins);
thr = mean((diff(centers))/2);
centers(2,:) = centers + thr;
for i=1:length(x)
    p1 = find(x(i)<=centers(2,:));
    if ~isempty(p1)
        p(i) = counts(p1(1));
    else
        p(i) = counts(end);
    end
end
p = p / length(x);
Shannon_a5 = -1*sum(p.*log(p));                             %32
%-------------------------------------------------------------
clear p counts centers thr
[counts,centers] = hist(det5,nbins);
thr = mean((diff(centers))/2);
centers(2,:) = centers + thr;
for i=1:length(x)
    p1 = find(x(i)<=centers(2,:));
    if ~isempty(p1)
        p(i) = counts(p1(1));
    else
        p(i) = counts(end);
    end
end
p = p / length(x);
q = 2;
Renyi_d5 = (1/(q-1))*log(sum(p.^q));                        %36
%-------------------------------------------------------------´
clear p counts centers thr
[counts,centers] = hist(det4,nbins);
thr = mean((diff(centers))/2);
centers(2,:) = centers + thr;
for i=1:length(x)
    p1 = find(x(i)<=centers(2,:));
    if ~isempty(p1)
        p(i) = counts(p1(1));
    else
        p(i) = counts(end);
    end
end
p = p / length(x);
Shannon_d4 = -1*sum(p.*log(p));                             %38
%% ------------------------------------------------------------------------
feature = [f1 f5 f6 f7 f14 f15 f161821232425 frequency_centroid,...
            Shannon Tsallis Shannon_a5 Renyi_d5 Shannon_d4];