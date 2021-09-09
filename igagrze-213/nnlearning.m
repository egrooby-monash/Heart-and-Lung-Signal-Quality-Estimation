% Skrypt do uczenia - zbedny w wysylanym entry
% entry-5 na podstawie entry-2 (z unofficial phase)
% 11-08-2016 miclep

clear all;

TRAINING_SET = dlmread('featureaALL_training.txt');
VALIDATION_SET = dlmread('featureaALL_validation.txt');
% zbiory powyzsze sa zbalansowane przez powielanie

%TRAINING_SET = dlmread('C:\PNC2016\data\Dividing-dataset 26-07-2016\feature_matrix_36cech_z_bruteforce\realizacja 28-07/featureaALL_training_4.txt');
%VALIDATION_SET = dlmread('C:\PNC2016\data\Dividing-dataset 26-07-2016\feature_matrix_36cech_z_bruteforce\realizacja 28-07/featureaALL_validation_4.txt');

train_size = size(TRAINING_SET,1)
val_size = size(VALIDATION_SET,1)
overall_size = train_size + val_size;

FM = [ TRAINING_SET(:,1:(end-1)) ; VALIDATION_SET(:,1:(end-1)) ];

% usuwam kolumny 26 i 28 zeby bylo tak samo jak w entry-2?
%FM = [ FM(:,1:25) FM(:,27) FM(:,29:end) ];
% nie, jednak tak nie robimy

% usuwam wybrane kolumny
%FM = [ FM(:,1:41) FM(:,43:end) ] ; %FM(:,29:end) ];
FM = FM(:,(21:end));

targets = [ TRAINING_SET(:,end) ; VALIDATION_SET(:,end) ];
targets = ~(targets<0).*targets; % zamiania '-1' na '0'

inputs = FM;

inputs = inputs';
targets = targets';

% normalizacja na wszelki wypadek
mi = mean(inputs,2)';
st = std(inputs');
save meanandstd.mat mi st;

for i = 1:size(inputs,1)
    inputs(i,:) = inputs(i,:) - mi(i);
    inputs(i,:) = inputs(i,:)/st(i);
end

% Create a Pattern Recognition Network
hiddenLayerSize = [59];
net = patternnet(hiddenLayerSize);
%net.performFcn = 'mse';
net.trainFcn = 'trainlm';
%net.trainFcn = 'trainbr';
net.performParam.regularization = 0.1;

net.trainParam.epochs = 37; %130;
net.trainParam.max_fail = 500;

% wstepny skan reczny:
% trainscg 130 epok ~79-80%
% trainlm 35 epok ~80-81%
% trainbr - na razie dziwne

% Set up Division of Data for Training, Validation, Testing
net.divideFcn = 'divideblock';
net.divideParam.trainRatio = train_size/overall_size;
net.divideParam.valRatio = val_size/overall_size;
net.divideParam.testRatio = 0.0001/overall_size;

% Disabling nntraintool GUI window
%net.trainParam.showWindow = false;
%net.trainParam.showCommandLine = false; 

% Train the Network
[net,tr] = train(net,inputs,targets);

% save the network
save net.mat net;

