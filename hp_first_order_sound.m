%6. 1st order High pass filter on sound
%
% Filter
%
clear;clc;close all;
%% load data
fname = 'HBD.wav';
[s,fs]=audioread(fname);
s = s';
[r,n]=size(s);
 
A=max(s);
t = linspace(0,n/fs,n);
 
disp('Playing orignal signal....');
 sound(s,fs);
 
 
%% add noise
% nois = wgn(1,n,0);
nois = 0.2*A*sin(2*pi*1e6*t);
sn = s + nois;
 
% pause(12);
disp('Playing noisy signal');
% sound(sn,fs);
audiowrite(['Noisy_' fname],sn,fs);
 
%% define filter and filter params
 
scl = 1000;
xf = linspace(0,n/scl,n);  % scalling X axis of frequency by 1000 (kHz)
fc=230;
 
w = linspace(0,1*pi,n);
 
wc = pi*fc*scl/n;
 
Ac = 3;      % Ac value close to 3 gives Gcsq = 0.5
Gc = 10^(-Ac/20);
Gcsq = Gc.^2;
alph = tan(wc/2).*sqrt(1-Gcsq)./sqrt(Gcsq);
 
b0 = 1/(1+alph);
b1 = -b0;
a1 = -(1-alph)/(1+alph);
z = exp(-1i*w);
Hw = (b0 + b1*(z).^(-1))./(1+a1*(z).^(-1));
 
 
 
%% FFT os signals and filter implementation
 
snfft = ((fft(sn)));
 
sfft = ((fft(s)));
noisfft = ((fft(nois)));
filtrdfft = snfft.*abs(Hw).^2;
filtrd_rec = ifft((filtrdfft));
 
figure;
subplot(331);
plot(t,s);title('Orignal Signal');axis([0 t(end) -A A]);
subplot(332);
plot(t,nois);title('noise Signal');axis([0 t(end) -A A]);
subplot(333);
plot(t,sn);title('Noisy signal');axis([0 t(end) -A A]);
subplot(334);
plot(xf,(abs((fft(s)))));title('FFT Orignal Signal');
subplot(335);
plot(xf,(abs((fft(nois)))));title('FFT noise Signal');
subplot(336);
plot(xf,(abs((snfft))));title('noisy Signal FFT');
subplot(337);
plot(xf,abs(Hw).^2);title('Filter ');
Hwc = interp1(w,Hw,wc);
hold on; plot(fc,abs(Hwc).^2,'ro','markerfacecolor','r','markersize',5);
subplot(338);
plot(xf,abs(filtrdfft));title('FFT filterd Signal');
subplot(339);
 
m = max(abs(s));
recA = max(real(filtrd_rec));
fil_final = m*real(filtrd_rec)./recA;
plot(t,fil_final);title('Filterd Signal');axis([0 t(end) -A A]);
 
 
 pause(12);
disp('Playing recovered signal');
 sound(fil_final,fs);
audiowrite(['Highpass_filterd' fname], fil_final,fs);
