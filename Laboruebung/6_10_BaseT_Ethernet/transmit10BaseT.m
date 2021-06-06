% function y=transmit10BaseT(x,Fs,d,cable,Fg,NdBmHz)
% x: original signal
% Fs: sampling frequency [Hz]
% d: length of cable [m]
% cable: 'CAT 3' oder 'CAT 5'
% Fg: frequency for lowpass filter [Hz]
% NdBmHz: noise power in dBm per Hz
% y: received signal
function y=transmit10BaseT(x,Fs,d,cable,Fg,NdBmHz)
if nargin< 6
    NdBmHz=-140;
end
if nargin < 5
    Fg=10e6;
end
if nargin < 4
    cable='CAT 3'
end
if nargin < 3
    d=100;
end
% number of sampling points
Ns=length(x);
% frequency samples
f=0:Fs/Ns:Fs/2;
% noise in decibel
NPdB=pow2db(db2pow(NdBmHz)*Fg*2);
% attenuation dB of CAT5 cable per frequency
Hc=db2pow(d/100*getAttenuationCAT(f,cable));
% reorder attenuation accoring to fft output
Hc=[Hc(1:end-1) fliplr(Hc(2:end))];
% cable filter (insertion loss)
Hb=ones(1,Ns)-(abs(fftshift(-Fs/2:Fs/Ns:(Fs/2-Fs/Ns)))>Fg);

% cross talk noise
NEXT=8-16*log10(f*1e-8);
NEXT(1)=100;
NEXT=[NEXT(1:end-1) fliplr(NEXT(2:end))];

% transmission 
y=fft(x,[],2); % signal in frequency domain
y=y.*Hc; % received signal in frequency domain
%y=awgn(y,-NPdB-pow2db(2*numel(y)));
y=y+sqrt(numel(y))*(1./sqrt(db2pow(NEXT)).*(randn(size(y))+sqrt(-1)*randn(size(y))));
y=y.*Hb; % filtered signal in frequency domain
y=real(ifft(y,[],2)); % filtered signal in time domain

function HdB=getAttenuationCAT(f,type)
%% DÄmpfung CAT Kabel
switch type
    case 'CAT 3'
        a=8.17e-7; 
        b=8.07e-11;
    case 'CAT 4'
        a=7.37e-7;
        b=9.12e-12;
    case 'CAT 5'
        a=7.26e-7;
        b=4.56e-12;
end
a=-8.686*3.2808*a;
b=-8.686*3.2808*b;
alpha=a'*sqrt(f)+b'*f;
d=100;
HdB=d*alpha;