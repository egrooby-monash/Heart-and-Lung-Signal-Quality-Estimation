function [ fpr, tpr, final_threshold ] = threshold_ROC( nb_thresholds, label_annotated, powerband)
%threshold_ROC: Based on powerband. Compute the ROC to find the good threshold which will distinguish the CSs from NCSs.

%% INPUTS AND OUTPUTS
%  -- Inputs --
% thresholds_n: Number of thresholds for the ROC
% powerband: Powerband of all sections, with the tag_section (0=NCS, 1=CS). Shape of the matrix: [tag_section, powerband].
% -- Outputs --
% thershold_final: The better threshold to determine CS and NCS

%% INITIALISATION
thresholds_test=linspace(0, max(powerband), nb_thresholds); % Thresholds for the ROC
sensitivity=zeros(1,nb_thresholds);
specificity=zeros(1,nb_thresholds);

%% ROC COMPUTATION
% For each threshold
for i=1:nb_thresholds
    threshold=thresholds_test(i);
    
    % -- Compare powerband of each section to the threshold
    label_obtained=(powerband>threshold)*2; % Hypothesis: 2 for CS when powerband>threshold; 0 for NCS when powerband<threshold
    
    % -- Compare the labels obtained to the real labels
    res=label_annotated + label_obtained; % With 'real'/'obtained', 3=CS/CS; 1=CS/NCS; 2=NCS/CS; 0=NCS/NCS;
    
    % -- Actual and predicted CS and NCS
    nb_CS=sum(label_annotated); % Number of true CS
    nb_NCS=length(label_annotated)-nb_CS; % Number of true NCS
    nb_CS_ok=sum(res==3); % Number of good CS obtained
    nb_NCS_ok=sum(res==0); % Number of bad NCS obtained
    
    % -- Sensitivity and Specificity
    sensitivity(i)=nb_CS_ok/nb_CS;
    specificity(i)=nb_NCS_ok/nb_NCS;
end

% -- True Positive Ratio and the False Positive Ratio
tpr=sensitivity;
fpr=1-specificity;

%% FINAL THRESHOLD
dist=sqrt(fpr.^2+(1-tpr).^2); % Distance between top left corner and a point on the curve
[min_dist, argmin_dist]=min(dist); % Minimum distance
tpr_final=tpr(argmin_dist);
fpr_final=fpr(argmin_dist);
final_threshold=thresholds_test(argmin_dist); % The better threshold

%% ACCURACY
% -- Accuracy for all sections
final_label_obtained=(powerband>final_threshold)*2; % 2=CS; 0=NCS
label_comparison=label_annotated+final_label_obtained; % Comparison of true sections and the sections obtained (3=CS/CS; 1=CS/NCS; 2=NCS/CS; 0=NCS/NCS; )

% -- NCS accuracy
nb_section_NCS_OK=sum(label_comparison==0); % Number of NCS with a good label obtained
nb_section_NCS=sum(label_annotated==0); % Total number of NCS
accuracy_NCS=nb_section_NCS_OK/nb_section_NCS *100; % Percentage of good labelling

% -- CS accuracy
nb_section_CS_OK=sum(label_comparison==3); % Number of CS with a good label obtained
nb_section_CS=sum(label_annotated==1); % Total number of CS
accuracy_CS=nb_section_CS_OK/nb_section_CS*100; % Percentage of good labelling

% -- Total accuracy
accuracy=(nb_section_CS_OK+nb_section_NCS_OK)/(nb_section_CS+nb_section_NCS)*100;


%% DISPLAY
figure,
plot(fpr, tpr, 'Linewidth', 1.5);
hold on
plot(fpr, fpr, '--', 'Color', 'black')
plot(fpr(argmin_dist),tpr(argmin_dist), '-o', 'MarkerEdgeColor','red','MarkerFaceColor',[1 .4 .4])
hold off
title('ROC curve')
xlabel('False Positive Ratio (1-Specificity)')
ylabel('True Positive Ratio (Sensitivity)')
disp('OK thershold ROC');

