%% Xi'Dian二维MPI设备仿真
clear
clc;
close all;
%% 生成仿体
volume_size = 1e-3;
size_x = 0.025;      % 定义FOV 及体素大小
size_y = 0.025;
range_x = -size_x:volume_size:size_x;       
range_y = -size_y:volume_size:size_y;
[X, Y] = meshgrid(range_x, -range_y);

Map = zeros(200,200);
Map(95:105,95:105) = 4;
Map = mat2gray(Map);
ConcentrationMap = imresize(Map,size(X)); % 图片缩放到与可视区范围相同
Phantom = cast(ConcentrationMap,'double'); % 类型转换

%% 参数设置
DC_ratio = 0;     % 激励向 直流分量占交流幅值比
particle_diameters = 25e-9;
sample_rate = 2e6;      % 采样率
Drive_Amp = 16;     % 驱动场幅值 mT
Excited_Amp = 10;      % 激励场幅值
Drive_x_fre = 500;        % 单位 Hz  这里设置为10 和 500 是因为 1 和 50 的时候内存不够
Drive_y_fre = 10;       % 单位 Hz
Excited_fre = 25e3;         % 单位 Hz
Gradient_x = 1.39e3;      % mT/m
%% 信号生成 模拟真实采集的数据， 接收信号、激励电流、驱动场电流
[signal_x, signal_y, Excited_x, Drive_x, Drive_y] = calculate_signal(DC_ratio, Phantom, Excited_Amp, Excited_fre, Drive_Amp, Drive_x_fre, Drive_y_fre,Gradient_x, sample_rate, particle_diameters, X, Y);
%% 信号处理 目的：获取扫描过程中三次谐波的幅度值 处理方式：选取若干个相连的激励周期做傅里叶变换，作为此处三次谐波响应的幅度值
signal_x = signal_x*1e6;
point_number = floor(sample_rate/Excited_fre);      % 计算一个激励周期内的频点
period_number = 1;      % period_number个周期算一次谐波幅值
fre_index = 3;
signal_fre_x = Period_signal_processing(signal_x, point_number, period_number, fre_index);    % 获取扫描时间上n次谐波幅值
strength_result_x = sig2strength(signal_fre_x, Drive_x, Drive_y, point_number*period_number, 40);

signal_fre_y = Period_signal_processing(signal_y, point_number, period_number, fre_index);    % 获取扫描时间上n次谐波幅值
strength_result_y = sig2strength(signal_fre_y, Drive_x, Drive_y, point_number*period_number, 40);
fre_amp = signal_fft(signal_x,length(signal_x));
figure(1)
plot(abs(fre_amp))
%%
conv_kernel = ones(3,3);
conv_kernel(2,2) = 2;
strength_result_x = conv2(strength_result_x,conv_kernel,'same');
%% 绘图
figure(2)
imshow(abs(strength_result_x),[],InitialMagnification='fit');
title("x向激励x接收，3次谐波强度图像",FontSize=15);
colormap('parula');
colorbar()

figure(3)
imshow(real(strength_result_y),[],InitialMagnification='fit');
title("x向激励y接收，3次谐波强度图像",FontSize=15);
colormap('parula');
colorbar()

figure(4)
plot(real(strength_result_x(19,:)));