function out = chebyshev_Core(u_chebyshev, H_S, Excited_Fre)
    MS=446000;      %粒子饱和磁化强度(A/m为单位)
    D = 25e-9;
    V=1/6*pi*D^3;       %磁粒子体积计算
    momet=V*MS;     %磁矩
    T = zeros(20, length(u_chebyshev));
    for i = 1:20
        T(i,:) = chebyshevT(i-1, u_chebyshev);      % 使用切比雪夫多项式计算前20次谐波
    end
    sqrt_cur = sqrt(1-u_chebyshev.^2);
    T = T.*sqrt(1-u_chebyshev.^2);
    conv_ideal = 4i*momet*Excited_Fre;      % 理想粒子为 德尔塔函数
    conv_kernal = 2i*Excited_Fre*deri_langevin(H_S);

    out = conv_ideal*T;
    out(imag(out)==0) = 0;
    function out = deri_langevin(xi)
        if xi == 0
            out = 1/3;
        else 
            out = (1./xi-1./(sinh(xi).^2));
        end
    end
end


% clc;
% clear;
% x = -2:0.001:2;
% u = sin((3)*acos(x)) ./ sin(acos(x));
% T = u .* (x >= -1 & x <= 1);
% T(3001) = 3;
% figure(1);
% plot(x,T);
% 
% conv_kernel = 0.6*(1./x.^2-1./sinh(x).^2);
% conv_kernel(2001) = 1/3;
% figure(2);
% plot(x,conv_kernel);
% % multi = T'*conv_kernel;
% % sign = sum(multi,2);
% % s_3 = sum(T'*conv_kernel,2);
% s_3 = conv(T, conv_kernel','same');
% 
% figure(3);
% plot(s_3);
% % figure(1)
% % for i = 2:10
% %     subplot(3,3,i-1);
% %     plot(x,real(sin((i+1)*acos(x))./sin(acos(x))));
% %     sub_name = strcat(num2str(i+1),"次");
% %     title(sub_name);
% % end
