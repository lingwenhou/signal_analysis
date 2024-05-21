clear;
clc;
close all;

load("out_phantom.mat")
load("psf.mat")

phantom_img = imread("../phantom_fig/X.png");
phantom_img_gray = rgb2gray(phantom_img);
phantom_resize = imresize(phantom_img_gray, [51,51]);
Phantom = cast(phantom_resize,'double'); % 类型转换

estimated_nsr = 0;
wnr_deconv = deconvwnr(upsample_img, psf_out, estimated_nsr);

figure
subplot(131)
imshow(Phantom,[]);
subplot(132);
imshow(upsample_img,[]);
subplot(133);
imshow(wnr_deconv,[]);