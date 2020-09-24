function [interval_feature] = GetIntervalFeature(xs,agg_fn)
    if isequal(agg_fn,'@mean')
        interval_feature = mean(xs,2);
    elseif isequal(agg_fn,'@std')
        interval_feature = std(xs,0,2);
    elseif isequal(agg_fn,'@min')
        interval_feature = min(xs,[],2);
    elseif isequal(agg_fn,'@max')
        interval_feature = max(xs,[],2);
    elseif isequal(agg_fn,'@median')
        interval_feature = median(xs,2);
    elseif isequal(agg_fn,'@iqr')
        interval_feature = iqr(xs,2);
    elseif isequal(agg_fn,'@slope')
        p=[1:size(xs,2)];
        interval_feature = getSlope(xs,p);
    end
end

