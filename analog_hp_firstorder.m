%4. 1st order analog high pass filter
%
% Filter
%
clear;clc;close all;
%% load data
n=100;
A=10;
t = linspace(0,2*pi,n);
 
fm=1;
s = A*sin(2*pi*fm*t);   % sampling frequency sould be more than 4kHz
 
 
[r,n]=size(s);
 
%% add noise
nois = 0.3*A*sin(2*pi*1000*t);
 
% nois = wgn(1,n,0);
sn = s + nois;
 
%% define filter and filter params
 
w = linspace(0,.99*pi,n);
ohm=tan(w/2);
ohmc=5;
Ac = 3;      % Ac value close to 3 gives Gcsq = 0.5
Gc = 10^(-Ac/20);
Gcsq = Gc.^2;
alph = ohmc.*sqrt(1-Gcsq)./sqrt(Gcsq);
S=1i*ohm;
Hw = S./(S + alph);
 
 
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
plot(ohm,abs(filtrdfft));title('FFT filterd Signal');
subplot(339);
 
m = max(s);
recA = max(real(filtrd_rec));
plot(t,m*real(filtrd_rec)./recA);title('Filterd Signal');axis([0 t(end) -A A]);
 
