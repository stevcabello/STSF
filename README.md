# The Supervised Time Series Forest (STSF)


A fast and accurate interval-based classifier for time series classification. This repository contains the source code for the STSF algorithm, published in the paper:


Nestor Cabello, Elham Naghizade, Jianzhong Qi, and Lars Kulik. [Fast and Accurate Time Series Classification Through Supervised Interval Search.](https://people.eng.unimelb.edu.au/jianzhongq/papers/ICDM2020_TimeSeriesClassificationViaIntervalSearch.pdf) In Proceedings of the 20th International Conference on Data Mining (ICDM 2020),
(acceptance rate: 9.8%), November 17-20, 2020, Virtual Event, Sorrento, Italy, 6 pages.


# Abstract

Time series classification (TSC) aims to predict the class label of a given time series. Modern applications such as appliance modelling require to model
an abundance of long time series, which makes it difficult to use many state-of-the-art TSC techniques due to their high computational cost and lack of 
interpretable outputs. To address these challenges, we propose a novel TSC method: the Supervised Time Series Forest (STSF). STSF improves the classification 
efficiency by examining only a (set of) sub-series of the original time series, and its tree-based structure allows for interpretable outcomes. 
STSF adapts a top-down approach to search for relevant sub- series in three different time series representations prior to training any tree classifier, 
where the relevance of a sub-series is measured by feature ranking metrics (i.e., supervision signals). Experiments on extensive real datasets show that 
STSF achieves comparable accuracy to state-of-the-art TSC methods while being significantly more efficient, enabling TSC for long time series.

# Usage

For a working example run --> STSF code/Main.m


# The Randomized-Supervised Time Series Forest (r-STSF)
A significantly more accurate and extremely fast interval-based classifier based on ideas from STSF can be found in:

Cabello, N., Naghizade, E., Qi, J. et al. Fast, accurate and explainable time series classification through randomization. Data Min Knowl Disc (2023). https://doi.org/10.1007/s10618-023-00978-w
