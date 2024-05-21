function img_upsanle = Upsimpleimage(img)
%% 插值方法
[m,n] = size(img);
padded_image = zeros(size(img)+2);
[M, N] = size(padded_image);

padded_image(2:M-1,1) = img(:,1);
padded_image(2:M-1,N) = img(:,n);
padded_image(M,2:N-1) = img(m,:);
padded_image(1,2:N-1) = img(1,:);

padded_image(2:M-1,2:N-1) = img;

filter = [1,1,1; 1,0,1; 1,1,1];

filtered_image = zeros(M, N);
for i = 2:M-1
    for j = 2:N-1
        if padded_image(i,j)==0
            patch = padded_image(i-1:i+1, j-1:j+1);
            tmp = patch .* filter;
            if sum(sum(tmp~=0))>0
                filtered_image(i,j) = sum(sum(tmp))/sum(sum(filter(tmp~=0)));
            end
        end
    end
end
filtered_image = filtered_image(2:m+1,2:n+1);
img_upsanle = img + filtered_image;
end