% function [peakpos] = detect_peaks(signal)
%
% A function to detect peaks in a signal
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

function [peakpos] = detect_peaks(signal)

signal = signal(:);

% point-to-point gradient
siggrad = diff(signal);

% changes in gradient = zero crossings of siggrad
% peak where crossdirs = -1, trough where crossdirs = 1
[crosspts, crossdirs] = zerocrossings(siggrad);
peakpos = crosspts(crossdirs==-1)+1;
