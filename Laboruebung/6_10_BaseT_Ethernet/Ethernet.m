k = 8; % 8 Bit-Payload

% -- 1
bits = randi([0 1], k, 1)';

% -- 2 Machester - encoding
% 10Mbps -> 10 bit / us 
% Abtastrate = 1Ghz -> 1 Abtastwert pro ns
bitrate = 10000000;
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

plot(t, y, 'Linewidth', 3,  'DisplayName', 'Manchester-Encoding');
xlabel('us');
ylabel('Voltage V');

% -- 3/4 - CAT 5
% sampling frequency
Fs = 1000000000; % 1GHz
% d = 10000; % cable length
d = 100;
figure(2);
for cat = ["CAT 3" "CAT 5"]
        y_recv = transmit10BaseT(y, Fs, d, cat);
        
        plot(t, y_recv, 'Linewidth', 3, 'DisplayName', 'Manchester-Encoding - ' + cat);
        xlabel('us');
        ylabel('Voltage V');
        legend;
        hold on;
end


% -- 5 Bitfehler
for cat = ["CAT 3" "CAT 5"]
        y_recv = transmit10BaseT(y, Fs, d, cat);

        % manchester decoding
        y_recv = reshape(y_recv, length(y_recv)/k, k)';
        [y_len, x_len] = size(y_recv); 
        for i = 1:y_len
          value = y_recv(i,:);
          value = value + abs(min(value));
          % left > rigth -> 1 else 0
          % ignore the middlepart  
          if sum(value(1:x_len/3)) > sum(value((end- x_len/3):end)) 
              result(i) = 1;
            else result(i) = 0;
          end
        end
        disp(cat);
        fprintf("Biterror: %d", biterr(result, bits));
end




