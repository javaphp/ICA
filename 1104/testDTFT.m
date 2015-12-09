clear all; clf; clc

[y1,Fs,bits]=wavread('shengxia.wav');

y1 = y1(:,1);

[row col] = size(y1);
y1 = reshape(y1,1,row*col);

x=y1(1:51000);

j=sqrt(-1);
f1=100; fs=1000; %单位Hz
L=100;   %矩形窗宽度
t=-10:0.1:110; %单位ms
xt=exp(j*2*pi*f1*t/1000); %100Hz模拟虚指数信号 
Real_xt=real(xt);
n=0:L-1; xL=exp(j*2*pi*f1*n/fs); %矩形窗截断的离散时间信号
Real_xL=real(xL);
subplot(2,1,1)
axis([-10,110,-1,1])
hold on
plot(t,Real_xt,'r')
bar(n,Real_xL,0)
plot(n,Real_xL,'.')
plot([-10,110],[0,0],'k')
xlabel('t /nT(ms)  T=1ms')
title('100Hz模拟虚指数信号实部及其时域加窗截断离散时间信号的波形图')
f=-fs/2:0.1:fs/2; w=2*pi*f/fs;
XL_R100=dtft(xL,w);
subplot(2,1,2)
axis([-fs/2,fs/2,0,40])
hold on
plot(f,20*log10(abs(XL_R100)),'b')
xlabel('f (Hz)')
ylabel('dB')
title('L=100矩形窗截断离散虚指数信号的DTFT幅度谱')
grid
