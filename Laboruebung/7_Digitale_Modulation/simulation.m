%% Darstellung der Signale
% 1
k = 1000; % 20 Bit-Payload
bits = randi([0 1], k, 1);
fs= 64;
fc = fs/4;
obj = comm.RectangularQAMModulator('BitInput', true);
comples_symbols = obj(bits);

qam_signal=rectpulse(comples_symbols, fs);
% 
figure(1);
xlabel('In-Phase');
ylabel('Quadrature');

% <<< signal- manipulation 
for SNRdB = [-10, 0 ,10]
    figure();
    comples_symbols_noisy = awgn(qam_signal,SNRdB-pow2db(fs));

    y = intdump(comples_symbols_noisy,fs);
    obj = comm.RectangularQAMDemodulator('BitOutput', true);
    bits_dec = obj(y);
    
    scatter(real(y), imag(y));
    hold on;
    scatter(real(comples_symbols), imag(comples_symbols));
    title(SNRdB, "[dB]"+" BitErr: "+ num2str(biterr(bits_dec, bits)));
    
end
% >>>signal- manipulation