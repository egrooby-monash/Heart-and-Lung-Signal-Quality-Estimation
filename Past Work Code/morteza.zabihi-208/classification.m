function [classifyResult]= classification(ppp, nets, NAN_MEAN_INPUT, FEATURE_validation)
%%
% INPUT:
% SVMStruct             ----> Trained SVM Model (on trained data)
% FEATURE_validation    ----> Extracted Features
%
% OUTPUT:
% classifyResult  ----> Classification result(s)
%
%
% Contact:
% Morteza Zabihi (morteza.zabihi@gmail.com) && Ali Bahrami Rad(abahramir@yahoo.com)
% Black Swan Team (April 2016)
% This code is released under the MIT License (MIT) (http://opensource.org/licenses/MIT)
%
%% Classification ---------------------------------------------------------

% Scaling and Remove NaN --------------------------------------------------

ttt = mapminmax('apply',FEATURE_validation',ppp);
FEATURE_validation = ttt';

nanIndVal = isnan(FEATURE_validation);
for ii = 1:size(FEATURE_validation,2)
    FEATURE_validation(nanIndVal(:,ii),ii) = NAN_MEAN_INPUT(ii);   
end
% First Step --------------------------------------------------------------

for nn = 1:size(nets,2)
    netnn = nets{nn};
    output1val(:,:,nn)=  netnn(FEATURE_validation');
end

% Second Step -------------------------------------------------------------
diff_x = squeeze(round(output1val(2,:,:)));
diff_x = sum(diff_x);

Qdiff_x = squeeze(round(output1val(4,:,:)));
Qdiff_x = sum(Qdiff_x);

predicted_label_val = diff_x;
Qpredicted_label_val = Qdiff_x;

THE_LIM = 6;
QTHE_LIM = 16;

predicted_label_val (predicted_label_val <= THE_LIM) = -1;
predicted_label_val (predicted_label_val > THE_LIM) = 1;

Qpredicted_label_val (Qpredicted_label_val <= QTHE_LIM) = -1;
Qpredicted_label_val (Qpredicted_label_val > QTHE_LIM) = 1;

predicted_label_val (Qpredicted_label_val == 1) = 0;

classifyResult = double(predicted_label_val);


% true_label_val = vec2ind(nLABEL_VALIDATION')';
% 
% 
% true_label_val = true_label_val - 1;
% true_label_val(true_label_val == 0 )= -1;





