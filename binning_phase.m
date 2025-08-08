function [avg_hit_every_bin, bin_center] = binning_phase(var, phase, bin_num, phi,rt)

% 确保 phase 和 var 是列向量
if nargin<5
var = var(:);
phase = phase(:);
else
var = var(:);
phase = phase(:);
hit_trial = find(var==1);
var=rt(hit_trial);
phase = rt(hit_trial);
end

% 将 phase wrap 到 [-pi, pi]
phase = wrapToPi(phase);

% 创建 bin 的边界
bin_width = 2*pi / bin_num;
edges = -pi : bin_width : pi;

%phi

phase = mod (phase-phi+pi,2*pi)-pi;


bin_center_raw = edges(1:end-1) + bin_width/2;

% 对每个 bin 计算 var 的平均
avg_hit_every_bin_raw = zeros(1, bin_num);
for i = 1:bin_num
    idx = find(phase >= edges(i) & phase < edges(i+1));
    avg_hit_every_bin(i) = mean(var(idx));
end

bin_center = [bin_center_raw];

end