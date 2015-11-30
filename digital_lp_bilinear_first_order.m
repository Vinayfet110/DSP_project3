%2. 1st order digital low pass filter using bi linear transform
%
% Filter
%
clear;clc;close all;
%%
% initial values and signals
n=100;
A=10;
 
t = linspace(0,2*pi,n);
s = A*sin(2*pi*1*t);
 
nois = 0.2*A*sin(2*pi*1000*t);
% nois = 0.2*A*rand(1,n);
% nois = wgn(1,n,1);
sn = s + nois;
 
snfft = (fft(sn));
 
%% Filter design and implementation
w = linspace(0,1*pi,n);
fc = 20;
 
wc = pi*fc/n;
 
Ac = 3;    % Gcsq = 1.5
Gc = 10^(-Ac/20);
Gcsq = Gc.^2;
alph = tan(wc/2).*sqrt(Gcsq)./sqrt(1-Gcsq);
 
b0 = alph/(1+alph);
b1 = b0;
a1 = -(1-alph)/(1+alph);
z = exp(1i*w);
Hw = (b0 + b1*(z).^(-1))./(1+a1*(z).^(-1));
 
filtrd = snfft.*abs(Hw).^2;
 
%% Plot data
 
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
m = max(abs(s));
recA = max(real(filtrd_rec));
plot(m*real(filtrd_rec)./recA);title('Filterd Signal');
