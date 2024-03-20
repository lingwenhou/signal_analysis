%% Xi'Dian二维MPI设备仿真
clear
clc;
close all;
%% 生成仿体
volume_size = 1e-3;
size_x = 0.02;      % 定义FOV 及体素大小
size_y = 0.02;
range_x = -size_x:volume_size:size_x;       
range_y = -size_y:volume_size:size_y;
[X, Y] = meshgrid(range_x, -range_y);

Map = zeros(255,255);
Map(126:130,126:130) = 4;
Map = mat2gray(Map);
ConcentrationMap = imresize(Map,size(X)); % 图片缩放到与可视区范围相同
Phantom = cast(ConcentrationMap,'double'); % 类型转换

% figure
% imagesc(Phantom)
% axis equal
% axis off

%% 参数设置
particle_diameters = 35e-9;
sample_rate = 2e6;      % 采样率
Drive_Amp = 16;     % 驱动场幅值
Excited_Amp = 12;      % 激励场幅值
Drive_x_fre = 500;        % 单位 Hz  这里设置为10 和 500 是因为 1 和 50 的时候内存不够
Drive_y_fre = 10;       % 单位 Hz
Excited_fre = 25e3;         % 单位 Hz
Gradient_x = 1.39e3;      % mT/m
%% 信号生成
[signal_x, signal_y, Position_x, Position_y, Position_F] = calculate_signal(Phantom, Excited_Amp, Excited_fre, Drive_Amp, Drive_x_fre, Drive_y_fre,Gradient_x, sample_rate, particle_diameters, X, Y);
%% 绘图
figure(1)
plot(signal_x);
figure(2);
plot3(Position_x, Position_y, signal_x);
Img_out = Position_F(X,Y);
figure(3);
imagesc(Img_out);
axis image;
xlabel( 'X Position');
ylabel('Y Position');
title('Image of interpolated data');



