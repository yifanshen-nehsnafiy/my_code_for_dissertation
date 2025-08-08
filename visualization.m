%visualization (not finished)


%% 图1

tbl_trial_summary = readtable('trial_summary.csv');
col2 = tbl_trial_summary{:, 2}; 
mapping = containers.Map({'A', 'B', 'C', 'Sh'}, [1, 2, 3, 4]);
numCol2 = zeros(size(col2));
for i = 1:length(col2)
    if isKey(mapping, col2{i})
        numCol2(i) = mapping(col2{i});
    else
        numCol2(i) = NaN; 
    end
end
tbl_trial_summary.Condition = numCol2; 

numericVars = varfun(@isnumeric, tbl_trial_summary, 'OutputFormat', 'uniform');

mat_trial_summary = table2array(tbl_trial_summary(:, [1,2,5,6,9]));

% 所有

ID=unique(mat_trial_summary(:,1));

trial_ID = mat_trial_summary(:,1);
phase_all = mat_trial_summary(:,5);
hit = mat_trial_summary(:,3);
rt = mat_trial_summary(:,4);
condition_trial = mat_trial_summary(:,2);

%% read the regression, so I can retrive the preferred phase
tbl_regression_summary = readtable ('regression_summary.csv');
col2 = tbl_regression_summary{:, 2}; 
mapping = containers.Map({'A', 'B', 'C', 'Sh'}, [1, 2, 3, 4]);
numCol2 = zeros(size(col2));
for i = 1:length(col2)
    if isKey(mapping, col2{i})
        numCol2(i) = mapping(col2{i});
    else
        numCol2(i) = NaN; 
    end
end
tbl_regression_summary.Condition = numCol2; 

mat_regression_summary = table2array(tbl_regression_summary(:,[1,2,4:11]));
regression_ID = mat_regression_summary(:,1);
regression_condition = mat_regression_summary(:,2);
IAF_pre= mat_regression_summary(:,3);
IAF_post= mat_regression_summary(:,4);
hit_intercept = mat_regression_summary(:,5);
hit_amplitude = (mat_regression_summary(:,6)); 
rt_intercept = mat_regression_summary(:,7);
rt_amplitude = (mat_regression_summary(:,8)); 
phi_hit = mat_regression_summary(:,9); 
phi_rt = mat_regression_summary(:,10); 



%% for iteration

bin_num=9; %分成11个bin

for subj = 1:20
    for condition = 1:3
    subj_trial_seq = find (trial_ID==ID(subj)&condition_trial==condition);

    subj_regression_seq = find (regression_ID==ID(subj)&regression_condition==condition);

    [avg_hit_every_bin(subj,condition,:),bin_center] = binning_phase(hit(subj_trial_seq),phase_all(subj_trial_seq),bin_num,phi_hit(subj_regression_seq));
    avg_rt_every_bin(subj,condition,:) = binning_phase(hit(subj_trial_seq),phase_all(subj_trial_seq),bin_num,phi_rt(subj_regression_seq),rt(subj_trial_seq));
    
    end
end

% group level: 平均和标准差
group_mean_hit = squeeze(mean(avg_hit_every_bin, 1));
group_ste_hit = squeeze(std(avg_hit_every_bin, 0, 1))/sqrt(20);

group_mean_rt = squeeze(mean(avg_rt_every_bin, 1));
group_ste_rt = squeeze(std(avg_rt_every_bin, 0, 1))/sqrt(20);

%% color 定义

colors = lines(3);  % 或者使用 [colorA; colorB; colorC] 自定义 RGB
colors2(1,:)= colors(2,:);
colors2(2,:)= colors(1,:);
colors2(3,:)= colors(3,:);

colors = colors2;



% for i=1:3
% figure
% errorbar(bin_center, group_mean_hit(i,:), group_ste_hit(i,:), 'o-', 'LineWidth', 1.5, 'MarkerSize', 6);
% 
% ylim([0.45,0.6]);
% end

% for i=1:20
% hold on
% plot(bin_center, squeeze(avg_hit_every_bin(i,1,:)), 'o-', 'LineWidth', 1.5, 'MarkerSize', 6);
% end

figure;
hold on;
for i = 1:3
    plot(bin_center, group_mean_hit(i,:), 'o-', ...
        'LineWidth', 2, ...
        'MarkerSize', 8, ...
        'Color', colors(i,:), ...
        'MarkerFaceColor', colors(i,:));
end

xlabel('Phase Bin Center (rad)', 'FontSize', 14, 'FontWeight', 'bold');
ylabel('Mean Hit Rate', 'FontSize', 14, 'FontWeight', 'bold');

set(gca, 'FontSize', 16, 'LineWidth', 1.5, 'Box', 'off');
phi_hit2 = 0;  % 举例
yl = ylim;
y_target = yl(1) + (yl(2) - yl(1)) * 1.1;
plot([phi_hit2, phi_hit2], yl, 'k--', 'LineWidth', 1.5);  % 竖线
text(phi_hit2, y_target, 'Preferred Phase', ...
     'HorizontalAlignment', 'center', ...
     'VerticalAlignment', 'top', ...
     'FontSize', 16, 'FontWeight', 'bold');

xlim([-pi,pi]);
xticks([-pi:pi/2:pi])
yticks([0:0.02:1])
xticklabels({'-π', '-π/2', '0', 'π/2', 'π'});
set(gcf,'Color',[1 1 1])  
set(gcf, 'Position', [100, 100, 700, 500]);
set(gca, 'LineWidth', 2);  % 加粗坐标轴边框线

% 
% legend({'Occipital', 'Retinal', 'Cutaneous'}, ...
%        'Location', 'best', 'FontSize', 12);

saveas(gcf,"figures\figre_reslt1a","pdf")

%-------------------下面的图----------------------------------------------------------------------------------------
figure;
hold on;
for i = 1:3
    plot(bin_center, group_mean_rt(i,:), 'o-', ...
        'LineWidth', 2, ...
        'MarkerSize', 8, ...
        'Color', colors(i,:), ...
        'MarkerFaceColor', colors(i,:));
end

xlabel('Phase Bin Center (rad)', 'FontSize', 14, 'FontWeight', 'bold');
ylabel('Mean Reaction Time (ms)', 'FontSize', 14, 'FontWeight', 'bold');

set(gca, 'FontSize', 16, 'LineWidth', 1.5, 'Box', 'off');
phi_hit2 = 0;  % 举例
yl = ylim;
y_target = yl(1) + (yl(2) - yl(1)) * 1.1;
plot([phi_hit2, phi_hit2], yl, 'k--', 'LineWidth', 1.5);  % 竖线
text(phi_hit2, y_target, 'Preferred Phase', ...
     'HorizontalAlignment', 'center', ...
     'VerticalAlignment', 'top', ...
     'FontSize', 16, 'FontWeight', 'bold');

xlim([-pi,pi]);
xticks([-pi:pi/2:pi])
yticks([0:20:3000])
xticklabels({'-π', '-π/2', '0', 'π/2', 'π'});
set(gcf,'Color',[1 1 1])  

set(gcf, 'Position', [100, 100, 700, 500]);
set(gca, 'LineWidth', 2);  % 加粗坐标轴边框线

% legend({'Occipital', 'Retinal', 'Cutaneous'}, ...
%        'Location', 'best', 'FontSize', 12);

saveas(gcf,"figures\figre_reslt1b","pdf")


%% 图2

figure;
hold on;

labels = {'Occipital', 'Retinal', 'Cutaneous'};  % 对应 condition 1~3

for i = 1:length(phi_hit)
    x = phi_hit(i);
    y = hit_amplitude(i);
    condition = regression_condition(i);

    if condition == 4
        continue  % 跳过 condition == 4
    end

    % 用颜色画竖线（modulation amplitude）
    plot([x x], [0 y], '-', ...
        'LineWidth', 2, ...
        'Color', colors(condition, :));
end

% 坐标轴标签
xlabel('Preferred Phase (rad)', 'FontSize', 14, 'FontWeight', 'bold');
ylabel('Modulation Amplitude (Log Odds of Hit)', 'FontSize', 14, 'FontWeight', 'bold');

% 设置坐标轴、刻度、外观
set(gca, 'FontSize', 16, 'LineWidth', 1.5, 'Box', 'off');
xlim([-pi, pi]);
ylim([0 max(hit_amplitude)*1.1]);

% 设置x轴刻度为π格式
xticks([-pi, -pi/2, 0, pi/2, pi]);
xticklabels({'-π', '-π/2', '0', 'π/2', 'π'});

% 背景白色、窗口大小
set(gcf, 'Color', [1 1 1]);
set(gcf, 'Position', [100, 100, 700, 500]);
set(gca, 'LineWidth', 2);  % 加粗坐标轴边框线

% 图例（只画一次就好，用 patch 模拟图例）
for i = 1:3
    h(i) = plot(nan, nan, '-', ...
        'LineWidth', 2, ...
        'Color', colors(i,:));
end

ylim ([0,0.5]);

% legend(h, labels, 'Location', 'best', 'FontSize', 12);

saveas(gcf,"figures\figre_reslt1c","pdf")


%% -------------


figure;
hold on;

labels = {'Occipital', 'Retinal', 'Cutaneous'};  % 对应 condition 1~3

for i = 1:length(phi_rt)
    x = phi_rt(i);
    y = rt_amplitude(i);
    condition = regression_condition(i);

    if condition == 4
        continue  % 跳过 condition == 4
    end

    % 用颜色画竖线（modulation amplitude）
    plot([x x], [0 y], '-', ...
        'LineWidth', 2, ...
        'Color', colors(condition, :));
end

% 坐标轴标签
xlabel('Preferred Phase (rad)', 'FontSize', 14, 'FontWeight', 'bold');
ylabel('Modulation Amplitude (RT, ms)', 'FontSize', 14, 'FontWeight', 'bold');

% 设置坐标轴、刻度、外观
set(gca, 'FontSize', 16, 'LineWidth', 1.5, 'Box', 'off');
xlim([-pi, pi]);
ylim([0 max(rt_amplitude)*1.1]);

% 设置x轴刻度为π格式
xticks([-pi, -pi/2, 0, pi/2, pi]);
xticklabels({'-π', '-π/2', '0', 'π/2', 'π'});

% 背景白色、窗口大小
set(gcf, 'Color', [1 1 1]);
set(gcf, 'Position', [100, 100, 700, 500]);
set(gca, 'LineWidth', 2);  % 加粗坐标轴边框线

% 图例（只画一次就好，用 patch 模拟图例）
% for i = 1:3
%     h(i) = plot(nan, nan, '-', ...
%         'LineWidth', 2, ...
%         'Color', colors(i,:));
% end

% legend(h, labels, 'Location', 'best', 'FontSize', 12);

saveas(gcf,"figures\figre_reslt1d","pdf")

%% 下面一张图，是说明散点之间的关系

%% 
figure;
hold on;
for condition = 1:3
    idx = regression_condition == condition;
    
    % 获取当前条件的数据
    x = abs(10 - IAF_pre(idx));
    y = hit_amplitude(idx);
    valid_idx = isnan(x);
    x(valid_idx) = zeros(1,sum(valid_idx));
    coeffs = polyfit(x, y, 1);
         
        
    x =IAF_pre(idx) ;    
    x =IAF_pre(idx) ;   
    valid_idx = isnan(x);
    x(valid_idx) = ones(1,sum(valid_idx))*10;
    x_new_fit_1 = linspace(min(x),10, 100);  
    x_new_fit_2 = linspace(10, max(x), 100);  
    
        for i=1:length(x_new_fit_1)
              y_fit_1(i)= coeffs(1)*abs(10-x_new_fit_1(i))+coeffs(2);
        end

        for i = 1:length(x_new_fit_2)
              y_fit_2(i)= coeffs(1)*abs(10-x_new_fit_2(i))+coeffs(2);
        end
       
        scatter(x, y, 50, 'filled', ...
        'MarkerFaceColor', colors(condition,:), ...
        'MarkerEdgeColor', colors(condition,:), ...
        'DisplayName', sprintf('Condition %d', condition));

        plot(x_new_fit_1, y_fit_1, '-', 'Color', colors(condition,:), ...
             'LineWidth', 2, 'HandleVisibility', 'off');

        plot(x_new_fit_2, y_fit_2, '-', 'Color', colors(condition,:), ...
             'LineWidth', 2, 'HandleVisibility', 'off');

end

% 美化
xlabel('IAF (Hz)', 'FontSize', 14, 'FontWeight', 'bold');

ylabel('Modulation Amplitude (Log Odds of Hit)', 'FontSize', 14, 'FontWeight', 'bold');
set(gca, 'FontSize', 16, 'LineWidth', 1.5, 'Box', 'off');
set(gcf, 'Color', [1 1 1], 'Position', [100, 100, 800, 600]);


set(gcf, 'Color', [1 1 1]);
set(gcf, 'Position', [100, 100, 700, 500]);
set(gca, 'LineWidth', 2);  % 加粗坐标轴边框线
% 图例（只画一次就好，用 patch 模拟图例）
for i = 1:3
    h(i) = plot(nan, nan, '-', ...
        'LineWidth', 2, ...
        'Color', colors(i,:));
end

% 获取 y 轴最大值，用于定位标签位置
yl = ylim;
plot([10, 10], yl, 'k--', 'LineWidth', 1.5);  % 竖线
y_target = yl(1) + (yl(2) - yl(1)) * 1.1;
% 添加“10 Hz”垂直标签
text(10, y_target, '10Hz', ...
     'HorizontalAlignment', 'center', ...
     'VerticalAlignment', 'top', ...
     'FontSize', 16, 'FontWeight', 'bold');

% 
% legend({'Occipital', 'Retinal', 'Cutaneous'}, ...
%        'Location', 'best', 'FontSize', 26);


saveas(gcf,"figures\figre_reslt2a","pdf")

%% 散点图 (between IAF and hitrate)
figure;
hold on;
for condition = 1:3
    idx = regression_condition == condition;
    
    % 获取当前条件的数据
    x = abs(10 - IAF_pre(idx));
    y = rt_amplitude(idx);
    valid_idx = isnan(x);
    x(valid_idx) = zeros(1,sum(valid_idx));
    coeffs = polyfit(x, y, 1);
         
        
    x =IAF_pre(idx) ;   
     valid_idx = isnan(x);
    x(valid_idx) = ones(1,sum(valid_idx))*10;
    x_new_fit_1 = linspace(min(x),10, 100);  
    x_new_fit_2 = linspace(10, max(x), 100);  
    
         for i=1:length(x_new_fit_1)
              y_fit_1(i)= coeffs(1)*abs(10-x_new_fit_1(i))+coeffs(2);
        end

        for i = 1:length(x_new_fit_2)
              y_fit_2(i)= coeffs(1)*abs(10-x_new_fit_2(i))+coeffs(2);
        end
       
         scatter(x, y, 50, 'filled', ...
        'MarkerFaceColor', colors(condition,:), ...
        'MarkerEdgeColor', colors(condition,:), ...
        'DisplayName', sprintf('Condition %d', condition));

        plot(x_new_fit_1, y_fit_1, '-', 'Color', colors(condition,:), ...
             'LineWidth', 2, 'HandleVisibility', 'off');

        plot(x_new_fit_2, y_fit_2, '-', 'Color', colors(condition,:), ...
             'LineWidth', 2, 'HandleVisibility', 'off');

end

% 美化
xlabel('IAF (Hz)', 'FontSize', 14, 'FontWeight', 'bold');

ylabel('Modulation Amplitude (RT, ms)', 'FontSize', 14, 'FontWeight', 'bold');
set(gca, 'FontSize', 16, 'LineWidth', 1.5, 'Box', 'off');
set(gcf, 'Color', [1 1 1], 'Position', [100, 100, 800, 600]);


set(gcf, 'Color', [1 1 1]);
set(gcf, 'Position', [100, 100, 700, 500]);
set(gca, 'LineWidth', 2);  % 加粗坐标轴边框线


yl = ylim;
plot([10, 10], yl, 'k--', 'LineWidth', 1.5);  % 竖线
y_target = yl(1) + (yl(2) - yl(1)) * 1.1;
% 添加“10 Hz”垂直标签
text(10, y_target, '10Hz', ...
     'HorizontalAlignment', 'center', ...
     'VerticalAlignment', 'top', ...
     'FontSize', 16, 'FontWeight', 'bold');


% legend({'Occipital', 'Retinal', 'Cutaneous'}, ...
%        'Location', 'best', 'FontSize', 12);

saveas(gcf,"figures\figre_reslt2b","pdf")

%%

figure;
hold on;
for condition = 1:3
    idx = regression_condition == condition;
    
    x = IAF_pre(idx);
    valid_idx = isnan(x);
    x(valid_idx) = ones(1,sum(valid_idx))*10;
    x_fit = linspace(min(x), max(x), 100);
  
    y = hit_intercept(idx);
    % 绘制散点图

    
    % 拟合线性回归并绘图
    if length(x) > 1
        coeffs = polyfit(x, y, 1);
        x_fit = linspace(min(x), max(x), 100);
        y_fit = polyval(coeffs, x_fit);
    end

    scatter(x, y, 50, 'filled', ...
        'MarkerFaceColor', colors(condition,:), ...
        'MarkerEdgeColor', colors(condition,:), ...
        'DisplayName', sprintf('Condition %d', condition));
   
    plot(x_fit, y_fit, '-', 'Color', colors(condition,:), ...
             'LineWidth', 2, 'HandleVisibility', 'off');
end

% 美化
xlabel('IAF (Hz)', 'FontSize', 16, 'FontWeight', 'bold');

ylabel('General Performance Level (Log Odds of Hit)', 'FontSize', 14, 'FontWeight', 'bold');
set(gca, 'FontSize', 16, 'LineWidth', 1.5, 'Box', 'off');
set(gcf, 'Color', [1 1 1], 'Position', [100, 100, 800, 600]);


set(gcf, 'Color', [1 1 1]);
set(gcf, 'Position', [100, 100, 700, 500]);
set(gca, 'LineWidth', 2);  % 加粗坐标轴边框线
yl = ylim;
plot([10, 10], yl, 'k--', 'LineWidth', 1.5);  % 竖线
y_target = yl(1) + (yl(2) - yl(1)) * 1.1;

% 添加“10 Hz”垂直标签
text(10, y_target, '10Hz', ...
     'HorizontalAlignment', 'center', ...
     'VerticalAlignment', 'top', ...
     'FontSize', 16, 'FontWeight', 'bold');


% legend({'Occipital', 'Retinal', 'Cutaneous'}, ...
%        'Location', 'best', 'FontSize', 12);

saveas(gcf,"figures\figre_reslt2c","pdf")

%% 

figure;
hold on;
for condition = 1:3
    idx = regression_condition == condition;
    
    %
    x = IAF_pre(idx);
     valid_idx = isnan(x);
    x(valid_idx) = ones(1,sum(valid_idx))*10;  
    
        y = rt_intercept(idx);

    % 绘制散点图

    
    % 拟合线性回归并绘图
    if length(x) > 1
        coeffs = polyfit(x, y, 1);
        x_fit = linspace(min(x), max(x), 100);
        y_fit = polyval(coeffs, x_fit);
    end
     


    scatter(x, y, 50, 'filled', ...
        'MarkerFaceColor', colors(condition,:), ...
        'MarkerEdgeColor', colors(condition,:), ...
        'DisplayName', sprintf('Condition %d', condition));
   
    plot(x_fit, y_fit, '-', 'Color', colors(condition,:), ...
             'LineWidth', 2, 'HandleVisibility', 'off');
end

% 美化
xlabel('IAF (Hz)', 'FontSize', 16, 'FontWeight', 'bold');

ylabel('General Performance Level (RT, ms)', 'FontSize', 14, 'FontWeight', 'bold');
set(gca, 'FontSize', 16, 'LineWidth', 1.5, 'Box', 'off');
set(gcf, 'Color', [1 1 1], 'Position', [100, 100, 800, 600]);


set(gcf, 'Color', [1 1 1]);
set(gcf, 'Position', [100, 100, 700, 500]);
set(gca, 'LineWidth', 2);  % 加粗坐标轴边框线

yl = ylim;
plot([10, 10], yl, 'k--', 'LineWidth', 1.5);  % 竖线
y_target = yl(1) + (yl(2) - yl(1)) * 1.1;
% 添加“10 Hz”垂直标签
text(10, y_target, '10Hz', ...
     'HorizontalAlignment', 'center', ...
     'VerticalAlignment', 'top', ...
     'FontSize', 16, 'FontWeight', 'bold');


% legend({'Occipital', 'Retinal', 'Cutaneous'}, ...
%        'Location', 'best', 'FontSize', 12);

saveas(gcf,"figures\figre_reslt2d","pdf")

%% IAF的例子画图
figure

% 阴影区域 7–13 Hz（放在最底层）
fill([7 13 13 7], [0 0 max(PSD_results(1,:,2))*1.1 max(PSD_results(1,:,2))*1.1], ...
     [0.9 0.9 0.9], 'EdgeColor', 'none');  % 灰色阴影
hold on;

% 绘制 PSD 曲线
plot(f, PSD_results(1,:,2), 'b-', 'LineWidth', 1.5,'Color', [0.2 0.6 0.8]);


% 添加轴标签
xlabel('Frequency (Hz)', 'FontSize', 14);
ylabel('Power Spectral Density (μV²/Hz)', 'FontSize', 14);

% 美化图形
grid on;
box off;
set(gca, 'FontSize', 16);

% 添加虚线表示 PAF（Individual Alpha Frequency）

% 可选：设置频率范围和 y 轴范围
xlim([min(f), max(f)]);
ylim([0, max(PSD_results(1,:,2)) * 1.1]);

yl = ylim;
plot([PAF_results(1,2),PAF_results(1,2)],yl, 'k--', 'LineWidth', 1.5);
y_target = yl(1) + (yl(2) - yl(1)) * 1.1;

text(PAF_results(1,2), y_target, 'IAF', ...
     'HorizontalAlignment', 'center', ...
     'VerticalAlignment', 'top', ...
     'FontSize', 16, 'FontWeight', 'bold');

set(gcf, 'Color', [1 1 1]);
set(gcf, 'Position', [100, 100, 700, 500]);
set(gca, 'LineWidth', 2);  % 加粗坐标轴边框线

grid off;

saveas(gcf,"figures\IAF_example","pdf")
