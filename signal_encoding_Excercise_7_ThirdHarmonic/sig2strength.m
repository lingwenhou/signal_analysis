function img_upsamle = sig2strength(signal, Drive_x, Drive_y, processing_period, voluemenum)
%UNTITLED3 此处显示有关此函数的摘要
%   此处显示详细说明  processing_period  = point_number*period_number

Drive_x_split = Drive_x(1:floor(length(Drive_x)/(processing_period))*(processing_period));      % 与前面相同的处理
Drive_y_split = Drive_y(1:floor(length(Drive_y)/(processing_period))*(processing_period));
Drive_x_split = reshape(Drive_x_split,processing_period,[]);
Drive_y_split = reshape(Drive_y_split,processing_period,[]);

Drive_x_split = mean(Drive_x_split);        % 周期内坐标取均值。
Drive_y_split = mean(Drive_y_split);

% img = RecontructImg(signal,Drive_x_split,Drive_y_split,voluemenum);

Sx = -Drive_x_split;    % 这里为什么取负？
Xmax = max(abs(Sx));
Ymax = max(abs(Drive_y_split));
%size = [ceil(Ymax/Xmax*Vox),Vox];
%size = [Vox,Vox];
img = zeros(voluemenum, voluemenum);
Sx1 = (Sx+Xmax)./(2*Xmax+1e-9);     % 坐标转换（-n~n --> 0-2n）
Sy1 = (Drive_y_split+Ymax)./(2*Ymax+1e-9);

x = floor(Sx1*voluemenum)+1;
y = floor(Sy1*voluemenum)+1;
t = ones(voluemenum,voluemenum);
for i = 1:length(signal)
    if ~isnan(signal(i))
        if img(y(i),x(i)) == 0
            img(y(i),x(i)) = signal(i);
        else
            img(y(i),x(i)) = img(y(i),x(i)) + signal(i);
            t(y(i),x(i)) = t(y(i),x(i))+1;
        end
    end
end
img = img./t;

img_upsamle = Upsimpleimage(img);
img_upsamle = img_upsamle(1:end-2,3:end);
end

