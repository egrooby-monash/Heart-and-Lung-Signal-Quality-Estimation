function [Shannon,Tsallis,Renyi]=get_prob_entropy(x)
%% Paper Information
% Heart sound anomaly and quality detection using ensemble of neural networks without segmentation
% https://ieeexplore.ieee.org/document/7868817 
% Contact:
% Morteza Zabihi (morteza.zabihi@gmail.com) && Ali Bahrami Rad(abahramir@yahoo.com)
% Black Swan Team (July 2016)
% This code is released under the MIT License (MIT) (http://opensource.org/licenses/MIT)
%% Purpose
% get probability entropy features
%% INPUT:
% x: Raw data
%% OUTPUT:
% Shannon, Renyi and Tsallis entropy
%% Entropy based features
nbins = 50;
[counts,centers] = hist(x,nbins);
thr = mean((diff(centers))/2);
centers(2,:) = centers + thr;
p=zeros(1,length(x)); 
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
Shannon = -1*sum(p.*log(p));     
Tsallis = (1/(q-1))*sum(1 - p.^q); 
Renyi = (1/(q-1))*log(sum(p.^q));                                          
end
