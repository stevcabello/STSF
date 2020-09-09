function [T_out,n_features_out,n_nodes_out] = STSFTrain(X_all_train, y_all_train, ntrees, agg_fns)

n_features = zeros(ntrees,1);
n_nodes = zeros(ntrees,1);
T = {};


all_classes = unique(y_all_train);
nclasses = size(all_classes,1);
ninstances_per_class = zeros(nclasses,1);

for c=1:nclasses
    ninstances_per_class(c) = sum(y_all_train==all_classes(c));
end

avg_ninstances_per_class =ceil(mean(ninstances_per_class)); %% minimum number of time series instances each class should have.
inx = ninstances_per_class<avg_ninstances_per_class;
all_classes_lessthanavg = all_classes(inx);

X_train_to_add = [];
y_train_to_add = [];

%%over-sampling strategy to handle class imbalance
for p = 1:size(all_classes_lessthanavg,1)

    current_class = all_classes_lessthanavg(p);
    current_class_idx = find(all_classes==current_class);
    toadd = avg_ninstances_per_class-ninstances_per_class(current_class_idx);

    row_idx = y_all_train==current_class;
    X_train_c = X_all_train(row_idx,:);
    inx = randsample(size(X_train_c,1),toadd,1);
    X_train_to_add_c = X_train_c(inx,:);
    y_train_to_add_c = ones(toadd,1)*current_class;

    X_train_to_add = [X_train_to_add;X_train_to_add_c];
    y_train_to_add = [y_train_to_add;y_train_to_add_c];

end





for t = 1:ntrees

   
%     X_train_to_add = [];
%     y_train_to_add = [];
% 
%     %%over-sampling strategy to handle class imbalance
%     for p = 1:size(all_classes_lessthanavg,1)
% 
%         current_class = all_classes_lessthanavg(p);
%         current_class_idx = find(all_classes==current_class); %% added 19/may/2020
%         toadd = avg_ninstances_per_class-ninstances_per_class(current_class_idx);%(current_class);
% 
%         row_idx = y_all_train==current_class;
%         X_train_c = X_all_train(row_idx,:);
%         inx = randsample(size(X_train_c,1),toadd,1);
%         X_train_to_add_c = X_train_c(inx,:);
%         y_train_to_add_c = ones(toadd,1)*current_class;
% 
%         X_train_to_add = [X_train_to_add;X_train_to_add_c];
%         y_train_to_add = [y_train_to_add;y_train_to_add_c];
% 
%     end



    
    %%bagging strategy to build uncorrelated trees
    inx = randsample(size(X_all_train,1),ceil(size(X_all_train,1)*1),1);%1: with replacement; 0: without replacement

    X_train = X_all_train(inx,:);
    X_train = [X_train;X_train_to_add];

    y_train = y_all_train(inx,:);
    y_train = [y_train;y_train_to_add];
    
    %get candidate agg feats from three time serie representations
    candidate_agg_feats = GetAllCandidateAggFeats(X_train,y_train,agg_fns); 
    total_candidate_agg_feats = size(candidate_agg_feats,2);
    n_features(t)=total_candidate_agg_feats;
    

    %%create periodogram and derivative representation to be used (below) when
    %%building a tree.
    periodogram_X_train = abs(fft(X_train,[],2));
    periodogram_X_train = periodogram_X_train(:,1:end/2); 
    
    diff_X_train = diff(X_train,1,2);
    
    
    %%%% convert original feature space to an interval feature space
    rows_X = size(X_train,1);
    X_2_train = zeros(rows_X,total_candidate_agg_feats);
    
    for j = 1:total_candidate_agg_feats
        %ws = candidate_agg_feats{j}{1};
        %scores = candidate_agg_feats{j}{2};
        starting_point = candidate_agg_feats{j}{3}(1);
        ending_point = candidate_agg_feats{j}{3}(2);
        agg_fn = candidate_agg_feats{j}{4};
        repr_type = candidate_agg_feats{j}{5}; %%%1:original, 2:periodogram, 3:first-order derivative

        if repr_type == 1
            xs = X_train(:,starting_point:ending_point);
        elseif repr_type == 2
            xs = periodogram_X_train(:,starting_point:ending_point);
        elseif repr_type == 3
            xs = diff_X_train(:,starting_point:ending_point);
        end
        X_2_train(:,j) = GetIntervalFeature(xs,agg_fn);

    end
    

    tree = fitctree(X_2_train,y_train,'SplitCriterion','deviance');%'NumVariablesToSample',qRandomPredictors); %%%% train a tree with the interval feature representation
    cutpredictors = tree.CutPredictor;   
    cutpredictors_str =  unique(cutpredictors(~cellfun('isempty',cutpredictors)));
    cutpredictors_num = cellfun(@(x) x(2:end), cutpredictors_str, 'un', 0);
    cutpredictors_idx = str2double(cutpredictors_num);
    candidate_agg_feats_to_use = candidate_agg_feats(cutpredictors_idx); %%%% to only use the best predictors (i.e., splitting node features or candidate interval features)
    
    n_nodes(end+1) = tree.NumNodes;%size(candidate_agg_feats_to_use,2); %% to keep record of the number of nodes of the generated tree.
    
    T{end+1} = {tree, candidate_agg_feats_to_use, cutpredictors_idx}; %% store the tree and candidate interval features 
    
    


end


T_out = T;
n_features_out = mean(n_features);
n_nodes_out = mean(n_nodes);

end

