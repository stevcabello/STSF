
warning('off','all');

runs = 10; %% number of replicates
ntrees = 500; %% number of trees in the ensemble
agg_fns = {'@slope','@iqr','@median','@std','@mean','@min','@max'}; %%set of aggregation functions


 

%to test all 85 datasets mentioned in the paper, please uncomment the lines below and
%add the correspoding datasets to datasetsUCR folder 
%or 
%change the datasets directory as described in TrainTest.m
              
%%% 85 datasets
% dset_names = ["Adiac","ArrowHead","Beef","BeetleFly","BirdChicken","Car",...
%               "CBF","ChlorineConcentration","CinCECGTorso","Coffee",...
%               "Computers","CricketX","CricketY","CricketZ",...
%               "DiatomSizeReduction","DistalPhalanxOutlineAgeGroup",...
%               "DistalPhalanxOutlineCorrect","DistalPhalanxTW",...
%               "Earthquakes","ECG200","ECG5000","ECGFiveDays",...
%               "ElectricDevices","FaceAll","FaceFour","FacesUCR",...
%               "FiftyWords","Fish","FordA","FordB","GunPoint","Ham",...
%               "HandOutlines","Haptics","Herring","InlineSkate",...
%               "InsectWingbeatSound","ItalyPowerDemand",...
%               "LargeKitchenAppliances","Lightning2","Lightning7",...
%               "Mallat","Meat","MedicalImages",...
%               "MiddlePhalanxOutlineAgeGroup",...
%               "MiddlePhalanxOutlineCorrect","MiddlePhalanxTW",...
%               "MoteStrain","NonInvasiveFetalECGThorax1",...
%               "NonInvasiveFetalECGThorax2","OliveOil","OSULeaf",...
%               "PhalangesOutlinesCorrect","Phoneme","Plane",...
%               "ProximalPhalanxOutlineAgeGroup",...
%               "ProximalPhalanxOutlineCorrect","ProximalPhalanxTW",...
%               "RefrigerationDevices","ScreenType","ShapeletSim",...
%               "ShapesAll","SmallKitchenAppliances",...
%               "SonyAIBORobotSurface1","SonyAIBORobotSurface2",...
%               "StarLightCurves","Strawberry","SwedishLeaf","Symbols",...
%               "SyntheticControl","ToeSegmentation1","ToeSegmentation2",...
%               "Trace","TwoLeadECG","TwoPatterns","UWaveGestureLibraryAll",...
%               "UWaveGestureLibraryX","UWaveGestureLibraryY",...
%               "UWaveGestureLibraryZ","Wafer","Wine","WordSynonyms",...
%               "Worms","WormsTwoClass","Yoga"];

% use this dataset to run an example
dset_names = ["ItalyPowerDemand"];
           
all_accuracies = zeros(1,runs);
all_training_time = zeros(1,runs);
all_testing_time = zeros(1,runs);
all_n_features = zeros(1,runs);
all_n_nodes = zeros(1,runs);


all_datasets_avg_accuracy = zeros(1,size(dset_names,2));
all_datasets_avg_training_time = zeros(1,size(dset_names,2));
all_datasets_avg_testing_time = zeros(1,size(dset_names,2));
all_datasets_avg_nfeats = zeros(1,size(dset_names,2));
all_datasets_avg_nnodes = zeros(1,size(dset_names,2));


nrows = size(dset_names,2);
allDatasets = cell(nrows+2,17);
allDatasets(1,1) = {'Datasets'}; allDatasets(1,2) = {'run1'}; 
allDatasets(1,3) = {'run2'}; allDatasets(1,4) = {'run3'}; allDatasets(1,5) = {'run4'};
allDatasets(1,6) = {'run5'}; allDatasets(1,7) = {'run6'}; allDatasets(1,8) = {'run7'};
allDatasets(1,9) = {'run8'}; allDatasets(1,10) = {'run9'}; allDatasets(1,11) = {'run10'};
allDatasets(1,12) = {'Accuracy'}; allDatasets(1,13) = {'TrainingTime'}; 
allDatasets(1,14) = {'TestingTime'}; allDatasets(1,15) = {'TotalTime'};
allDatasets(1,16) = {'TotalFeatures'};
allDatasets(1,17) = {'TotalNodes'};


for i=1:size(dset_names,2)
    
    disp(dset_names(i));
    
    [X_train, y_train, X_test, y_test] = TrainTest(dset_names(i));

%     %%convert the labels to have the following format: 1,2,3,4,......
%     %%this is because the classperf function (used below) to assess the
%     %%classification accuracy only accepts possitive labels.
    [y_train,y_test] = ConvertLabels(y_train,y_test);


    for j=1:runs
        disp(['run: ',num2str(j)]);

        tic;
        [T,nfeats,nnodes] = STSFTrain(X_train,y_train,ntrees,agg_fns);
        training_time = toc;

        tic;
        [y_predict,all_predicts] = STSFTest(X_test,T);
        testing_time = toc;

        accuracy = (sum(y_predict==y_test)/length(y_test));
        disp(['accuracy: ', num2str(accuracy)]);
        
        all_accuracies(j) = accuracy;
        all_training_time(j) = training_time;
        all_testing_time(j) = testing_time;
        all_n_features(j) = nfeats;
        all_n_nodes(j) = nnodes;

        allDatasets(i+1,1) = {dset_names(i)};
        allDatasets(i+1,j+1) = {accuracy};

    end


    avg_accuracy = mean(all_accuracies);
    avg_training_time = mean(all_training_time);
    avg_testing_time = mean(all_testing_time);

    avg_nfeats = mean(all_n_features);
    avg_nnodes = mean(all_n_nodes);

    fprintf('\n');
    disp(['avg_accuracy: ', num2str(avg_accuracy)]);
    disp(['avg_training time: ', num2str(avg_training_time)]);
    disp(['avg_testing time: ', num2str(avg_testing_time)]);
    disp(['avg_total time: ', num2str(avg_training_time+avg_testing_time)]);

    all_datasets_avg_accuracy(i) = avg_accuracy;
    all_datasets_avg_training_time(i) = avg_training_time;
    all_datasets_avg_testing_time(i) = avg_testing_time;

    all_datasets_avg_nfeats(i) = avg_nfeats;
    all_datasets_avg_nnodes(i) = avg_nnodes;

    allDatasets(i+1,12) = {avg_accuracy}; 
    allDatasets(i+1,13) = {avg_training_time}; 
    allDatasets(i+1,14) = {avg_testing_time}; 
    allDatasets(i+1,15) = {avg_training_time+avg_testing_time};
    allDatasets(i+1,16) = {avg_nfeats};
    allDatasets(i+1,17) = {avg_nnodes};
    
end

fprintf('\n');

total_training_time = sum(all_datasets_avg_training_time);
total_testing_time = sum(all_datasets_avg_testing_time);
disp(['avg_accuracy all datasets: ', num2str(mean(all_datasets_avg_accuracy))]);
disp(['avg_training time all datasets: ', num2str(total_training_time)]);
disp(['avg_testing time all datasets: ', num2str(total_testing_time)]);
disp(['Total time all datasets: ', num2str(total_training_time+total_testing_time)]);


for v=1:runs
    allDatasets(nrows+2,v+1) = {mean([allDatasets{2:nrows+1,v+1}])};
end


allDatasets(nrows+2,12) = {mean(all_datasets_avg_accuracy)}; 
allDatasets(nrows+2,13) = {total_training_time};
allDatasets(nrows+2,14) = {total_testing_time}; 
allDatasets(nrows+2,15) = {total_training_time+total_testing_time};


disp(allDatasets);


fname = ['STSF_accuracies','_ntrees_',num2str(ntrees),'_',num2str(runs),'_runs'];
allDatasets_table = cell2table(allDatasets(2:end,:),'VariableNames',allDatasets(1,:));
writetable(allDatasets_table,['output/',fname,'.csv']);
