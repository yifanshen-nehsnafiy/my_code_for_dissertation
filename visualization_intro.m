
%---第一张图：所有的图

x=-pi:pi/100:pi;
y=sin(x-1.2*pi)+cos(x-1.2*pi);
t=0;

main_y = sin(x-1.2*pi) + cos(x-1.2*pi);
std_dev = 0.3;
upper = main_y + 1.96 * std_dev;
lower = main_y - 1.96 * std_dev;


%----------------画第二张图---------------------------------------------------------

%% 第一张图
x=-pi:pi/100:pi;
y=sin(x-1.2*pi)+cos(x-1.2*pi);
t=0;


main_y = sin(x-1.2*pi) + cos(x-1.2*pi);
std_dev = 0.3;
upper = main_y + 1.96 * std_dev;
lower = main_y - 1.96 * std_dev;

figure
hold on
line([-pi, pi], [0, 0], 'Color', 'k', 'LineWidth', 1.5,'HandleVisibility', 'off'); 

plot(x,y,"LineWidth",3,"Color",colors(1,:))

fill([x, fliplr(x)], [upper, fliplr(lower)], colors(1,:), 'EdgeColor', 'none', 'FaceAlpha', 0.3);


xlabel("Stimulation Phase (rad)", 'FontSize', 16);
ylabel('Visual Performance (↑Hit Rate,↓RT)', 'FontSize', 16);

xticks([-pi:pi/2:pi])
xticklabels({'-π', '-π/2', '0', 'π/2', 'π'})

init_guess = [1, 0];

xlim([-pi,pi]);

set(gca, 'YTick', []);      
set(gca, 'YTickLabel', []); 

set(gcf, 'Position', [100, 100, 700, 500]);

set(gcf, 'Color', 'w');       % 设置白色背景
box off;                      % 移除外框
set(gca, 'FontSize', 16);    
set(gca, 'LineWidth', 2);  % 加粗坐标轴边框线

saveas(gcf,"figures\fig1_real","pdf")

%%

x=-pi:pi/100:pi;
y=sin(x-1.2*pi)+cos(x-1.2*pi);
t=0;

main_y = sin(x-1.2*pi) + cos(x-1.2*pi);
std_dev = 0.3;
upper = main_y + 1.96 * std_dev;
lower = main_y - 1.96 * std_dev;



%% 第一张图 

colors = lines(3);  % 或者使用 [colorA; colorB; colorC] 自定义 RGB
colors2(1,:)= colors(2,:);
colors2(2,:)= colors(1,:);
colors2(3,:)= colors(3,:);
colors = colors2;


x = -pi:pi/500:pi;
main_y = sin(x-1.2*pi) + cos(x-1.2*pi);
std_dev = 0.2;
upper = main_y + 1.96 * std_dev;
lower = main_y - 1.96 * std_dev;

figure;
hold on;

line([-pi, pi], [0, 0], 'Color', 'k', 'LineWidth', 1.5,'HandleVisibility', 'off'); % 黑色实线表示 x 轴

% 阴影部分 - tACS (主曲线)
fill([x, fliplr(x)], [upper, fliplr(lower)], colors(1,:), 'EdgeColor', 'none', 'FaceAlpha', 0.3);
main_plot = plot(x, main_y, 'Color', colors(1,:), 'LineWidth', 2); 

% 阴影和偏移曲线 - retinal (略小振幅 + pi/6 偏移)
y_retinal = 0.2 * (sin(x -1.2*pi+ pi/6) + cos(x -1.2*pi + pi/6));
upper_r = y_retinal + 1.96 * std_dev;
lower_r = y_retinal - 1.96 * std_dev;
fill([x, fliplr(x)], [upper_r, fliplr(lower_r)], colors(2,:), 'EdgeColor', 'none', 'FaceAlpha', 0.3);
retinal_plot = plot(x, y_retinal, 'Color', colors(2,:), 'LineWidth', 2);

% 阴影和偏移曲线 - cutaneous (更小振幅 - pi/3 偏移)
y_cutaneous = 0.21 * (sin(x -1.2*pi- pi/5) + cos(x-1.2*pi - pi/5));
upper_c = y_cutaneous + 1.96 * std_dev;
lower_c = y_cutaneous - 1.96 * std_dev;
fill([x, fliplr(x)], [upper_c, fliplr(lower_c)], colors(3,:), 'EdgeColor', 'none', 'FaceAlpha', 0.3);
cutaneous_plot = plot(x, y_cutaneous, 'Color', colors(3,:), 'LineWidth', 2);


xticks([-pi:pi/2:pi]);
xticklabels({'-π', '-π/2', '0', 'π/2', 'π'})

% title('Stimulation Response Across Modalities', 'FontSize', 16);  % 更大的标题字体
xlabel('Stimulation Phase (rad)', 'FontSize', 16);
ylabel('Visual Performance (↑Hit Rate,↓RT)', 'FontSize', 16);


set(gcf, 'Color', 'w');       % 设置白色背景
box off;                      % 移除外框
set(gca, 'FontSize', 16);    


legend([main_plot, retinal_plot, cutaneous_plot], ...
       {'Occipital Stim', 'Retinal Stim', 'Cutaneous Stim'}, ...
       'Location', 'eastoutside', ...
       'FontSize', 16); 
xlim([-pi,pi]);
set(gcf, 'Position', [100, 100, 900, 500]);

set(gca, 'YTick', []);      
set(gca, 'YTickLabel', []); 
set(gca, 'LineWidth', 2);  % 加粗坐标轴边框线

saveas(gcf,"figures\fig_amplitude_between_conditions","pdf")

%% ------------------------------第二张图-------------------------------------------------------

x = -pi:pi/500:pi;
main_y = sin(x-1.2*pi) + cos(x-1.2*pi);
std_dev = 0.2;
upper = main_y + 1.96 * std_dev;
lower = main_y - 1.96 * std_dev;


figure;
hold on;

line([-pi, pi], [0, 0], 'Color', 'k', 'LineWidth', 1.5,'HandleVisibility', 'off'); % 黑色实线表示 x 轴


% 阴影部分 - tACS (主曲线)
fill([x, fliplr(x)], [upper, fliplr(lower)], colors(1,:), 'EdgeColor', 'none', 'FaceAlpha', 0.3);
main_plot = plot(x, main_y, 'Color', colors(1,:), 'LineWidth', 2); 

% 阴影和偏移曲线 - retinal (略小振幅 + pi/6 偏移)
y_retinal = 1 * (sin(x -1.2*pi+ pi/2+0.5*pi) + cos(x -1.2*pi + pi/2 +0.5*pi));
upper_r = y_retinal + 1.96 * std_dev;
lower_r = y_retinal - 1.96 * std_dev;
fill([x, fliplr(x)], [upper_r, fliplr(lower_r)], colors(2,:), 'EdgeColor', 'none', 'FaceAlpha', 0.3);
retinal_plot = plot(x, y_retinal,'Color',colors(2,:), 'LineWidth', 2);

% 阴影和偏移曲线 - cutaneous (更小振幅 - pi/3 偏移)
y_cutaneous = 1 * (sin(x -1.2*pi + 2*pi/3+0.5*pi) + cos(x -1.2*pi+ 2*pi/3+0.5*pi));
upper_c = y_cutaneous + 1.96 * std_dev;
lower_c = y_cutaneous - 1.96 * std_dev;
fill([x, fliplr(x)], [upper_c, fliplr(lower_c)], colors(3,:), 'EdgeColor', 'none', 'FaceAlpha', 0.3);
cutaneous_plot = plot(x, y_cutaneous, 'Color', colors(3,:), 'LineWidth', 2);

% 图形设置
set(gcf, 'Color', 'w');       % 设置白色背景
box off;                      % 移除外框
set(gca, 'FontSize', 16);     % 坐标轴字体调大

xticks([-pi:pi/2:pi]);
xticklabels({'-π', '-π/2', '0', 'π/2', 'π'})

% title('Stimulation Response Across Modalities', 'FontSize', 16);  % 更大的标题字体
xlabel('Stimulation Phase (rad)', 'FontSize', 16);
ylabel('Visual Performance (↑Hit Rate,↓RT)', 'FontSize', 16);

% legend([main_plot, retinal_plot, cutaneous_plot], ...
%        {'Occipital Stim', 'Retinal Stim', 'Cutaneous Stim'}, ...
%        'Location', 'eastoutside', ...
%        'FontSize', 10); 
xlim([-pi,pi]);


% 计算每条曲线的最大值及其对应的 x 坐标
[~, idx_main] = max(main_y);
[~, idx_retinal] = max(y_retinal);
[~, idx_cutaneous] = max(y_cutaneous);

% 添加垂直虚线：从最高点垂直到 x 轴
line([x(idx_main), x(idx_main)], [0, main_y(idx_main)], 'Color', colors(1,:), 'LineStyle', '--', 'LineWidth', 1.5, 'HandleVisibility', 'off');
line([x(idx_retinal), x(idx_retinal)], [0, y_retinal(idx_retinal)], 'Color', colors(2,:), 'LineStyle', '--', 'LineWidth', 1.5, 'HandleVisibility', 'off');
line([x(idx_cutaneous), x(idx_cutaneous)], [0, y_cutaneous(idx_cutaneous)], 'Color',colors(3,:), 'LineStyle', '--', 'LineWidth', 1.5, 'HandleVisibility', 'off');
set(gca, 'YTick', []);      
set(gca, 'YTickLabel', []); 
set(gcf, 'Position', [100, 100, 700, 500]);
set(gca, 'LineWidth', 2);  % 加粗坐标轴边框线

saveas(gcf,"figures\fig_phi_between_conditions","pdf")


%% 只是选择+IAF - IAF IAF
nColors = 5;  % 渐变色数量
red = lines(3); red = red(2,:);  % 取 lines(3) 里的红色（第二个是红）
colors = zeros(nColors, 3);
maxT = 0.8;  % 最淡不超过 0.8，让最后一个颜色不是纯白
for i = 1:nColors
    t = maxT * (i-1)/(nColors-1);  % 插值范围 [0, 0.8]
    colors(i,:) = (1 - t) * red + t * [1 1 1];
end

% x轴从 -pi 到 pi
x = linspace(-pi, pi, 500);

% 创建图形
figure;
hold on;

line([-pi, pi], [0, 0], 'Color', 'k', 'LineWidth', 1.5,'HandleVisibility', 'off'); % 黑色实线表示 x 轴

intercept =[-0.5,-0.25,0,0.25,0.5];
% labels = {'+ΔIAF', 'ΔIAF', '–ΔIAF'};  % 从上到下的标签

% 绘制五条不同幅度的 sin 曲线
for i = 1:5
    amplitude = 0.6; % 从1到0.2
    y = amplitude * sin(x) + intercept(i);
    plot(x, y, 'Color', colors(6-i,:), 'LineWidth', 2);

%     text(pi + 0.1, y(end), labels{i}, 'FontSize', 16, 'VerticalAlignment', 'middle');

end

% 设置图形属性
xlabel('Simulation Phase (rad)');
ylabel('Visual Performance (↑Hit Rate,↓RT)');
grid on;
ylim([-1.2,1.2]);
xlim([-pi,pi]);
xticks([-pi:pi/2:pi]);
xticklabels({'-π', '-π/2', '0', 'π/2', 'π'})
% 美化
% axis tight;
box off;

set(gcf, 'Color', 'w');       % 设置白色背景
set(gca, 'FontSize', 16);   

set(gca, 'YTick', []);      
set(gca, 'YTickLabel', []); 

set(gcf, 'Position', [100, 100, 700, 500]);

colormap(interp1(linspace(0, 1, size(colors, 1)), colors, linspace(0, 1, 256)));
cb = colorbar('eastoutside');
cb.Ticks = [0, 0.5,1];
cb.Box = 'on';            % 开启边框
cb.LineWidth = 2;         % 设置边框粗细（默认是 0.5）
cb.TickLabels = {'Positive', '10 Hz','Negative'};
cb.Label.String = 'Directional ΔIAF';
cb.Label.Position = [3, 0.5, 0]; 
cb.Label.Rotation = 90;
cb.Label.FontSize = 16;
cb.FontSize = 16;
cb.Direction = 'reverse';  % 倒过来
cb_axes = ancestor(cb, 'axes');  % 获取 colorbar 所在的 axes
set(cb_axes, 'Color', 'none');   % 设置为透明
set(gca, 'LineWidth', 2);  % 加粗坐标轴边框线


set(gcf, 'Position', [100, 100, 700, 500]);
saveas(gcf,"figures\fig_dir_iaf","pdf")




%% ---图4
%IAF

%第一步等会
nColors = 5;  % 渐变色数量
red = lines(3); red = red(2,:);  % 取 lines(3) 里的红色（第二个是红）
colors = zeros(nColors, 3);
maxT = 0.8;  % 最淡不超过 0.8，让最后一个颜色不是纯白
for i = 1:nColors
    t = maxT * (i-1)/(nColors-1);  % 插值范围 [0, 0.8]
    colors(i,:) = (1 - t) * red + t * [1 1 1];
end


% x轴从 -pi 到 pi
x = linspace(-pi, pi, 500);

% 创建图形
figure;
hold on;

line([-pi, pi], [0, 0], 'Color', 'k', 'LineWidth', 1.5,'HandleVisibility', 'off'); % 黑色实线表示 x 轴


% 绘制五条不同幅度的 sin 曲线
for i = 1:5
    amplitude = 1 - (i-1)*0.2; % 从1到0.2
    y = amplitude * sin(x);
    plot(x, y, 'Color', colors(6-i,:), 'LineWidth', 2);
end

% 设置图形属性
xlabel('Simulation Phase (rad)');
ylabel('Visual Performance (↑Hit Rate,↓RT)');
grid on;

xlim([-pi,pi]);
xticks([-pi:pi/2:pi]);
xticklabels({'-π', '-π/2', '0', 'π/2', 'π'})
% 美化
axis tight;
box off;

set(gcf, 'Color', 'w');       % 设置白色背景
set(gca, 'FontSize', 16);   

set(gca, 'YTick', []);      
set(gca, 'YTickLabel', []); 


colormap(interp1(linspace(0, 1, size(colors, 1)), colors, linspace(0, 1, 256)));
cb = colorbar('eastoutside');
cb.Ticks = [0, 1];
cb.Box = 'on';            % 开启边框
cb.LineWidth = 2;         % 设置边框粗细（默认是 0.5）cb.TickLabels = {'large', 'small'};
cb.Label.String = 'Absolute ΔIAF';
cb.Label.Rotation = 90;
cb.Label.FontSize = 16;
cb.FontSize = 16;
cb.TickLabels = {'Large','Small'};
cb.Direction = 'reverse';  % 倒过来
cb_axes = ancestor(cb, 'axes');  % 获取 colorbar 所在的 axes
set(cb_axes, 'Color', 'none');   % 设置为透明
cb.Label.Position = [3, 0.5, 0]; 

set(gcf, 'Position', [100, 100, 700, 500]);
set(gca, 'LineWidth', 2);  % 加粗坐标轴边框线

saveas(gcf,"figures\fig_abs_iaf","pdf")
