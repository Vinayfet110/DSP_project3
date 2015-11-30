
%7. Butter worth low pass filter on sinusoid

%
% Filter
%
clear;clc;close all;
 
%% read data add noise
 
n=100;
A=10;
 
t = linspace(0,2*pi,n);
s = A*sin(2*pi*1*t);
 
nois = 0.2*A*sin(2*pi*1000*t);
% nois = 0.2*A*rand(1,n);
% nois = wgn(1,n,1);
sn = s + nois;
 
snfft = (fft(sn));
 
%% Filter
 
w = linspace(0,1*pi,n);
fc = 45;        % on the scale of 100 where n =100
wc = fc*pi/n;
N = 20;           % filter order
 
Hw = sqrt(1./(1+(w/wc).^(2*N)));
 
filtrd = snfft.*abs(Hw).^2;
 
 
figure;
subplot(331);
plot(t,s);title('Orignal Signal');axis([0 t(end) -A A]);
subplot(332);
plot(t,nois);title('noise Signal');axis([0 t(end) -A A]);
subplot(333);
plot(t,sn);title('Noisy signal');axis([0 t(end) -A A]);
subplot(334);
plot((abs((fft(s)))));title('FFT Orignal Signal');
subplot(335);
plot((abs((fft(nois)))));title('FFT noise Signal');
subplot(336);
plot((abs((snfft))));title('noisy Signal FFT');
subplot(337);
plot(abs(Hw).^2);title('Filter ');
Hwc = interp1(w,Hw,wc);
hold on; plot(fc,abs(Hwc).^2,'ro','markerfacecolor','r','markersize',5);
 
subplot(338);
plot(abs(filtrd));title('FFT filterd Signal');
subplot(339);
filtrd_rec = ifft(((filtrd)));
m = max(s);
recA = max(real(filtrd_rec));
fil_final = m*real(filtrd_rec)/recA;
plot(t,fil_final);title('Filterd Signal');axis([0 t(end) -A A]);



