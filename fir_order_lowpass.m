%1. 1st order analog low pass filter on sinusoid
%
% Filter
%
clear;clc;close all;
n=100;
A=10;
t = linspace(0,2*pi,n);
s = A*sin(2*pi*1*t);
nois = 0.2*A*sin(2*pi*1000*t);
% nois = 0.2*A*rand(1,n);
% nois = wgn(1,n,1);
sn = s + nois;
% sn =awgn(s,10,'measured');
 
snfft = (fft(sn));
%% Filter design and implement
w = linspace(0,1*pi/2,n);
%wc = pi/1.5;
ohmc=0.5;
ohm=tan(w/2);
 
Ac = 3;
Gc = 10^(-Ac/20);
Gcsq = Gc.^2;
alph = ohmc.*sqrt(Gcsq)./sqrt(1-Gcsq);
 
Hw = alph./(1i*ohm + alph);
filtrd = snfft.*abs(Hw).^2;
 
figure;
subplot(331);
plot(t,s);title('Orignal Signal');axis([0 t(end) -A A]);
subplot(332);
plot(t,nois);title('noise Signal');axis([0 t(end) -A A]);
subplot(333);
plot(t,sn);title('Noisy signal');axis([0 t(end) -A A]);
subplot(334);
plot(ohm,(abs((fft(s)))));title('FFT Orignal Signal');
subplot(335);
plot(ohm,(abs((fft(nois)))));title('FFT noise Signal');
subplot(336);
plot(ohm,(abs((snfft))));title('noisy Signal FFT');
subplot(337);
plot(ohm,abs(Hw).^2);title('Filter ');
Hwc = interp1(ohm,Hw,ohmc);
hold on; plot(ohmc,abs(Hwc).^2,'ro','markerfacecolor','r','markersize',5);
subplot(338);
 
 
plot(ohm,abs(filtrd));title('FFT filterd Signal');
subplot(339);
filtrd_rec = ifft(((filtrd)));
m = max(s);
recA = max(real(filtrd_rec));
plot(t,m*real(filtrd_rec)./recA);title('Filterd Signal');axis([0 t(end) -A A]);
 
 
