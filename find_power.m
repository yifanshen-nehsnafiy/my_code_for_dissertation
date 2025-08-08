function power=find_power(signal,fs,target_freq)


% 让 Δf = 0.01 Hz，这样频谱上就有 7.22、7.23 等频率点
delta_f = 0.0001;
Nfft = fs / delta_f;  

% 做 FFT（zero-padding 到 50000）
Y = fft(signal, Nfft);
P = abs(Y).^2;     % 功率谱
f = (0:Nfft-1)*(fs/Nfft);  % 频率轴（从0到Fs）

% 找到目标频率的索引
[~, idx] = min(abs(f - target_freq));  % 找到最接近的那个点
power = P(idx);