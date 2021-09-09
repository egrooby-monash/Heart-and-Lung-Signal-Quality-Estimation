% triple classification using fitcsvm based on onevs one
% written by Hong Tang, tanghong@dlut.edu.cn
% 2019-08-08

clc;clear;close all

% read features 
load('features_Tang.mat');

% read quality labels 
load('quality_label_1_to_5.mat');

fsz=size(feature);  
% three classification for quality
% 0 for "unacceptable", 1 for "good", and 2 for "excellent"
Fqual=zeros(fsz(1),1);   
Fqual(quality_label>=4)=1;
Fqual(quality_label>=5)=2;

Bind=find(Fqual==0);     % quality unacceptabble
Gind=find(Fqual==1);    %  quality good
Eind=find(Fqual==2);     % quality excellent

KD=10;

train_percent=0.1:0.1:0.9;
test_percent=1-train_percent;

for tk=1:length(train_percent)
    
    for rn=1:100  % times to repeat
    
        % to construct training and test set non-overlapped
 [G_train_ind,G_test_ind]=crossvalind('LeaveMOut',length(Gind),round(test_percent(tk)*length(Gind)));
 [B_train_ind,B_test_ind]=crossvalind('LeaveMOut',length(Bind),round(test_percent(tk)*length(Bind)));
 [E_train_ind,E_test_ind]=crossvalind('LeaveMOut',length(Eind),round(test_percent(tk)*length(Eind)));

 train_ind_GB=[Gind(G_train_ind); Bind(B_train_ind)];
 train_ind_GE=[Gind(G_train_ind); Eind(E_train_ind)];
 train_ind_BE=[ Bind(B_train_ind); Eind(E_train_ind)];
 
 test_ind_GB=[Gind(G_test_ind); Bind(B_test_ind)];
 test_ind_GE=[Gind(G_test_ind);  Eind(E_test_ind)];
 test_ind_BE=[ Bind(B_test_ind); Eind(E_test_ind)];
 
  feature_train_GB=feature(train_ind_GB,:);
  feature_train_GE=feature(train_ind_GE,:);
  feature_train_BE=feature(train_ind_BE,:);
  
  feature_test_GB=feature(test_ind_GB,:);
  feature_test_GE=feature(test_ind_GE,:);
  feature_test_BE=feature(test_ind_BE,:);
  feature_test=[feature_test_GB; feature_test_GE; feature_test_BE];
  
  Fqual_train_GB=Fqual(train_ind_GB)';
  Fqual_train_GE=Fqual(train_ind_GE)';
  Fqual_train_BE=Fqual(train_ind_BE)';
  
  Fqual_test_GB=Fqual(test_ind_GB); 
  Fqual_test_GE=Fqual(test_ind_GE); 
  Fqual_test_BE=Fqual(test_ind_BE); 
  Fqual_test=[Fqual_test_GB;Fqual_test_GE;Fqual_test_BE];
 
  % train svm for binary classification
    md_GB=fitcsvm(feature_train_GB,Fqual_train_GB,'Standardize',true,...
    'KernelFunction','RBF',    'KernelScale','auto','kfold',KD);

    md_GE=fitcsvm(feature_train_GE,Fqual_train_GE,'Standardize',true,...
    'KernelFunction','RBF',    'KernelScale','auto','kfold',KD);

    md_BE=fitcsvm(feature_train_BE,Fqual_train_BE,'Standardize',true,...
    'KernelFunction','RBF',    'KernelScale','auto','kfold',KD);

    for cn=1:KD
    compactmd_GB = md_GB.Trained{cn};
    est_GB=predict(compactmd_GB,feature_test);
    
    compactmd_GE = md_GE.Trained{cn};
    est_GE=predict(compactmd_GE,feature_test);
    
    compactmd_BE = md_BE.Trained{cn};
    est_BE=predict(compactmd_BE,feature_test);
    
    est_Fqual=label_decision_scheme_triple_classification(est_GB,est_GE,est_BE);

    score(cn,:)=scoring_3group(Fqual_test,est_Fqual);
    
    clear compactmd_GB  est_GB compactmd_GE est_GE compactmd_BE est_BE est_Fqual;
    end
    
    score_set((rn-1)*KD+1:rn*KD,:)= score;
    
    [tk rn]
    clear G_test_ind G_test_ind B_train_ind  B_test_ind _train_ind  E_test_ind ;
    clear  train_ind_GB train_ind_GE train_ind_BE;
    clear test_ind_GB test_ind_GE test_ind_BE feature_train_GB feature_train_GE feature_train_BE;
    clear feature_test_GB feature_test_GE feature_test_BE feature_test;
    clear Fqual_train_GB Fqual_train_GE Fqual_train_BE;
    clear Fqual_test_GB Fqual_test_GE Fqual_test_BE Fqual_test;
    clear md_GB md_GB md_BE;
    
    end
    % to calculate average and standard deviation
    Fscore_mean(tk,:)=mean(score_set);
    Fscore_std(tk,:)=std(score_set);
    
   clear score_set;

    
end

% save('triple_classification_results_Tang.mat','Fscore_mean','Fscore_std');
