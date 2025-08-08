%% Add necessary packages
addpath(genpath('eeglab2025.0.0'));

%% Phasic Modulation


data_path = "C:\Users\yf_sh\Downloads\tACS_challenge\Data"; % Adapt the datapath to the path on your computer
labnum=18;
subjs = [1:22];


block_sequence = {'S2','S3','S2','S2','S3','S1','S1','S2','S1','S3','S3','S1','S3','S2','S2','S1','S1','S1','S3','S3','S2','S2'};

Post_seq_S1 = {'post_C','pre_stim','post_B','post_A'};

Post_seq_S2 = {'post_A','pre_stim','post_C','post_B'};

Post_seq_S3 = {'post_B','pre_stim','post_A','post_C'};

conditions{1} = "A";  % cutaneous
conditions{2} = "B";  % occipital
conditions{3} = "C";  % retinal
conditions{4} = "Sh";  % Sham condition (no phasic modulation) included for preliminary comparison with condition A

condition_names = {'Occipital','Retinal','Cutaneous','Sham'};

permu= 1; % a permutation test included
log = 1; % logistic regression for hit
[all_ps_hit,all_bs_hit,all_int_hit,all_phi_hit,p_value_hit] = tACSChallenge_AnalyseData(data_path, labnum, subjs, conditions,condition_names,permu,log);

permu= 1; % a permutation test included
log = 0; % linear regression
[all_ps_RT,all_bs_RT,all_int_RT,all_phi_RT,p_value_RT] = tACSChallenge_AnalyseData(data_path, labnum,subjs, conditions,condition_names,permu,log);

% 将这个调节系数进行保存, 包括被试的编号，每一个是hit 还是 miss, IAF值等

% 将结果整理到一个表里面，然后根据这个表做general performance的mixed-effects models (applied with R)

%% IAF estimation
lab_num = 18;
t=0;
for sub_num = 1:length(subjs)
% Input the subject num, then the function will output the IAF results
% IAF_results(:,1): Pre EC; IAF_results(:,2): Pre EO; IAF_results(:,3): Pre
% EC; IAF_results(:,4): Pre EO
t=t+1;
[PAF_results(:,t),PSD_results(:,:,t),f] = IAF_estimate (data_path, lab_num, sub_num);

end

%% Save the smmuary table (trial-wise performance)
condition_recorded = {};

t=0;
sham_condition = cell(1, (length(subjs)-2)*1550);

for i=1:length(subjs)
    if i==3||i==4
        continue % skip the third and the forth
    end
     
    for ii = 1:length(conditions)
        %计数君：如果不是sham,那就是150个trial；如果是sham，那就是50个trial
        initial = t;    
        if strcmp (conditions{ii},'Sh')
        t=t+200;
        % sham的最终输出，一般第1个是最后一个 第2个是第1个 第3个是2个 第4个是3个
           if strcmp(block_sequence{i},'S1')
           this_post_seq = Post_seq_S1;
           elseif strcmp(block_sequence{i},'S2')
           this_post_seq = Post_seq_S2;
           elseif strcmp(block_sequence{i},'S3')
           this_post_seq = Post_seq_S3;
           end
         
            sham_condition_alternative(1:50)   = repmat(this_post_seq(1), 1, 50);
            sham_condition_alternative(51:100) = repmat(this_post_seq(2), 1, 50);
            sham_condition_alternative(101:150)= repmat(this_post_seq(3), 1, 50);
            sham_condition_alternative(151:200)= repmat(this_post_seq(4), 1, 50);
            sham_condition(initial+1:t) = sham_condition_alternative;

        else
        t=t+450; 
        sham_condition(initial+1:t) = repmat({'0'},1, t-initial);
        end
        IAF_pre (initial+1:t) = ones(1,t-initial)*PAF_results(1,i);
        IAF_post (initial+1:t) = ones(1,t-initial)*PAF_results(3,i);
        
        condition_sequence(initial+1:t) = repmat(block_sequence(i), 1, t-initial); 
        condition_recorded(initial+1:t) = repmat(conditions(ii), 1, t-initial);
        participant_id(initial+1:t)=ones(1,t-initial)*i;
        trials_sorted  = tACSChallenge_SortData(data_path, labnum,i, conditions{ii});
        trials_sorted  = trials_sorted{1};
        Hit(initial+1:t,:) = trials_sorted (:,2);
        RT(initial+1:t,:) = trials_sorted (:,3);

        phase(initial+1:t,:) = trials_sorted (:,4);

    end
end

% 同时需要得到每个被试IAF

% 整理成一个大表 进行保存，需要的变量有哪些？

% 性别 年龄 电流 sequence IAF 电阻 被试性别 Condition Passive Condition Hit/Miss RT
T = table();
T.SubjectCode = participant_id(:);
T.Condition     = condition_recorded(:);
T.IAF_Pre       = IAF_pre(:);
T.IAF_Post      = IAF_post(:);
T.Hit           = Hit(:);
T.RT            = RT(:);
T.Condition_seq = condition_sequence(:);
T.sham_seq = sham_condition(:);
T.phase = phase(:);

writetable(T, 'trial_summary.csv');


% 甚至sham 还要分出不同的条件

%% Save the summary table (regression coefficients)
t=0;
for i=1:length(subjs)
    if i==3||i==4
        continue % skip the third and the forth
    end

    for ii = 1:length(conditions)
        %计数君：如果不是sham,那就是150个trial；如果是sham，那就是50个trial
        t=t+1;

        IAF_pre_2 (t) = PAF_results(1,i);
        IAF_post_2 (t) = PAF_results(3,i);
        
        condition_sequence_2(t) = block_sequence(i); 
        condition_recorded_2(t) = conditions(ii);
        participant_id_2(t)=i;
        intercept_hit (t) = all_int_hit(ii,i);
        amplitude_hit (t) = all_bs_hit(ii,i);
          
        intercept_RT (t) = all_int_RT(ii,i);
        amplitude_RT (t) = all_bs_RT(ii,i);     

        phi_hit(t) =  all_phi_hit(ii,i);
        phi_rt(t) =  all_phi_RT(ii,i);
     

     end
end
% input information into the table and save it
T = table();
T.SubjectCode = participant_id_2(:);
T.Condition     = condition_recorded_2(:);
T.Condition_seq = condition_sequence_2(:);

T.IAF_Pre       = IAF_pre_2(:);
T.IAF_Post      = IAF_post_2(:);

T.intercept_hit   = intercept_hit(:);
T.amplitude_hit   = amplitude_hit(:);

T.intercept_RT  = intercept_RT(:);
T.amplitude_RT = amplitude_RT(:);

T.phi_hit = phi_hit(:);
T.phi_rt = phi_rt(:);


writetable(T, 'regression_summary.csv');

%% Combining the Meat_data tables
% L18

if labnum<10
labnum = strcat('0',num2str(labnum));
else
labnum = num2str(labnum);
end

T = table();

for subnum = 1: length(subjs)

    if subnum==3||subnum==4
        continue % skip the third and the forth
    end


if subnum<10
subnum = strcat('0',num2str(subnum));
else
subnum = num2str(subnum);
end
% Prefix the file names
prefix = strcat('L',labnum,'_P',subnum);
prefix_S = strcat('L',labnum,'_S',subnum);

full_data_path = fullfile(data_path,prefix,strcat(prefix_S,'_Meta_Data.xlsx'));

T1 = readtable(full_data_path);
T = [T; T1];
end
writetable(T, 'Meta_summary.csv');

%% Aftereffects
% 
name_pre='_Pre_EC';
name_post = '_Post_EC';

t=0;

for sub_num=1:length(subjs)
    if i==3||i==4
        continue % skip the third and the forth
    end

    t=t+1;

    subnum = sub_num;
    if subnum<10
        subnum = strcat('0',num2str(subnum));
    else
        subnum = num2str(subnum);
    end

   prefix_S = strcat('L',labnum,'_S',subnum);
   load(fullfile('EEG_preprocessed',strcat(prefix_S,name_pre,'.mat')));
   EEG_pre = EEG.data;
   fs_pre = EEG.srate;
   load(fullfile('EEG_preprocessed',strcat(prefix_S,name_post,'.mat')));
   EEG_post = EEG.data;
   fs_post = EEG.srate;
     
   if ~isnan(PAF_results(1,sub_num))&& ~isnan(PAF_results(3,sub_num))
   %pre
   power_10Hz (t,1) = find_power (EEG_pre,fs_pre,10);
   %post
   power_10Hz (t,2) = find_power (EEG_post,fs_pre,10);
   %pre
   power_iaf (t,1) = find_power (EEG_pre,fs_post,PAF_results(1,sub_num));
   %post
   power_iaf (t,2) = find_power (EEG_post,fs_post,PAF_results(3,sub_num));

   else
   
   power_10Hz (t,1) = nan;  
   power_10Hz (t,2) = nan;

   power_iaf (t,1) = nan;  
   power_iaf (t,2) = nan;  


   end

end

% compare the abosulte difference (10 Hz - IAF) between pre- and post- formal task------------------------------------------
row1 = abs(10-PAF_results(1, :));
row3 = abs(10-PAF_results(3, :));

valid_idx = ~isnan(row1) & ~isnan(row3);

[~, p, ci, stats] = ttest(row1(valid_idx), row3(valid_idx));


% 这是探究IAF之间有没有变化---------------------------------

row1 = PAF_results(1, :);row1(3:4)=[];
row3 = PAF_results(3, :);row3(3:4)=[];

valid_idx = ~isnan(row1) & ~isnan(row3);

[~, p2, ci2, stats2] = ttest(row1(valid_idx), row3(valid_idx));