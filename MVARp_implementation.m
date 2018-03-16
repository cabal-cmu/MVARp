function [A,permu,sig] = MVARp_implementation(X,nperm,alpha)
%function to compute coefficient matrix A = Q1/Q0 from a MVAR model Xt = AXt-1 + Et
% and significance of each A_ij using a permutation test via variable
% randomization.
% Ruben Sanchez-Romero, Carnegie Mellon University, 16-Mar-2018

%INPUT
% X: dataset, with variables in columns and datapoints in rows.
% nperm: the number of permutations of X for the permutation tet.
% alpha: the level of significance of the permutation test.
%OUTPUT
% A: estimated coefficient matrix of Xt = AXt-1 + Et  
% permu: the coefficients obtained for each of the p permutation
% sig: a binary matrix with significant edges: sig_ij implies i -> j,
%   formally i_t-1 -> j_t
%
%This code implements https://github.com/MatthieuGilson/toy_models/blob/master/MVAR_Granger_detection.py
%Gilson, M., Tauste Campo, A., Chen, X., Thiele, A., & Deco, G. (2017).
%Nonparametric test for connectivity detection in multivariate autoregressive networks 
%and application to multiunit activity data. Network Neuroscience, (Early Access), 1-24.


%%

nodes = size(X,2);  %get number of nodes

for i = 1:size(X,2) %compute the cross-covariance across all the variables
  for j = 1:size(X,2)
         c = xcov(X(:,i),X(:,j),1,'unbiased');  %compute the unbiased cross-covariane of lag_-1, lag_0, lag_1
          Q1(i,j) = c(3); %get the cross-covariance of lag-1 : i_t and j_t-1
          Q0(i,j) = c(2);  %get the cross-covariance of lag-0  : i_t and j_t
  end
end


A = Q1/Q0;   % A = (Q_1)*(Q_0)^-1  coeff matrix with direction column --> row

A = A';   %transpose to get the reading row --> column 


%make the p permutations of data X
timepoints = size(X,1);
Y = zeros(size(X)); %allocate memory
permu = zeros(nodes,nodes,nperm);  %pre-allocate memory

for p = 1:nperm
    
   for s = 1:nodes   %permute each column of X independently
       %%for circular-shift permutation
       %randshift = randi(timepoints);
       %Y(:,s) = circshift(X(:,s),randshift);
       
       %%for random permutation
       randindex = datasample(1:timepoints,timepoints,'Replace',false); 
       Y(:,s) = X(randindex,s);
   end
   
      for i = 1:size(Y,2) %compute the cross-covariance across all the permuted variables
            for j = 1:size(Y,2)
               c_p = xcov(Y(:,i),Y(:,j),1,'unbiased');  %compute the cross-covariane of lag_-1, lag_0, lag_1
               Q1_p(i,j) = c_p(3); %get the cross-covariance of lag-1 : i_t and j_t-1
               Q0_p(i,j) = c_p(2);  %get the cross-covariance of lag-0  : i_t and j_t
            end
      end

        A_p = Q1_p/Q0_p;   % a = (Q_1)*(Q_0)^-1  coeff column --> ro
        A_p = A_p';
        permu(:,:,p) = A_p;
        
end

%significance test
sensitivity = alpha*nperm;  %the threshold for significance relative to the data

%two-tailed tests to account for negative and positive coefficients.
   max_A_ij = sort(abs(permu),3);
   sig = abs(A) > max_A_ij(:,:,end-sensitivity);


   
   
    
    
    

