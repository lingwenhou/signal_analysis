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
% 点状仿体
Map = zeros(100,100);
Map(48:52,48:52) = 4;
Map = mat2gray(Map);
ConcentrationMap = imresize(Map,size(X)); % 图片缩放到与可视区范围相同
Phantom = cast(ConcentrationMap,'double'); % 类型转换

% 条状仿体
% Map = zeros(100, 100);
% Map(30:60, 40:50) = 4;
% Map(30:60, 54:64) = 4;
% ConcentrationMap = imresize(Map,size(X)); % 图片缩放到与可视区范围相同
% Phantom = cast(ConcentrationMap,'double'); % 类型转换

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
strength_result_x = sig2strength(signal_fre_x, Drive_x, Drive_y, point_number*period_number, size(X,1));

signal_fre_y = Period_signal_processing(signal_y, point_number, period_number, fre_index);    % 获取扫描时间上n次谐波幅值
strength_result_y = sig2strength(signal_fre_y, Drive_x, Drive_y, point_number*period_number, size(X,1));
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
% save './out_data/img_phantom.mat' strength_result_x;
%% 生成三次谐波sm
range_x = 2*size(strength_result_x, 1)-1;
range_y = 2*size(strength_result_x, 2)-1;
size_x = size(strength_result_x, 1);
size_y = size(strength_result_x, 2);
system_matrix = zeros(size(strength_result_x,1)*size(strength_result_x, 2), range_x*range_y);
% system_matrix = [];
padding_psf = zeros(3*size(strength_result_x,1), 3*size(strength_result_x,2));
padding_psf(size_x+1:2*size_x, size_y+1:2*size_y) = strength_result_x;
% padding_psf(padding_psf==0) = min(min(img_filter));
origin_point_x = size_x/2+1;
origin_point_y = size_y/2+1;
for i = 1:range_x
    for j = 1:range_y
        a = ((3*size_x - floor(size_x/2)-j)-floor(size_x/2)):((3*size_x-floor(size_x/2)-j)+floor(size_x/2));
        b = ((3*size_y - floor(size_y/2)-i)-floor(size_y/2)):((3*size_y-floor(size_y/2)-i)+floor(size_y/2));
        current_psf = padding_psf(a, b);
        index_n = range_x*(i-1)+j;
        cur = reshape(current_psf, [],1);
        system_matrix(:, index_n) = cur;
        disp(index_n);
    end
end
figure(9);
imagesc(abs(system_matrix));
title("system matrix");
colorbar();
colormap('jet');
save './out_data/system_matrix.mat' system_matrix;
