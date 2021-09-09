function [listing, txt] = datahandling(setname, addrress) 

% Contact:
% Morteza Zabihi (morteza.zabihi@gmail.com) && Ali Bahrami Rad(abahramir@yahoo.com)
% Black Swan Team (April 2016)
% This code is released under the MIT License (MIT) (http://opensource.org/licenses/MIT)
%
%% Load the validation/Training set

addrress1 = strcat(addrress, '/', setname);
cd (addrress1);
addpath(addrress1);

listing = dir('*.wav');
% [~,txt,~]  = xlsread('REFERENCE.csv');
fid = fopen('REFERENCE.csv', 'r');
txt = textscan(fid,'%s%f%f','delimiter',',');
fclose(fid);


cd (addrress);

