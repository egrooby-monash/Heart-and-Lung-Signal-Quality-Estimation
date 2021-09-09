function [addrress] = installing_needed_toolbox()
%%
% 
%
% Contact:
% Morteza Zabihi (morteza.zabihi@gmail.com) && Ali Bahrami Rad(abahramir@yahoo.com)
% Black Swan Team (July 2016)
% This code is released under the MIT License (MIT) (http://opensource.org/licenses/MIT)
%
%% add path
fprintf('Inistalling the needed packages: \n')
warning('off','all');

addrress = cd;
addpath(addrress);
addpath(genpath(addrress));
%%

addrress1 = strcat(addrress, '/mfcc');
addrress2 = strcat(addrress1,'/mfcc/mfcc');
addrress3 = strcat(addrress,'/validation');

%%
addpath(addrress1);
addpath(addrress2);
addpath(addrress3);
%%
clc
fprintf('Needed packages are successfully installed \n\n\n')
