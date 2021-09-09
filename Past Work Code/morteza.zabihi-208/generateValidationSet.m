% This script will verify that your code is working as you intended, by
% running it on a small subset (300 records) of the training data, then
% comparing the answers.txt file that you submit with your entry with
% answers produced by your code running in our test environment using
% the same records.
%
% In order to run this script, you should have downloaded and extracted
% the validation set into the directory containing this file.
%
%
% Contact:
% Morteza Zabihi (morteza.zabihi@gmail.com) && Ali Bahrami Rad(abahramir@yahoo.com)
% Black Swan Team (April 2016)
% This code is released under the MIT License (MIT) (http://opensource.org/licenses/MIT)
%
%
%%
clear all; clc; close all;
load('ANNcinc')

%% Feature Extraction on the Validation Set
total_time = 0;
addrress = cd;
[listing, txt] = datahandling('validation', addrress); 

tic
fprintf('Feature Extraction:\n')
for i = 1: length(listing)
    fprintf('Signal %d   ------------------------------------------\n', i)
    % ---------------------------------------------------------------------
    label_validation(i) = txt{1,2}(i);
    % ---------------------------------------------------------------------
    classifyResult(i) = challenge(listing(i).name);
end
fprintf('\n Feature Extraction is done \n\n\n')
toc
%% Classification on the Validation Set
load('label_validation_Qa');
[Final_result] = Scoring (classifyResult, label_validation, label_validation_Qa);

%% Write the classification results in a txt file
answers = dir(['answers.txt']);
if(~isempty(answers))
    display(['Found previous answer sheet file in: ' pwd])
    cont = input('Delete it (Y/N)?','s');
    if(strcmp(cont,'Y')) 
        display('Removing previous answer sheet.')
        warning('off','all'); delete answers.txt
        fid = fopen('answers.txt','wt');
        for i=1:length(classifyResult)
            fprintf(fid,'%s,%d\n',listing(i).name(1:end-4),classifyResult(i));
        end
        fclose(fid);
    else 
        display('New answer sheet is not made')
    end    
else
    fid = fopen('answers.txt','wt');
    for i=1:length(classifyResult)
        fprintf(fid,'%s,%d\n',listing(i).name(1:end-4),classifyResult(i));
    end
    fclose(fid);
end        


%% Zip
delete('entry.zip')
zip('entry.zip',{'*.m','*.pdf','*.png','*.mfc','*.mat','*.txt','*.sh','mfcc'});
