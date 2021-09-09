% function [indices change] = zerocrossings(signal)
%
% A function to find the zero crossings of a signal
%
% Implemented in:
% D. Springer et al., "Automated signal quality assessment of mobile
% phone-recorded heart sound signals," JMET, In preparation, 2016
%
%% Copyright (C) 2016  David Springer
% dave.springer@gmail.com
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.

function [indices change] = zerocrossings(signal)
% [indices change] = zerocrossings(signal)
%
% returns indices of signal which are nearest to a zero crossing
% change is: 1 for increasing (neg to pos), -1 for decreasing (pos to neg)
% 

dgtzero = diff(signal>0);
dltzero = diff(signal<0);

% not stopping at zero
% +ve -> -ve in one step
postoneg = find(dgtzero==-1 & dltzero==1);
ptnchange = ones(size(postoneg)) * -1;
% -ve -> +ve in one step
negtopos = find(dgtzero==1 & dltzero==-1);
ntpchange = ones(size(negtopos));

zeropointcrossings = [];
zerosptchange = [];
% situations where signal is zero
if (any(signal==0))
    zeroind = find(signal==0);
    while (~isempty(zeroind))
        thiszero = zeroind(1);
        % find last non-zero
        lastnz = find(signal(1:thiszero-1)~=0,1,'last');
        % find next non-zero
        nextnz = find(signal(thiszero+1:end)~=0,1,'first')+thiszero;
        % assume true crossing unless disproved
        crossing = true;
        % not a crossing if either are empty
        if (isempty(lastnz) || isempty(nextnz))
            crossing = false;
            if (isempty(nextnz))
                nextnz = zeroind(end)+1;
            end
        % not a crossing if both same sign
        elseif (sign(signal(lastnz))==sign(signal(nextnz)))
            crossing = false;
        end
        % save true crossings
        if (crossing)
            zeropointcrossings(end+1) = thiszero;
            % change is equal to sign(nextnz)
            zerosptchange(end+1) = sign(signal(nextnz));
        end
        % remove zeros up to nextnz
        ztorem = find(zeroind<nextnz,1,'last');
        zeroind = zeroind(ztorem+1:end);
    end 
end

% combine and sort indices
allcrossings = [postoneg(:); negtopos(:); zeropointcrossings(:)];
allchanges = [ptnchange(:); ntpchange(:); zerosptchange(:)];
[indices si] = sort(allcrossings);
change = allchanges(si);

