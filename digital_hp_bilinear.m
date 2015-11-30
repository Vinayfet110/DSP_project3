% 5. 1st order digital high pass filter using bi- linear technique

%
% Filter
%
clear;clc;close all;
%% load data
n=100;
A=10;
t = linspace(0,2*pi,n);
fm=1;
s = A*sin(2*pi*fm*t);   %
 
[r,n]=size(s);
 
%% add noise
% nois = wgn(1,n,0);
nois = 0.2*A*sin(2*pi*1000*t);
sn = s + nois;
 
%% define filter and filter params
fc=80;     %
 
w = linspace(0,1*pi,n);
 
wc = pi*fc/n;
 
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
plot(abs(filtrdfft));title('FFT filterd Signal');
subplot(339);
 
m = max(abs(s));
recA = max(real(filtrd_rec));
plot(t,m*real(filtrd_rec)./recA);title('Filterd Signal');axis([0 t(end) -A A]);
 
