function score = FisherScore(X_feat,y)

    groupLabels = unique(y);

    mu_feat = mean(X_feat);

    accum_numerator = 0;
    accum_denominator = 0;

    for k=1:size(groupLabels,1)
        idx_label = find(y==groupLabels(k));
        nk = size(idx_label,1);
        mu_feat_label = mean(X_feat(idx_label,1));
        sigma_feat_label = std(X_feat(idx_label,1));

        accum_numerator = accum_numerator + (nk*(mu_feat_label-mu_feat)^2);
        accum_denominator = accum_denominator + (nk*(sigma_feat_label)^2);
    end

    score_p = accum_numerator/accum_denominator;

    if isnan(score_p)
        score = 0;
    else
        score = score_p;
    end


end

