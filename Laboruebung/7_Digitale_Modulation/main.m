%% Darstellung der Signale
% 1
k = 20; % 20 Bit-Payload
bits = randi([0 1], k, 1);

% 2 Digitale Modulation
fs= 64;
fc = fs/4;
obj = comm.RectangularQAMModulator('BitInput', true);
bits_enc = obj(bits);
qam_signal=rectpulse(bits_enc, fs);

% 3 Amplitudenmodulation - stimmt das??
t = 0:1/fs:1;
i = sin(2*pi*fc*t) + qam_signal;
q = sin(2*pi*fc*t) + qam_signal;
sa_en = modulate(i, fc, fs, 'qam', q);
size(sa_en)

% 4
sa_de= demod(sa_en,fc,fs,'qam');
size(sa_de);
dump = intdump(sa_de, fs);
% size(dump)
obj = comm.RectangularQAMDemodulator('BitOutput', true);
bits_dec = obj(sa_de)'


