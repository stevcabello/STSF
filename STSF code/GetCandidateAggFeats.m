function [all_candidate_agg_feats] = GetCandidateAggFeats(X,y,agg_fns,repr_type)

    candidate_agg_feats = cell(1,1);
    cols_X = size(X,2);

    %generate random cut points to partition set of time series X into two smaller subsets
    random_cut_point = 4 + randperm(cols_X-8,1);

    cnt = 1;
    for i = 1:size(agg_fns,2)

            idx_ts = random_cut_point;

            %%% Extract candidate discriminatory interval features from first subset
            sub_ts_L = double(X(:,1:idx_ts));
            ini_L = 1;
            [cand_agg_feat_L] = SupervisedSearch(sub_ts_L,y,ini_L,agg_fns{i},{},repr_type);
            for b=1:size(cand_agg_feat_L,2)
                candidate_agg_feats(cnt) = cand_agg_feat_L(b);
                cnt = cnt + 1;
            end

            %%% Extract candidate discriminatory interval features from second subset
            sub_ts_R = double(X(:,idx_ts+1:end));
            ini_R = idx_ts+1;
            [cand_agg_feat_R] = SupervisedSearch(sub_ts_R,y,ini_R,agg_fns{i},{},repr_type);
            for b=1:size(cand_agg_feat_R,2)
                candidate_agg_feats(cnt) = cand_agg_feat_R(b);
                cnt = cnt + 1;
            end

    end

                                                        %%% remove empty cells
    all_candidate_agg_feats = candidate_agg_feats(~cellfun('isempty',candidate_agg_feats));

end

