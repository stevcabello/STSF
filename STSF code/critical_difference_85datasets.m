%%load the classification accuracies comparison table
%%column: a classifier
%%row: a dataset
load('STSFcomparison.mat');

NNDTW = comparison_table(:,1);
TSF = comparison_table(:,2);
RISE = comparison_table(:,3);
BOSS = comparison_table(:,4);
FCN = comparison_table(:,5);
RESNET = comparison_table(:,6);
HCOTE = comparison_table(:,7);
PF = comparison_table(:,8);
CHIEF = comparison_table(:,9);
STSF = comparison_table(:,10);


scores_matrix_all_TSC = [FCN,BOSS,NNDTW,TSF,RISE,RESNET,HCOTE,PF,CHIEF,STSF];
scores_matrix = scores_matrix_all_TSC;
scores_matrix = 1-scores_matrix;

datasets_all = {'FCN','BOSS','DTW','TSF','RISE','ResNet','HCOTE','PF','CHIEF','STSF (ours)'};
datasets = datasets_all;

criticaldifference(scores_matrix,datasets,0.05);
