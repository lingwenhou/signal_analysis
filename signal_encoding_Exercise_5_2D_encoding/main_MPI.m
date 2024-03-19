%% 理解MPI使用
clear
clc;
close all;
%% 参数设置
particle_diameters = 35e-9;
sample_rate = 1e6;      % 采样率
Drive_Amp = 64;
Drive_x_fre = 3.3e3;
Drive_y_fre = 3.2e3;

Gradient_x = 0.139;
%% 信号生成
[signal_total_matric, signal_x_matric, signal_y_matric] = calculate_signal(sample_rate, Drive_Amp, particle_diameters,Gradient_x, Drive_x_fre, Drive_y_fre);

%% 傅里叶变换
% 总信号
out_fre_Amplitude_total_matric = zeros(size(signal_total_matric, 1), size(signal_total_matric, 2), size(signal_total_matric, 3)/2+1);
out_fre_Phase_total_matric = zeros(size(signal_total_matric, 1), size(signal_total_matric, 2), size(signal_total_matric, 3)/2+1);
% x轴向
out_fre_Amplitude_x_matric = zeros(size(signal_total_matric, 1), size(signal_total_matric, 2), size(signal_total_matric, 3)/2+1);
out_fre_Phase_x_matric = zeros(size(signal_total_matric, 1), size(signal_total_matric, 2), size(signal_total_matric, 3)/2+1);
% y轴向
out_fre_Amplitude_y_matric = zeros(size(signal_total_matric, 1), size(signal_total_matric, 2), size(signal_total_matric, 3)/2+1);
out_fre_Phase_y_matric = zeros(size(signal_total_matric, 1), size(signal_total_matric, 2), size(signal_total_matric, 3)/2+1);

% 傅里叶变换
f = sample_rate*(0:size(signal_total_matric, 3)/2)/size(signal_total_matric, 3);    % 频点

for i = 1:size(signal_total_matric,1)
    for j = 1:size(signal_total_matric,2)
        [out_fre_Amplitude_total_matric(i,j,:), out_fre_Phase_total_matric(i,j,:)] = signal_fft(signal_total_matric(i,j,:), size(signal_total_matric,3));
        [out_fre_Amplitude_x_matric(i,j,:), out_fre_Phase_x_matric(i,j,:)] = signal_fft(signal_x_matric(i,j,:), size(signal_x_matric,3));
        [out_fre_Amplitude_y_matric(i,j,:), out_fre_Phase_y_matric(i,j,:)] = signal_fft(signal_y_matric(i,j,:), size(signal_y_matric,3));
    end
end
%% 

figure(1)
for index_show_x = 1:8
    for index_show_y = 1:8
        
        if index_show_x == 1 && (index_show_y == 1)
            continue;
        else
            sum_xy = find(ismember(f, (index_show_y-1)*Drive_y_fre+(index_show_x-1)*Drive_x_fre));
            subplot(16, 8, (index_show_y-1)*16+index_show_x);
            imshow(abs(out_fre_Amplitude_x_matric(:,:,sum_xy)),[]);
            subplot(16, 8, (index_show_y-1)*16+index_show_x + 8);
            imshow(abs(out_fre_Amplitude_y_matric(:,:,sum_xy)),[]);  
        end 
        hold on;
    end
end



