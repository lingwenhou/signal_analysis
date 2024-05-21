clc
clear
close all
%%������� 20230516  ���嶫

%%����������PSF
load system_matrix.mat  %ƽ����PSF

X_PSF_to_SystemFunction = system_matrix;

%%��������������Ȧ���յ�ͬһ�����������
load img_phantom.mat  %ƽ���������ź�


X_Phantom = strength_result_x;
%ϵͳ����
% SM_parallel = reshape(X_PSF_to_SystemFunction,[],size(X_Phantom,1)*size(X_Phantom,2));

%��������
x = reshape(X_Phantom,[],1);

%�ؽ�
c_x = kaczmarzReg(X_PSF_to_SystemFunction',...
    x,...
  50,1*10^2,1,1,1);  % X����

c_x = reshape(c_x,101,101);
c_x = c_x(25:25+51,25:25+51);

subplot 121
imshow(real(X_Phantom),[])
colormap("jet")
colorbar()
title("Native image(3��г��)","fontsize",18,FontName="����")

subplot 122
imshow(real(c_x),[])
colormap("jet")
colorbar()
title("reconstruction(3��г��)","fontsize",18,FontName="����")

figure
subplot 211
plot(real(X_Phantom(25,:)));
title("Native","fontsize",18,FontName="����");
subplot 212
plot(real(c_x(25,:)));
title("reconstruction","fontsize",18,FontName="����");


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %ϵͳ����
% SM_parallel = reshape(SystemFunctionTwoD_parallel_10,[],2116);
% 
% 
% SM = [SM_parallel SM_vertical];
% 
% 
% %��������
% x = reshape(phantom_paraller,[],1);
% y = reshape(phantom_vertical,[],1);
% 
% xy = [x ; y];
% 
% %%�ؽ�
% 
% c_x = kaczmarzReg(SM_parallel,...
%     x,...
%     1,1*10^-6,1,1,1);   % X����
% 
% c_y = kaczmarzReg(SM_vertical,...
%     y,...
%     1,1*10^-6,1,1,1);   % Y����
% 
% c = kaczmarzReg(SM,...
%     xy,...
%     1,1*10^-6,1,1,1);  % ���Ͻ���
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
% title("ͬ��������ǰ","fontsize",18)
% 
% subplot 233
% imshow(c_x,[])
% colormap("jet")
% colorbar()
% title("ͬ�����X������","fontsize",18)
% 
% subplot 234
% imshow(c,[])
% colormap("jet")
% colorbar()
% title("X-Y���Ͻ�����","fontsize",18)
% 
% subplot 235
% imshow(abs(phantom_vertical),[])
% colormap("jet")
% colorbar()
% title("��ֱ��������ǰ","fontsize",18)
% 
% 
% subplot 236
% imshow(c_y,[])
% colormap("jet")
% colorbar()
% title("��ֱ��Y������","fontsize",18)







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
% title("����ǰ","fontsize",18)
% 
% 
% subplot(1,2,2)
% imshow(c,[])
% colormap("jet")
% colorbar()
% title("������","fontsize",18)




% figure
% for i = 1:91
%     for j = 1:91
%       imagesc(reshape(abs(SystemFunctionTwoD(i,j,:)),46,46))  
%       pause(0.01)
%     end
% end