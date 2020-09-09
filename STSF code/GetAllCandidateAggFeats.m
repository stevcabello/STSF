%Extract candidate aggregate features from three time series
%representations: 1. original time series, 2. frequency-domain (i.e., periodogram), 3.
%first-order derivative.

function [candidate_agg_feats] = GetAllCandidateAggFeats(X_train,y_train,agg_fns)
    
    %%For the extraction of candidate interval features we use the
    %%FisherScore feature ranking metrics. For such metric, all features must z-normalised.
    X_train = zscore(X_train);
    

    [candidate_agg_feats_timeOriginal] = GetCandidateAggFeats(X_train,y_train,agg_fns,1);

    
    %%convert time series to periodogram representation
    periodogram_X_train = abs(fft(X_train,[],2));
    periodogram_X_train = periodogram_X_train(:,1:end/2); %% symmetric representation..just first half is necessary
    [candidate_agg_feats_freqPeriodogram] = GetCandidateAggFeats(periodogram_X_train,y_train,agg_fns,2);

    %%convert time series to first-order derivative representation
    diff_X_train = diff(X_train,1,2);
    [candidate_agg_feats_timeDerivative] = GetCandidateAggFeats(diff_X_train,y_train,agg_fns,3);
   

    candidate_agg_feats = {candidate_agg_feats_timeOriginal{1,:},...
                           candidate_agg_feats_freqPeriodogram{1,:},...
                           candidate_agg_feats_timeDerivative{1,:}};
                       
end

