function Signal_Strength = Period_signal_processing(signal, point_number, period_number, Fre_index)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
signal_band_Length = point_number*period_number;        % 处理period_number个激励周期的信号
signal = signal(1:signal_band_Length*floor(length(signal)/signal_band_Length));     
signal_split = reshape(signal,signal_band_Length,[]);     % 每period_number个信号作为一组信号处理

signal_fre = fft(signal_split)/signal_band_Length;
% signal_fre = abs(signal_fre(1:signal_band_Length/2+1,:));
fs = 2e6;
excited_fre = 25e3;
fre_resolution = fs/(point_number * period_number);
fre_index = excited_fre*Fre_index/fre_resolution;
Signal_Strength= signal_fre(1+fre_index,:);        % 选择对应频率的幅值
end

