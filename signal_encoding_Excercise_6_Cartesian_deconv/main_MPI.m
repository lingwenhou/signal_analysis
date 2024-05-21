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
[X, Y] = meshgrid(range_x, range_y);

phantom_img = imread("./phantom_fig/X.png");
phantom_img_gray = rgb2gray(phantom_img);
phantom_resize = imresize(phantom_img_gray, size(X));
Phantom = cast(phantom_resize,'double'); % 类型转换
% Map = zeros(255,255);
% Map(120:130,120:130) = 4;
% Map = mat2gray(Map);
% ConcentrationMap = imresize(Map,size(X)); % 图片缩放到与可视区范围相同
% Phantom = cast(ConcentrationMap,'double'); % 类型转换

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
[signal_x, Position_x, Position_y, Position_F] = calculate_signal(Phantom, Excited_Amp, Excited_fre, Drive_Amp, Drive_x_fre, Drive_y_fre,Gradient_x, sample_rate, particle_diameters, X, Y);
%% 绘图
Img_out = Position_F(X,Y);

out_img = signal2img(size(X,2), size(Y,1), Position_x, Position_y, signal_x);
upsample_img = Upsimpleimage(out_img);
conv_kernel = ones(3,3);
% conv_kernel(2,2)=2;
% img_filter = conv2(upsample_img,conv_kernel,'same');

figure(1)
plot(signal_x);
figure(2);
plot3(Position_x, Position_y, signal_x);

figure(3);
subplot(121)
imshow(Phantom,[]);
subplot(122)
imshow(Img_out,[]);
% imagesc(Img_out);
% colorbar()
% colormap('jet')
axis image;
xlabel( 'X Position');
ylabel('Y Position');
title('Image of interpolated data');

figure(4)
subplot(121)
imshow(Phantom,[]);
subplot(122)
imshow(upsample_img,[]);
% imagesc(img_filter);
% colorbar();
axis image;
xlabel('X position');
ylabel('Y position');
title('position projection Image');

psf_out = upsample_img;
save './out_data/psf.mat' psf_out;
