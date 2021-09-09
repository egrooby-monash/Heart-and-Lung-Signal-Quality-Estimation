function [Final_result] = Scoring (classifyResult, label_validation, label_validation_Qa)
%%
% INPUT:
% classifyResult        ----> raw data (current epoch)
% label_validation      ----> raw data (next epoch)
%
% 
% OUTPUT:
% Final_result  ----> Includes AUC, sensitivity, specificity, accuracy, and the competiotion score 
%
%
% Contact:
% Morteza Zabihi (morteza.zabihi@gmail.com) && Ali Bahrami Rad(abahramir@yahoo.com)
% Black Swan Team (April 2016)
% This code is released under the MIT License (MIT) (http://opensource.org/licenses/MIT)
%
%%
% ind = find(isnan(label_validation == 1)); label_validation(ind) = 0;


LABEL_VALIDATION = label_validation';
QLABEL_VALIDATION = label_validation_Qa';
QLABEL_VALIDATION (QLABEL_VALIDATION == 0) = -1;
QLABEL_VALIDATION = -1 * QLABEL_VALIDATION;



true_label_val = LABEL_VALIDATION;
Qtrue_label_val = QLABEL_VALIDATION;

TRUE1_label_val = true_label_val(Qtrue_label_val == -1);
TRUE2_label_val = true_label_val(Qtrue_label_val == 1);


predicted_label_val = classifyResult;
PRED1_label_val = predicted_label_val(Qtrue_label_val == -1);
PRED2_label_val = predicted_label_val(Qtrue_label_val == 1);

[D1,order1] = confusionmat(TRUE1_label_val,PRED1_label_val,'order',[-1,0,1]);
D1(2,:) = [];

[D2,order2] = confusionmat(TRUE2_label_val,PRED2_label_val,'order',[-1,0,1]);
D2(2,:) = [];

%%

wa1 = sum(D1(2,:))/(sum(D1(2,:))+sum(D2(2,:)));
wa2 = sum(D2(2,:))/(sum(D1(2,:))+sum(D2(2,:)));

wn1 = sum(D1(1,:))/(sum(D1(1,:))+sum(D2(1,:)));
wn2 = sum(D2(1,:))/(sum(D1(1,:))+sum(D2(1,:)));

Spe1 = (wn1*D1(1,1))/(D1(1,1)+D1(1,2)+D1(1,3)); 
Sen1 = (wa1*D1(2,3))/(D1(2,1)+D1(2,2)+D1(2,3)); 

Spe2 = wn2*(D2(1,1)+D2(1,2))/(D2(1,1)+D2(1,2)+D2(1,3)); 
Sen2 = wa2*(D2(2,3)+D2(2,2))/(D2(2,1)+D2(2,2)+D2(2,3)); 

SPEs = Spe1+Spe2;
SENs = Sen1+Sen2;

score = mean([SENs SPEs]);


Final_result = [SPEs SENs score];
%% Print ------------------------------------------------------------------


fprintf('Classification is done... \n\n\n');
fprintf('Classification Results on validation: \n');
fprintf('----------------------- \n');
%fprintf('AUC:         %1.4f \n', auc);
fprintf('Sensitivity: %1.4f \n', SENs);
fprintf('Specificity: %1.4f \n', SPEs);
%fprintf('Accuracy:    %1.4f \n', Accu);
fprintf('Score:       %1.4f \n', score);
fprintf('----------------------- \n');