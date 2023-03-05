clc;
close all;

fs = 1000; %sampling frequency
fc = 10; %carrier signal frequency
fm = 1; %baseband signal frequency
am = 1; %amplitude of message signal
ac = 2; %amplitude of carrier signal
t = 0:1/fs:5/fm;

m = am*cos(2*pi*fm*t); %baseband signal
c = ac*cos(2*pi*fc*t); %carrier signal

figure(1)
subplot(211)
plot(t,m,'g')
xlabel('time---->>>>>>>>');
ylabel('amplitude--------->>>>>>');
title('baseband signal');
subplot(212)
plot(t,c,'r')
xlabel('time---->>>>>>>>');
ylabel('amplitude--------->>>>>>');
title('carrier signal');

%output of the adder
v1 = m+c;

%output of the non linear device
a1 = 0.9;
a2 = 0.2;
v2 = a1*v1 + a2*(v1.^2);

figure(2)
subplot(211)
plot(t,v1)
xlabel('time---->>>>>>>>');
ylabel('amplitude--------->>>>>>');
title('output of adder');
subplot(212)
plot(t,v2)
xlabel('time---->>>>>>>>');
ylabel('amplitude--------->>>>>>');
title('output of non linear device');


%bandpass filter with cutoff frequency fc
[b,a]=butter(1,[((fc-fm)/fs),((fc+fm)/fs)]);
y=filter(b,a,v2);
% k = (2*a2*ac)/a1;
% y = a1*(ac+k*m).*cos(2*pi*fc*t);

figure(3)
plot(t,y)
xlabel('time---->>>>>>>>');
ylabel('amplitude--------->>>>>>');
title('AM modulated signal');

% %powers
% sp = (ac^2)/2; %signal power
% variance = 0.2;
% snr = sp/variance; % signal to noise ratio
% 
% 
% %adding noise to the channel
% c = awgn(y,snr);
% 
% figure(4)
% plot(t,c)
% xlabel('time---->>>>>>>>');
% ylabel('amplitude--------->>>>>>');
% title('noise+signal');

%powers
disp('signal power of modulated signal')
signal_power = spower(y(1:length(t))); %power in modulated signal
variance = 0.2;
disp('signal to noise ratio')
snr1 = signal_power/variance;  % signal to noise ratio
snr_lin = 10^(snr1/10);   %linear SNR
disp('noise power added to the modulated signal')
noise_power = signal_power/snr_lin; %compute noise power

%adding noise to the modulated signal
z = awgn(y,snr1);

figure(4)
plot(t,z)

xlabel('time---->>>>>>>>');
ylabel('amplitude--------->>>>>>');
title('awgn noise+signal');


%synchronous detection
demod=y.*c;                
demod1=z.*c;                
[b,a]=butter(3,0.001);
dm=filter(b,a,demod);       %demodulation of AM signal
dm1=filter(b,a,demod1);     %demodulation of corrupted AM signal

figure(5)
subplot(211)
plot(t,dm)

xlabel('time---->>>>>>>>');
ylabel('amplitude--------->>>>>>');
title('demodulation of AM signal');
subplot(212)
plot(t,dm1)

xlabel('time---->>>>>>>>');
ylabel('amplitude--------->>>>>>');
title('demodulation of corrupted AM signal(awgn)');


%power in demodulated corrupted signal at reciever side
disp('signal power of demodulated courrupted signal')
signal_power1 = spower(dm1(1:length(t)));


%spectrums
 N = length(y);
 x=abs(fft(y,N));
 f=((-(N-1)/2):(N-1)/2)*(fs/N);
 q = fftshift(x);
 figure(6)
 subplot(211)
 stem(f,q);
 axis([-21 21 0 610])
 title('spectrum of modulated signal');
 xlabel('time---->>>>>>>>');
 ylabel('amplitude--------->>>>>>');

 N1 = length(dm1);
 x1=abs(fft(dm1,N1));
 f1=((-(N1-1)/2):(N1-1)/2)*(fs/N1);
 q1 = fftshift(x1);

 subplot(212)
 stem(f1,q1);
 axis([-5 5 0 250])
 title('spectrum of demodulated corrupted signal');
 xlabel('time---->>>>>>>>');
 ylabel('amplitude--------->>>>>>');
 