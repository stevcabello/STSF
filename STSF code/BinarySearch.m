function [output] = BinarySearch(X,y,ini_idx,agg_fn,candidate_agg_feats,repr_type)

    len_subinterval = size(X,2);

    if len_subinterval < 4 %%% when dividing by halves, each subset (i.e., left:0 and right:1) should have at least series of length 2 (i.e., 2 values).
        output = candidate_agg_feats;
        return;
    end

    div_point = floor(len_subinterval/2);

    sub_interval_0 = X(:,1:div_point);
    sub_interval_1 = X(:,div_point+1:end);
    
    interval_feature_0 = GetIntervalFeature(sub_interval_0,agg_fn);
    interval_feature_1 = GetIntervalFeature(sub_interval_1,agg_fn);

    score_0 = FisherScore(interval_feature_0,y);
    score_1 = FisherScore(interval_feature_1,y);

    if score_0 >= score_1
        w = size(sub_interval_0,2);
        ini0 = ini_idx+0;
        end0 = ini0+w-1;
        candidate_agg_feats{end+1} = {w,score_0,[ini0,end0],agg_fn,repr_type};
        [output] = BinarySearch(sub_interval_0, y, ini0, agg_fn, candidate_agg_feats,repr_type);

    else
        w = size(sub_interval_1,2);
        ini1 = ini_idx+div_point;
        end1 = ini1+w-1;
        candidate_agg_feats{end+1} = {w,score_1,[ini1,end1],agg_fn,repr_type};
        [output] = BinarySearch(sub_interval_1, y, ini1, agg_fn, candidate_agg_feats,repr_type);

    end

end

