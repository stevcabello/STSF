function [y_predict_out,all_predicts_out] = STSFTest(X_test, T)

    total_trees = size(T,2);
    rows_X = size(X_test,1);
    
    %Periodogram representation of X_test
    periodogram_X_test = abs(fft(X_test,[],2));
    periodogram_X_test = periodogram_X_test(:,1:end/2);
    
    %First_order derivative representation of X_test
    diff_X_test = diff(X_test,1,2);
   

    tree_votes = zeros(rows_X,total_trees);

    for j = 1:total_trees
        tree = T{j}{1};
        
        total_candidate_agg_feats = size(tree.PredictorNames,2);
        cutpoints_idx = T{j}{3};
        total_cutpoints = size(cutpoints_idx,1);
        candidate_agg_feats_to_use = T{j}{2};
        
        %%%convert original testing set feature space to an interval feature space
        X_2_test = zeros(rows_X,total_candidate_agg_feats);

        for i = 1:total_cutpoints
            starting_point = candidate_agg_feats_to_use{i}{3}(1);
            ending_point = candidate_agg_feats_to_use{i}{3}(2);
            agg_fn = candidate_agg_feats_to_use{i}{4};
            repr_type = candidate_agg_feats_to_use{i}{5}; %%%1:original, 2:periodogram, 3:first-order derivative
            idx = cutpoints_idx(i);
            
            if repr_type == 1 
                xs = X_test(:,starting_point:ending_point);
                xs = double(xs);
            elseif repr_type == 2
                xs = periodogram_X_test(:,starting_point:ending_point);
                xs = double(xs);
            elseif repr_type == 3
                xs = diff_X_test(:,starting_point:ending_point);
                xs = double(xs);
            end
            
            X_2_test(:,idx) = GetIntervalFeature(xs,agg_fn);
            
        end

        tree_votes(:,j)=predict(tree, X_2_test); 

    end 
    
    y_predict_out = mode(tree_votes,2); %% majority vote
    all_predicts_out = tree_votes; %% this has the votes from each tree
    

end



