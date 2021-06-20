%% Darstellung der Signale
% 1
k = 100; % 20 Bit-Payload
bits = randi([0 1], k, 1);
fs= 64;
fc = fs/4;
obj = comm.RectangularQAMModulator('BitInput', true);
comples_symbols = obj(bits);

figure(1);
xlabel('In-Phase');
ylabel('Quadrature');

% <<< signal- manipulation 
for SNRdB = [-10, 0 ,10]
    figure();
    comples_symbols_noisy = awgn(comples_symbols,SNRdB-pow2db(fs));
    scatter(real(comples_symbols_noisy), imag(comples_symbols_noisy));
    hold on;
    scatter(real(comples_symbols), imag(comples_symbols));
    title(SNRdB, "dB");
    
end
% >>>signal- manipulation