%% This is for IAF extracting


participant = "P03";
times = {'pre','post'};
name1 = {'L18_S03_Pre_EC.vhdr','L18_S03_Post_EC.vhdr'};

name2 = {'L18_Pilot02_eyeclosed.vhdr','L18_Pilot02_Post_eyeoclosed.vhdr'};

name3 = {'L18_Pilot01_eyeopen.vhdr','L18_Pilot1_eyeopen_post.vhdr'};

name4 = {'L18_Pilot02_eyeopened.vhdr','L18_Pilot02_Post_eyeopened.vhdr'};

name = name1;
condition = 'EC';

data_path = strcat(pwd,'\L18_',participant,'\');

%% 
eeglab nogui;

figure
hold on

for i=1:2

vhdr_file = name{i};

time = times{i};

%% 读取 .vhdr 文件
EEG = pop_loadbv(data_path, vhdr_file);

%% 可视化 EEG 数据

%% Preprocessing
EEG = pop_eegfiltnew(EEG, 1, 40);
EEG = pop_eegfiltnew(EEG, 49, 51, [], 1);  

%无需重参考 降采样
%% 分段
% 直接分段
% 假设采样率为 EEG.srate，计算每 1 秒对应的采样点数
epoch_length_sec = 1; % 1秒
epoch_samples = EEG.srate * epoch_length_sec;

% 计算可以插入多少个完整的 epoch
n_epochs = floor(EEG.pnts / epoch_samples);

% 生成伪事件
EEG.event = []; % 先清空原事件
for ii = 1:n_epochs
    EEG.event(ii).type = 'epoch_marker';
    EEG.event(ii).latency = (ii - 1) * epoch_samples + 1;
    EEG.event(ii).duration = 0;
end
EEG = eeg_checkset(EEG, 'eventconsistency');
EEG = pop_epoch(EEG, {'epoch_marker'}, [0 1]);  % 从 marker 起点往后 1 秒
EEG = eeg_checkset(EEG);

%%  自动选取坏段
% 设置电压阈值
threshold_high = 150;
threshold_low  = -150;

% 初始化 bad epoch 索引
bad_epochs = false(1, EEG.trials);  % EEG.trials 是 epoch 的数量

% 遍历每个 epoch
for iiii = 1:EEG.trials
    data = EEG.data(:, :, iiii);  % 当前 epoch 的数据 [channels x timepoints]
    
    if any(data(:) > threshold_high) || any(data(:) < threshold_low)
        bad_epochs(iiii) = true;  % 标记为坏 epoch
    end
end

% 保存这些坏 epoch 的编号（例如记录日志用）
%% 

% 分段后第一步去除坏段
pop_eegplot(EEG, 1, 1, 0);  % 手动标记坏段（会保存在 EEG.reject.rejmanual）
uiwait;

% 等待输入坏段
bad_epoches_mannual = inputdlg({'bad_epoches'});
bad_epochs_str = strsplit(bad_epoches_mannual{1}, ',');  
bad_epochs_num = str2double(bad_epochs_str);

if ~isnan(bad_epochs_num)
bad_epochs(bad_epochs_num) = true; 
end


%记录下来
EEG = pop_rejepoch(EEG, bad_epochs, 0);

bad_epoch_indices = find(bad_epochs);

% %进行删除
% EEG = pop_rejepoch(EEG, combined_reject, 0);
% keyboard;
% %% ICA (但是只有一个channal 做不了)
% %直接做ICA
% EEG = pop_runica(EEG, 'extended', 1, 'interupt','on');
% 
% % 可视化所有 ICA 成分
% pop_selectcomps(EEG, 1:size(EEG.icaweights, 1));  
% EEG.reject.gcompreject  % 一个逻辑数组，表示每个 ICA 成分是否被标记为要去除
% EEG = pop_subcomp(EEG, [], 0);  % 执行删除已标记的 ICA 成分
% 
% %% 第一次保存去除的ICA成分
% removed_ics = find(EEG.reject.gcompreject);  % 返回被标记为去除的 ICA 成分编号
save(strcat(pwd,'/preprocessing_Meta_data/',participant,'_',time,condition,'_regjected'), 'bad_epoch_indices');

%% 保存preprocessed的文件
save_path = strcat(pwd,'\EEG_preprocessed\');
save_name =strcat ('preprocessed','_',participant,'_',time);

EEG = eeg_epoch2continuous(EEG);
save(strcat(save_path,save_name,condition),"EEG");

[pSpec(1, i).sums, pSpec(1, i).chans, f] = restingIAF(double(EEG.data), 1, 1, [1, 40], 500,  [7 13], 11, 5);

save_name_IAF = strcat(save_name,'IAF_result');

% Draw IAF
save(save_name_IAF,'pSpec','f');

plotSpec(f, pSpec(1,i), 1, 1, 'pxx', 1)

end
legend(sprintf('%s %s', condition, 'Pre'), sprintf('%s %s', condition, 'Post'));

set(gcf,'Color',[1,1,1]);

title(strcat('IAF__', participant),'FontSize',20);


