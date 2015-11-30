%3. 1st order low pass filter on sound signal.

%
% Filter
%
clear;clc;close all;
%% load data
fname = 'HBD.wav';
[s,fs]=audioread(fname);
s=s';
[r,n]=size(s);
A = max(s);
tl = n/fs;
t = linspace(0,tl,n);
 
disp('Playing orignal signal....');
 sound(s,fs);
 
 
%% add noise
% nois = wgn(1,n,-30);   % -30db wgn
nois = 0.2*A*sin(2*pi*1e6*t);  % sinusoidal noise ...
 
sn = s + nois;
 pause(12);
disp('Playing noisy signal');
 sound(sn,fs);
audiowrite(['Noisy_' fname],sn,fs);
 
%% define filter and filter params
scl = 1000;
xf = linspace(0,n/scl,n);  % scalling X axis of frequency by 1000 (kHz)
fc=1;
 
w = linspace(0,1*pi,n);
 
wc = pi*fc*scl/n;
 
Ac = 3;
Gc = 10^(-Ac/20);
Gcsq = Gc.^2;
alph = tan(wc/2).*sqrt(Gcsq)./sqrt(1-Gcsq);
 
b0 = alph/(1+alph);
b1 = b0;
a1 = -(1-alph)/(1+alph);
z = exp(1i*w);
Hw_t = (b0 + b1*(z).^(-1))./(1+a1*(z).^(-1));
Hw = repmat(Hw_t,[r,1]);
 
%% FFT os signals and filter implementation
 
snfft = ((fft(sn)));
 
sfft = ((fft(s)));
noisfft = ((fft(nois)));
filtrdfft = snfft.*abs(Hw).^2;
filtrd_rec = ifft((filtrdfft));
 
 
% Hw = ftrans2(Hw_t);
 
 
%%
 
 
 
figure;
subplot(331);
plot(t,s);title('Orignal Signal');axis([0 t(end) -A A]);
subplot(332);
plot(t,nois);title('noise Signal');axis([0 t(end) -A A]);
subplot(333);
plot(t,sn);title('Noisy signal');axis([0 t(end) -A A]);
subplot(334);
plot(xf,(abs((sfft))));title('FFT Orignal Signal');
subplot(335);
plot(xf,(abs((noisfft))));title('FFT noise Signal');
subplot(336);
plot(xf,(abs(((snfft)))));title('noisy Signal FFT');
subplot(337);
plot(xf,abs(Hw).^2);title('Filter ');
 
Hwc = interp1(w,Hw,wc);
hold on; plot(fc,abs(Hwc).^2,'ro','markerfacecolor','r','markersize',5);
 
subplot(338);
plot(xf,abs(filtrdfft));title('FFT filterd Signal');
subplot(339);
m = (max(s));
 
recA = max(real(filtrd_rec));
fil_final = m*real(filtrd_rec)/recA;   % applying gain...
plot(t,fil_final);title('Filterd Signal');axis([0 t(end) -A A]);
 pause(12);
disp('Playing recovered signal');
 sound(fil_final,fs);
audiowrite(['Lowpass_filterd' fname], fil_final,fs);
 
