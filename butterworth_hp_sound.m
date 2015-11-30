
%11. Butter worth high pass filter on sound

%
% Filter
%
clear;clc;close all;
 
%% read data
fname = 'HBD.wav';
[s,fs]=audioread(fname);
s=s';
A = max(s);
n = size(s,2);
 
t = linspace(0,n/fs,n);
disp('Playing orignal signal....');
 sound(s,fs);
 
%% add noise
nois = 0.2*A*sin(2*pi*1e6*t);
% nois = 0.3*A*rand(1,n);
sn = s + nois;
 
pause(12);
disp('Playing noisy Signal');
audiowrite(['Noisy_' fname],sn,fs);
sound(sn,fs);
 
snfft = (fft(sn));
 
%% Filter
scl = 1000;
xf = linspace(0,n/scl,n);  % scalling X axis of frequency by 1000 (kHz)
fc = 220;        %
w = linspace(0,1*pi,n);
wc = pi*fc*scl/n;
 
N = 10;           % filter order
 
Hw = sqrt(1./(1+(w/wc).^(-2*N)));
 
filtrd = snfft.*abs(Hw).^2;
 
 
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
plot(xf,abs(filtrd));title('FFT filterd Signal');
subplot(339);
filtrd_rec = ifft(((filtrd)));
m = max(s);
recA = max(real(filtrd_rec));
fil_final = m*real(filtrd_rec)/recA;
plot(t,fil_final);title('Filterd Signal');axis([0 t(end) -A A]);
 
pause(12);
disp('Playing recovered Signal');
sound(fil_final,fs);
audiowrite(['buterworth_highpass_filterd' fname], fil_final,fs);
