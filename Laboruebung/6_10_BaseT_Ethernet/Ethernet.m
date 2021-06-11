k = 8; % 8 Bit-Payload

% -- 1
bits = [1 1 1 1 0 1 0 0]; %randi([0 1], k, 1);

% -- 2 Machester - encoding
% 10Mbps -> 1 bit / us 
% Abtastrate = 1Ghz -> 1 Abtastwert pro ns
bitrate = 10;
n = 100;
T = length(bits)/bitrate;
N = n*length(bits);
dt = T/N;
t = 0:dt:T;
y = zeros(1,length(t));
for i=1:length(bits)
  if bits(i)==1
    y((i-1)*n+1:(i-1)*n+n/2) = 1;
    y((i-1)*n+n/2:i*n) = -1;
  else
    y((i-1)*n+1:(i-1)*n+n/2) = -1;
    y((i-1)*n+n/2:i*n) = 1;
  end
end
t = t(1:end-1);
y=y(1:end-1);

figure(1);

plot(t, y, 'Linewidth', 3);
xlabel('us');
ylabel('Voltage V');

figure(2);
hold on

% -- 3/4 - CAT 3
% sampling frequency
Fs = 1000000; % 1GHz
d = 100; % cable length

y_recv = transmit10BaseT(y, Fs, d, 'CAT 3');

plot(t, y_recv, 'Linewidth', 3);
xlabel('us');
ylabel('Voltage V');

hold on

% -- 3/4 - CAT 5
% sampling frequency
Fs = 1000000; % 1GHz
d = 100; % cable length

y_recv = transmit10BaseT(y, Fs, d, 'CAT 5');

plot(t, y_recv, 'Linewidth', 3);
xlabel('us');
ylabel('Voltage V');









