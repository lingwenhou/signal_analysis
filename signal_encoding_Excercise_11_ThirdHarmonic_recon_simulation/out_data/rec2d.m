clc
clear
close all
%%单向解卷积 20230516  廖义东

%%输入正交的PSF
load system_matrix.mat  %平行向PSF

X_PSF_to_SystemFunction = system_matrix;

%%导入正交接收线圈接收到同一个仿体的数据
load img_phantom.mat  %平行向粒子信号


X_Phantom = strength_result_x;
%系统矩阵
% SM_parallel = reshape(X_PSF_to_SystemFunction,[],size(X_Phantom,1)*size(X_Phantom,2));

%仿体输入
x = reshape(X_Phantom,[],1);

%重建
c_x = kaczmarzReg(X_PSF_to_SystemFunction',...
    x,...
  50,1*10^2,1,1,1);  % X解卷积

c_x = reshape(c_x,101,101);
c_x = c_x(25:25+51,25:25+51);

subplot 121
imshow(real(X_Phantom),[])
colormap("jet")
colorbar()
title("Native image(3次谐波)","fontsize",18,FontName="黑体")

subplot 122
imshow(real(c_x),[])
colormap("jet")
colorbar()
title("reconstruction(3次谐波)","fontsize",18,FontName="黑体")

figure
subplot 211
plot(real(X_Phantom(25,:)));
title("Native","fontsize",18,FontName="黑体");
subplot 212
plot(real(c_x(25,:)));
title("reconstruction","fontsize",18,FontName="黑体");


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %系统矩阵
% SM_parallel = reshape(SystemFunctionTwoD_parallel_10,[],2116);
% 
% 
% SM = [SM_parallel SM_vertical];
% 
% 
% %仿体输入
% x = reshape(phantom_paraller,[],1);
% y = reshape(phantom_vertical,[],1);
% 
% xy = [x ; y];
% 
% %%重建
% 
% c_x = kaczmarzReg(SM_parallel,...
%     x,...
%     1,1*10^-6,1,1,1);   % X解卷积
% 
% c_y = kaczmarzReg(SM_vertical,...
%     y,...
%     1,1*10^-6,1,1,1);   % Y解卷积
% 
% c = kaczmarzReg(SM,...
%     xy,...
%     1,1*10^-6,1,1,1);  % 联合解卷积
% 
% c_x = reshape(c_x,91,91);
% c_x = c_x(23:23+45,23:23+45);
% 
% c_y = reshape(c_y,91,91);
% c_y = c_y(23:23+45,23:23+45);
% 
% c = reshape(c,91,91);
% c = c(23:23+45,23:23+45);
% 
% figure
% subplot 231
% 
% subplot 232
% imshow(abs(phantom_paraller),[])
% colormap("jet")
% colorbar()
% title("同向仿体解卷积前","fontsize",18)
% 
% subplot 233
% imshow(c_x,[])
% colormap("jet")
% colorbar()
% title("同向仿体X解卷积后","fontsize",18)
% 
% subplot 234
% imshow(c,[])
% colormap("jet")
% colorbar()
% title("X-Y联合解卷积后","fontsize",18)
% 
% subplot 235
% imshow(abs(phantom_vertical),[])
% colormap("jet")
% colorbar()
% title("垂直向仿体解卷积前","fontsize",18)
% 
% 
% subplot 236
% imshow(c_y,[])
% colormap("jet")
% colorbar()
% title("垂直向Y解卷积后","fontsize",18)







% c = kaczmarzReg(SM,...
%     x,...
%     10,1*10^-6,1,1,1);
% 
% c = reshape(c,91,91);
% c = c(23:23+45,23:23+45);
% figure
% subplot(1,2,1)
% imshow(abs(phantom),[])
% colormap("jet")
% colorbar()
% title("解卷积前","fontsize",18)
% 
% 
% subplot(1,2,2)
% imshow(c,[])
% colormap("jet")
% colorbar()
% title("解卷积后","fontsize",18)




% figure
% for i = 1:91
%     for j = 1:91
%       imagesc(reshape(abs(SystemFunctionTwoD(i,j,:)),46,46))  
%       pause(0.01)
%     end
% end