function out_img = signal2img(X, Y, position_x, position_y, signal)

    out_img = zeros(size(X,1), size(X,2));
    without_x = find(abs(position_x)>(max(max(X))));
    without_y = find(abs(position_y)>(max(max(Y))));
    without_position = union(without_x, without_y);
    position_x(without_position) = [];
    position_y(without_position) = [];
    signal(without_position) = [];
    max_range_x = max(abs(position_x));
    max_range_y = max(abs(position_y));
    position_x_positive = position_x+max_range_x;
    position_y_positive = position_y+max_range_y;
    
%     range_x_y = max(max(position_x_positive),max(position_y_positive));
    position_x_map = floor((position_x_positive-min(position_x_positive))/(max(position_x_positive)-min(position_x_positive))*size(X,1));
    position_y_map = floor((position_y_positive-min(position_y_positive))/(max(position_y_positive)-min(position_y_positive))*size(X,2));
    position_x_map(position_x_map==0) = 1;
    position_y_map(position_y_map==0) = 1;

%     plot3(position_x_map, position_y_map, signal);
    times_statis = ones(size(X,1), size(X,2));    % 统计每个voxel处出现的像素个数
    for i = 1:length(signal)
        if(~isnan(signal(i)))
            if out_img(position_x_map(i), position_y_map(i)) == 0
                out_img(position_x_map(i), position_y_map(i)) = signal(i);
            else
                out_img(position_x_map(i), position_y_map(i)) = out_img(position_x_map(i), position_y_map(i)) + signal(i);
                times_statis(position_x_map(i), position_y_map(i)) = times_statis(position_x_map(i), position_y_map(i))+1;
            end
        end
    end
  
    out_img = out_img./times_statis;
    out_img = out_img';
    
end