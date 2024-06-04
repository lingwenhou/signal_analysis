%% Xi'Dian二维MPI设备仿真
clear
clc;
close all;
%% 参数设置
particle_diameters = 35e-9;
sample_rate = 2e6;      % 采样率
Drive_Amp = 16;     % 驱动场幅值 A
Excited_Amp = 12;      % 激励场幅值 A
Drive_x_fre = 500;        % 单位 Hz  
Drive_y_fre = 10;       % 单位 Hz
Excited_fre = 25e3;         % 单位 Hz
Gradient_x = 1.25e3;      % mT/m
Gradient_y = Gradient_x;
%% 生成仿体
volume_size = 5e-4;
size_x = 2*Drive_Amp/Gradient_x;      % 定义FOV 及体素大小
size_y = 2*Drive_Amp/Gradient_x;
range_x = -size_x/2:volume_size:size_x/2;       
range_y = -size_y/2:volume_size:size_y/2;
[X, Y] = meshgrid(range_x, range_y);

% phantom_img = imread("./phantom_fig/X.png");
% phantom_img_gray = rgb2gray(phantom_img);
% phantom_resize = imresize(phantom_img_gray, size(X));
% Phantom = cast(phantom_resize,'double'); % 类型转换
% Phantom(find(Phantom>0)) = 1;
% Map = zeros(size(X));
% range = 1;
% Map(size(Map,1)/2-range:size(Map,1)/2+range,size(Map,2)/2-range:size(Map,2)/2+range) = 1;
% Map = mat2gray(Map);
% ConcentrationMap = imresize(Map,size(X)); % 图片缩放到与可视区范围相同
% Phantom = cast(ConcentrationMap,'double'); % 类型转换

% 五点仿体
% Map = zeros(size(X));
% range = 1;
% Map(size(Map,1)/2-range:size(Map,1)/2+range,size(Map,2)/2-range:size(Map,2)/2+range) = 1; % 中间
% Map(4:4+2*range,4:4+2*range) = 1;   % 左上
% Map(size(Map,1)-(4+2*range):size(Map,1)-4,4:4+2*range) = 1;     % 右上
% Map(4:4+2*range,size(Map,2)-(4+2*range):size(Map,2)-4) = 1;     % 左下
% Map(size(Map,1)-(4+2*range):size(Map,1)-4,size(Map,2)-(4+2*range):size(Map,2)-4) = 1;       % 右下
% % 九点
% Map(size(Map,1)/2-range:size(Map,1)/2+range,4:4+2*range) = 1;       % 左中
% Map(size(Map,1)/2-range:size(Map,1)/2+range,size(Map,2)-(4+2*range):size(Map,2)-4) = 1; %右中
% Map(4:4+2*range,size(Map,2)/2-range:size(Map,2)/2+range) = 1;       % 上中
% Map(size(Map,2)-(4+2*range):size(Map,2)-4, size(Map,2)/2-range:size(Map,2)/2+range) = 1;       % 下中

% 直线仿体
Map = zeros(size(X));
range = size(Map,1)/4;
Map(size(Map,1)/2-range:size(Map,1)/2+range,size(Map,2)/2-2:size(Map,2)/2+2) = 1; % 中间
% 
Map = mat2gray(Map);
ConcentrationMap = imresize(Map,size(X)); % 图片缩放到与可视区范围相同
Phantom = cast(ConcentrationMap,'double'); % 类型转换
% figure
% imagesc(Phantom)
% axis equal
% axis off


%% 信号生成
[signal_x, Position_x, Position_y, Position_F] = calculate_signal(Phantom, Excited_Amp, Excited_fre, Drive_Amp, Drive_x_fre, Drive_y_fre,Gradient_x, Gradient_y, sample_rate, particle_diameters, X, Y);
%% 绘图
Img_out = Position_F(X,Y);

out_img = signal2img(X, Y, Position_x, Position_y, signal_x);
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
colorbar()
colormap('parula')
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
colormap('parula');
colorbar()
save './out_data/vertival.mat' upsample_img;
% psf_out = upsample_img;
% save './out_data/mid_psf.mat' psf_out;
