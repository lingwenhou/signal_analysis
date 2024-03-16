function out = signal_fft(signal, L)

    Length_sig = length(signal);
    out1 = fft(signal, Length_sig);
    P2 = abs(out1/L);
%     plot(f, P2);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    out = P1;
end