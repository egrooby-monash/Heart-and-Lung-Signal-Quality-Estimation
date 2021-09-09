clear all;
close all;
clc

data_dir = [pwd filesep 'validation' filesep];

%% Add this directory to the MATLAB path.
addpath(pwd)

% Check for previous files before starting validation procedure
answers = dir(['answers.txt']);
if(~isempty(answers))
    while(1)
        display(['Found previous answer sheet file in: ' pwd])
        cont = input('Delete it (Y/N/Q)?','s');
        if(strcmp(cont,'Y') || strcmp(cont,'N') || strcmp(cont,'Q'))
            if(strcmp(cont,'Q'))
                display('Exiting script!!')
                return;
            end
            break;
        end
    end
    if(strcmp(cont,'Y'))
        display('Removing previous answer sheet.')
        delete(answers.name);
    end
end

%% Load the list of records in the validation set.
fid = fopen([data_dir 'RECORDS'],'r');
if(fid ~= -1)
    RECLIST = textscan(fid,'%s');
else
    error(['Could not open ' data_dir 'RECORDS for scoring. Exiting...'])
end
fclose(fid);
RECORDS = RECLIST{1};

%% Running on the validation set and obtain the score results
classifyResult = zeros(length(RECORDS),1);
total_time = 0;

fid=fopen('answers.txt','wt');
for i = 1:length(RECORDS)
 
    fname = RECORDS{i};
    tic;
     classifyResult(i) = challenge([data_dir fname]);

 % write the answer to answers.txt file
    fprintf(fid,'%s,%d\n',RECORDS{i},classifyResult(i));

%     total_time = total_time+toc;
    fprintf(['---Processed ' num2str(i) ' out of ' num2str(length(RECORDS)) ' records.\n'])
    
 end
fclose(fid);


averageTime = total_time/length(RECORDS);
fprintf(['Generation of validation set completed.\n  Total time = ' ...
    num2str(total_time) '\n  Average time = ' num2str(averageTime) '\n'])

fprintf(['Answer file created as answers.txt.\n  Processing completed.\n'])

fprintf(['Running score2016Challenge.m to get scores on your entry on the validation data in training set....\n'])

%% Scoring
score2016Challenge_new 

fprintf(['Scoring complete.\n'])
while(1)
    display(['Do you want to package your entry for scoring?'])
    cont=input('(Y/N/Q)?','s');
    if(strcmp(cont,'Y') || strcmp(cont,'N') || strcmp(cont,'Q'))
        if(strcmp(cont,'Q'))
            display('Exiting!!')
            return;
        end
        break;
    end
end

if(strcmp(cont,'Y'))
    display(['Packaging your entry (excluding any subdirectories) to: ' pwd filesep 'entry.zip'])
    % Delete any files if they existed previously
    delete('entry.zip')
    % This will not package any sub-directories !
    zip('entry.zip',{'*.m','*.c','*.mat','*.txt','*.sh'});
end