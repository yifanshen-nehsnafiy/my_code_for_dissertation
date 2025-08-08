function [all_ps,all_bs,all_int,all_phi,p_permu] = tACSChallenge_AnalyseData(data_path, lab,subjs, conditions,condition_names,permu,log)
%% script originally written by Benedikt Zoefel, CNRS Toulouse, in October 2021
%% modified in April 22
%% run this script with the following input argments:
%% - folder to your data, example: '../data/'
%% - subect initials to be analysed. The data for each subject must be in a separate folder that is labeled as such
%% (e.g., 'P01') and is located in the data folder. Example: {'P01, P02', P03'}
%% - condition labels to be analysed. Label must be part of the file name (including the stars in the example).
%% Example: {'*Montage A*','*Montage B*','*Montage C*'}


%% modified by Yifan in 07/25 for thesis
%% new input
%% condition_names the formal names for conditions included
%% permu = 0 no permutation test; permu = 1 permutation test 
%% log = 1 logistic regression for hits; log=0 linear regression for RT

clc; close all;

if nargin<6
    permu = 0;
    p_permu =[];
    log=1;
end

if nargin<7
log = 1;
end



addpath('./functions/');

if nargin < 4
condition_names = condition;
end


all_ps = zeros(length(conditions),length(subjs));
all_bs = zeros(length(conditions),length(subjs));
all_hit_probs = zeros(8,length(conditions),length(subjs));

% set a random seed to ensure reproducitivity
rng(123); 


for s = 1:length(subjs)
    % load the data
    curr_data = tACSChallenge_SortData(data_path, lab,subjs(s), conditions);
    % and analyse it
    [all_ps(:,s), all_bs(:,s), all_int(:,s),all_phi(:,s), all_hit_probs(:,:,s),all_bs_permu(:,:,s)] = tACSChallenge_EvalData(curr_data,permu,log);    
end

% Caculate the permutation results p values - the relative position of
% empirical amplitude
if permu ==1
mean_all_bs_permu = mean(all_bs_permu,3);
mean_bs = mean (all_bs,2);
for i=1:length(mean_bs)
p_permu(i) = sum(mean_all_bs_permu(i,:) > mean_bs(i)) / size(all_bs_permu,2);
end
end

all_hit_probs(9,:,:) = all_hit_probs(1,:,:); % duplicate first phase bin for visualisation

figure
set(gcf, 'Position', [100, 100, 800, 444]); %  w:h = 1.8:1
subplot(1,2,1);
plot(-pi:pi/4:pi,squeeze(mean(all_hit_probs,3)))
xlabel('tACS phase'); ylabel('detection probability'); legend(condition_names);
set(gcf,'Color',[1 1 1]);
xlim([-pi,pi]);
xticks([-pi,-pi/2,0,pi/2,pi]);
xticklabels ({'-pi','-pi/2','0','pi/2','pi'})

subplot(1,2,2);
bar(mean(all_bs,2))
xlabel('conditions'); xticklabels(condition_names); ylabel('modulation strength');
set(gcf,'Color',[1 1 1]);



