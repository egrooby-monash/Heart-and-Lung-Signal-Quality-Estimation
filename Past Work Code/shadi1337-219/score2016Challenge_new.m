% This script will score your algorithm for classification accuracy, based on the reference classification results.
% Your final score for the challenge will be evaluated on the hidden test set.
%
% This script requires that you first run generateValidationSet.m
%
%
% Written by: Chengyu Liu, Fubruary 15 2016
%             chengyu.liu@emory.edu
%
% Last modified by: Gari Clifford, Aug 5 2016
%             gari@gatech.edu
%
% Modifiaction note: Scorign mechinism has been updated, new scoring
% mechinism is described in the reference:
% Liu et al. An open access database for the evaluation of heart sound
% algorithms, PHysiological Measurement, 2016, 37(9).
% The weight parameter wn1 and wn2 were updated for the training set in
% line 62
%

clear all;

%% Load the answer classification results
fid = fopen('answers.txt','r');
if(fid ~= -1)
    ANSWERS = textscan(fid, '%s %d', 'Delimiter', ',');
else
    error('Could not open users answer.txt for scoring. Run the generateValidationSet.m script and try again.')
end
fclose(fid);

a = find(ANSWERS{2}==0);
b = find(ANSWERS{2}==1);
c = find(ANSWERS{2}==-1);
ln = length(a)+length(b)+length(c);
if(length(ANSWERS{2}) ~= ln);
    error('Input must contain only -1, 1 or 0');
end

%% Load the reference classification results
reffile = ['validation' filesep 'REFERENCE_NEW.csv'];
fid = fopen(reffile, 'r');
if(fid ~= -1)
    Ref = textscan(fid,'%s %d %d','Delimiter',',');
else
    error(['Could not open ' reffile ' for scoring. Exiting...'])
end
fclose(fid);

RECORDS = Ref{1};
target  = [Ref{2},Ref{3}]; % now target has two columns, column 1 is class type and column 2 is SQI
N       = length(RECORDS);

N1=length(find(target(:,1)==1));  % number of abnormal recordings
N2=length(find(target(:,1)==-1)); % number of normal recordings
wa1=length(find(target(:,2)==1 & target(:,1)==1))/N1;
wa2=length(find(target(:,2)<=0 & target(:,1)==1))/N1;
wn1=length(find(target(:,2)==1 & target(:,1)==-1))/N2;
wn2=length(find(target(:,2)<=0 & target(:,1)==-1))/N2;

% if you use the whole training set, the coresponding weight parameters
% are; wa1=0.8602, wa2=0.1398, wn1=0.9252 and wn2=0.0748
% please refer to: Liu et al. An open access database for the evaluation of heart sound
% algorithms, PHysiological Measurement, 2016, 37(9).


%% Scoring
% We do not assume that the references and the answers are sorted in the
% same order, so we search for the location of the individual records in answer.txt file.
Aa1=0;
Aa2=0;
Aq1=0;
Aq2=0;
An1=0;
An2=0;

Na1=0;
Na2=0;
Nq1=0;
Nq2=0;
Nn1=0;
Nn2=0;

for n = 1:N
    rec = RECORDS{n};
    i = strmatch(rec, ANSWERS{1});
    if(isempty(i))
        warning(['Could not find answer for record ' rec '; treating it as unknown.']);
        this_answer = 0;
    else
        this_answer = ANSWERS{2}(i);
    end
    if target(n,1)==1
        if target(n,2)==1
            if this_answer==1
                Aa1 = Aa1+1;
            elseif this_answer==-1
                An1 = An1+1;
            else
                Aq1 = Aq1+1;
            end
        else
            if this_answer==1
                Aa2 = Aa2+1;
            elseif this_answer==-1
                An2 = An2+1;
            else
                Aq2 = Aq2+1;
            end
        end
    else
        if target(n,2)==1
            if this_answer==1
                Na1 = Na1+1;
            elseif this_answer==-1
                Nn1 = Nn1+1;
            else
                Nq1 = Nq1+1;
            end
        else
            if this_answer==1
                Na2 = Na2+1;
            elseif this_answer==-1
                Nn2 = Nn2+1;
            else
                Nq2 = Nq2+1;
            end
        end
    end
end

Se   = (wa1*Aa1)/(Aa1+Aq1+An1)+wa2*(Aa2+Aq2)/(Aa2+Aq2+An2); % Sensibility
Sp   = (wn1*Nn1)/(Na1+Nq1+Nn1)+wn2*(Nn2+Nq2)/(Na2+Nq2+Nn2); % Specificity
MAcc = (Se+Sp)/2;  % Modified accuracy measure

str = ['  Sensibility:  ' '%1.4f\n'];
fprintf(str,Se)
str = ['  Specificity:  ' '%1.4f\n'];
fprintf(str,Sp)
str = ['  Final modified accuracy (MAcc):  ' '%1.4f\n'];
fprintf(str,MAcc)



