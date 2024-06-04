clear;
clc;
close all;

load("vertival.mat")
load("mid_psf.mat")

phantom_img = imread("../phantom_fig/X.png");
phantom_img_gray = rgb2gray(phantom_img);
phantom_resize = imresize(phantom_img_gray, [52,52]);
Phantom = cast(phantom_resize,'double'); % 类型转换

estimated_nsr = 0;
wnr_deconv = deconvwnr(upsample_img, psf_out, estimated_nsr);

figure
% subplot(131)
% imshow(Phantom,[]);
subplot(121);
imshow(upsample_img,[]);
subplot(122);
imshow(wnr_deconv,[]);
% colormap('parula');
% colorbar()