# MVARp

In-house Matlab implementation to run the MVARp method presented in
Gilson, M., Tauste Campo, A., Chen, X., Thiele, A., & Deco, G. (2017).
[Nonparametric test for connectivity detection in multivariate autoregressive networks 
and application to multiunit activity data](https://doi.org/10.1162/NETN_a_00019). Network Neuroscience, 1(4), 357-380.

Original Python code in https://github.com/MatthieuGilson/toy_models/blob/master/MVAR_Granger_detection.py

Our implementation was applied to fMRI data in this project https://github.com/cabal-cmu/feedback-discovery

## Implementation

**Input**: A dataset X, together with number of permutations and alpha level of significance.

**Output**: matrix A with estimated lagged causal coefficients, from Xt = AXt-1 + Et

Important: The output A is transposed such that Aij implies  Xi_t-1 -> Xj_t

