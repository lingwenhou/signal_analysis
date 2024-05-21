clear;
close all;
clc;
%%
%  选择要进行的操作
if_generate_SM = 0;         % 选择是否生成系统矩阵 1 是 0 否
if_simulate_Phantom_signal = 1;         % 选择是否生成仿体信号 1 是 0 否
if_reconstruction_phantom = 0;          % 选择是否进行重建 1 是 0 否
%%
% 参数设置
particle_diameters = 35e-9;
sample_rate = 1e6;      % 采样率可选择更大的采样率
Drive_Amp = 64;     % A      
Drive_x_fre = 3.3e3;
Drive_y_fre = 3.2e3;
Gradient_x = 1.5;      % T/m
    
if if_generate_SM
    generate_system_matrix(particle_diameters, sample_rate,Drive_Amp, Drive_x_fre, Drive_y_fre,Gradient_x);
    disp("Down Generate System Matrix");
end
if if_simulate_Phantom_signal
    volume_size = 1e-3;
    Gradient_y = 2*Gradient_x;
    size_x = Drive_Amp*1e-3*2/Gradient_x;
    size_y = Drive_Amp*1e-3*2/Gradient_y;
    range_x = -size_x:volume_size:size_x;
    range_y = -size_y:volume_size:size_y;
    [X, Y] = meshgrid(range_x, -range_y);

    phantom_img = imread("./phantom_fig/X.png");
    phantom_img_gray = rgb2gray(phantom_img);
    phantom_resize = imresize(phantom_img_gray, size(X));
    generate_phantom = cast(phantom_resize,'double');    % 类型转换
    generate_phantom(find(generate_phantom>0)) = 1;
    simulate_phantom_signal(generate_phantom, particle_diameters, sample_rate,Drive_Amp, Drive_x_fre, Drive_y_fre,Gradient_x, if_simulate_Phantom_signal);
end
if if_reconstruction_phantom
    sm_reconstruction();
end