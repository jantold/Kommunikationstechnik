%% Darstellung der Signale
% 1
k = 20; % 20 Bit-Payload
bits = randi([0 1], k, 1);

% 2 Digitale Modulation
fs= 64;
fc = fs/4;
obj = comm.RectangularQAMModulator('BitInput', true);
bits_enc = obj(bits);

% 3 Amplitudenmodulation - stimmt das??
qam_signal=rectpulse(bits_enc, fs);

% 4
sa_en = modulate(real(qam_signal), fc, fs, 'qam', imag(qam_signal));

figure();    
plot(sa_en);

hold on;
% 5
[sa_de_i, sa_de_q] = demod(sa_en,fc,fs,'qam');
figure();    
plot(sa_de_i,  'DisplayName', "in phase");
hold on;
plot(sa_de_q,  'DisplayName', "quadrature");
legend();
% 6
y = intdump(sa_de_i +sa_de_q*1i ,fs);

hold on;
% 7
obj = comm.RectangularQAMDemodulator('BitOutput', true);
bits_dec = obj(y);

% 8
biterr(bits_dec, bits)

