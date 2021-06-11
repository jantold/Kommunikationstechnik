k = 8 % 8 Bit-Payload

% 1
bits = [1 1 1 1 0 1 0 0] %randi([0 1], k, 1);

% 2
% 10Mbps -> 1 bit / us 
% Abtastrate = 1Ghz -> 1 Abtastwert pro ns

bitrate = 10
n = 100;
T = length(bits)/bitrate;
N = n*length(bits);
dt = T/N;
t = 0:dt:T;
x = zeros(1,length(t));
for i=1:length(bits)
  if bits(i)==1
    x((i-1)*n+1:(i-1)*n+n/2) = 1;
    x((i-1)*n+n/2:i*n) = -1;
  else
    x((i-1)*n+1:(i-1)*n+n/2) = -1;
    x((i-1)*n+n/2:i*n) = 1;
  end
end

plot(t, x, 'Linewidth', 3);
xlabel('us');

% 3

ylabel('Voltage V');