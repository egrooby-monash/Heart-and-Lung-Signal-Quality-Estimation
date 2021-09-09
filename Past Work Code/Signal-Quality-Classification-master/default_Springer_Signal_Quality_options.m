% function springer_options = default_Springer_Signal_Quality_options()
%
% The default options to be used with the Springer signal quality estimation algorithm.
% USAGE: springer_options = default_Springer_Signal_Quality_options
%
% Developed for use in the paper:
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

function springer_options = default_Springer_Signal_Quality_options()

%% The sampling frequency at which to extract signal features:
springer_options.audio_Fs = 1000;

springer_options.audio_segmentation_Fs = 50;


%% This option controls the use of the mexed function in viterbiDecodePCG.m
% In order to use the mex implementation, the file "viterbi_Schmidt.c" must
% be converted to its mex format. 
springer_options.use_mex = false;