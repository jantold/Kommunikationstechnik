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
sa_en = modulate(qam_signal, fc, fs, 'qam', qam_signal);

% 5
sa_de= demod(sa_en,fc,fs,'qam');

% 6
y = intdump(sa_de,fs);

% 7
obj = comm.RectangularQAMDemodulator('BitOutput', true);
bits_dec = obj(y);

% 8
biterr(bits_dec, bits)

