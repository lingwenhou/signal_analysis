function [out_Amplitute, out_phase] = signal_fft(signal, L)
    fft_out = fft(signal, L);      % fft
    fft_Amp01 = abs(fft_out)/L;            % 取幅值 此时为双边带数据 sqrt(a^2+b^2)/N  此处L即为N
    fft_Amp02 = fft_Amp01(1:L/2+1);          % 取前一半
    fft_Amp02(2:end-1) = 2*fft_Amp02(2:end-1);  % 频率修正 因为基波与其他频率幅值相差两倍关系，所以其他频率幅值double
    out_Amplitute = fft_Amp02;
    
    out_phase = angle(fft_out(1:L/2+1));
%     am = (out_phase > 0)+(out_phase<0)*(-1);
    out_Amplitute = ((out_phase > 0)+(out_phase<0)*(-1)).*out_Amplitute;
end