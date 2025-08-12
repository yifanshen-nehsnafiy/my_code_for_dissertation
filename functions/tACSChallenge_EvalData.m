function [ps,bs,int,phi,hit_probs,bs_permu] = tACSChallenge_EvalData(sorted_data,permu,log)
%% script originally written by Benedikt Zoefel, CNRS Toulouse, in October 2021

%% sorted_data is the output from tACSChallenge_SortData

% phi perfered phases

% curr data (:,2) Hit 
% curr data (:,3) RT

%% If input nargin < 2, permu = 0 and no permutation test will be applied. Default =1

%% If log = 1, logistic regression will be applied to hit; If log = 0, linear regression will be applied; Default =1

if nargin<2
permu = 1;
bs_permu =[];
log = 1;
end

if nargin<3
log=1;
end

n_cond = length(sorted_data);% number of conditions to be analysed
ps = zeros(n_cond,1);
bs = zeros(n_cond,1);
hit_probs = zeros(8,n_cond);

for c = 1:n_cond
    
    curr_data = sorted_data{c};
    
    if size(curr_data,2) >=4 && any(curr_data(:,2))
    
%% First Step: Eestimate the regression parameters
    if log==1  
        % for logsitic regression (hit)
    glm_input = zeros(size(curr_data,1),3);
    glm_input(:,1) = sin(curr_data(:,4));
    glm_input(:,2) = cos(curr_data(:,4));
    glm_input(:,3) = curr_data(:,2);
               
    g1 = fitglm(glm_input(:,1:2),glm_input(:,3),'distribution','binomial','link','logit');
    %p-value for phasic modulation of perception for single participant
    ps(c) = coefTest(g1);
    
    curr_b = mnrfit(glm_input(:,1:2),glm_input(:,3)+1);
    else
    % for linear regression (RT)

    % Recation time is only specific to trials where participants find a
    % target
    hit_trial = find(curr_data(:,2)==1);
    glm_input = zeros(length(hit_trial),3);
    glm_input(:,1) = sin(curr_data(hit_trial,4));
    glm_input(:,2) = cos(curr_data(hit_trial,4));
    glm_input(:,3) = curr_data(hit_trial,3);
               
    linModel = fitlm(glm_input(:,1:2), glm_input(:,3));
    ps(c) = coefTest(linModel);  % 如果想取各系数 p 值
    curr_b = linModel.Coefficients.Estimate;  % [截距, beta1, beta2]   

    end

    % the higher the regression coefficient, the stronger the phasic
    % modulation of perception
    % Extract the amplitude and intercept
    bs(c) = sqrt(curr_b(2)^2 + curr_b(3)^2);
    int(c) = curr_b(1);
    phi(c) = atan2(curr_b(3), curr_b(2));
    
    % Lim Regression 
    
    
%% Obtain the surrogate distribution 
    % Surrogate distribution
    if permu==1
    for i=1:1000
    glm_input_permu=[];    
    if log==1
        % for logsitic regression (hit)
    permu_phase = curr_data(randperm(length(curr_data(:,4))),4);
    glm_input_permu(:,1) = sin(permu_phase);
    glm_input_permu(:,2) = cos(permu_phase);
    glm_input_permu(:,3) = curr_data(:,2);
    curr_b_permu=mnrfit(glm_input_permu(:,1:2),glm_input_permu(:,3)+1);
    else
       % for linear regression (RT)
    hit_trial = find(curr_data(:,2)==1);
    permu_phase = curr_data(randperm(length(curr_data(hit_trial,4))),4);
    glm_input_permu(:,1) = sin(permu_phase);
    glm_input_permu(:,2) = cos(permu_phase);
    glm_input_permu(:,3) = curr_data(hit_trial,3);           
    linModel = fitlm(glm_input_permu(:,1:2), glm_input_permu(:,3));
    curr_b_permu = linModel.Coefficients.Estimate;  
    end
       % record the surrogate distribution of the amplitude
    bs_permu(c,i) = sqrt(curr_b_permu(2)^2 + curr_b_permu(3)^2);
    end
    end

    %% divide detection probability into phase bins (mostly for visualisation)
    for p = 2:8
        hit_probs(p,c) = sum(curr_data(curr_data(:,5)==p,2))/sum(curr_data(:,5)==p);
    end
    hit_probs(1,c) = (sum(curr_data(curr_data(:,5)==1,2))+sum(curr_data(curr_data(:,5)==9,2)))/ ...
        (sum(curr_data(:,5)==1)+sum(curr_data(:,5)==9));
    end
end



