% binary classification using fitcsvm
% read extracted features and perform binary classification
% written by Hong Tang, tanghong@dlut.edu.cn
% 2019-08-08

clc;clear;close all

% read features 
load('features_Tang.mat');    
% read quality labels 
load('quality_label_1_to_5.mat');

fsz=size(feature);
Fqual=zeros(fsz(1),1);
Fqual(quality_label>=4)=1;           % Binary labels

Bind=find(Fqual==0);    % quality bad
Gind=find(Fqual==1);    %quality good

KD=10;  % 10-fold validation

train_percent=0.1:0.1:0.9;
test_percent=1-train_percent;

for tk=1:length(train_percent)
    
    for rn=1:100    % times to repeat
    
  % to construct train and test set non-overlapped     
 [G_train_ind,G_test_ind]=crossvalind('LeaveMOut',length(Gind),round(test_percent(tk)*length(Gind)));
 [B_train_ind,B_test_ind]=crossvalind('LeaveMOut',length(Bind),round(test_percent(tk)*length(Bind)));

 train_ind=[Gind(G_train_ind); Bind(B_train_ind) ];
 test_ind=[Gind(G_test_ind); Bind(B_test_ind) ];
        
  feature_train=feature(train_ind,:);
  feature_test=feature(test_ind,:);
  Fqual_train=Fqual(train_ind)';
  Fqual_test=Fqual(test_ind); 
 
  % train svm for binary classification
    md=fitcsvm(feature_train,Fqual_train,'Standardize',true,...
    'KernelFunction','RBF',    'KernelScale','auto','kfold',KD);

    for cn=1:KD
    compactmd = md.Trained{cn};
    % predict
    est_Fqual=predict(compactmd,feature_test);
    
    % get the scores
    score(cn,:)=scoring_2group(Fqual_test,est_Fqual);
    
    clear compactmd est_Fqual;
    end
    
    score_set((rn-1)*KD+1:rn*KD,:)= score;
    
    [tk rn]
    clear G_train_ind G_test_ind B_train_ind B_test_ind;
    clear  train_ind  test_ind;
    clear feature_train feature_test  Fqual_train Fqual_test;
    clear md score;
    
    end
    
    % to calculate average and standard deviation
    Fscore_mean(tk,:)=mean(score_set);
    Fscore_std(tk,:)=std(score_set);
    
    clear score_set;
    
end

% save('binary_classification_results_Tang.mat','Fscore_mean','Fscore_std');

