clc;clear all;close all;
%% 采用fft后混合，混合后在做fft，散点图只显示两条直线

n1=40;
window=boxcar(n1);
w1=window;

[y1,Fs1,bits]=wavread('shengxia.wav');
[y2,Fs2,bits]=wavread('media/gao.wav');
%[y2,Fs2,bits]=wavread('media/nv.wav');
[y3,Fs3,bits]=wavread('huiyin.wav');
%[y3,Fs,bits]=wavread('niba.wav');

originSource1 = y1;
y1 = y1(:,1);
y2 = y2(:,1);
y3 = y3(:,1);

[row col] = size(y1);
length1 = row * col;
y1 = reshape(y1,1,row*col);
[row col] = size(y2);
length2 = row * col;
y2 = reshape(y2,1,row*col);
[row col] = size(y3);
length3 = row * col;
y3 = reshape(y3,1,row*col);

N = 50000;  % 原数据去的点数
y1 = y1(1,1:N);
y2 = y2(1,1:N);
y3 = y3(1,1:N);

figure,subplot(311),plot(y1);title('原信号s1');
subplot(312),plot(y2);title('原信号s2');
subplot(313),plot(y3);title('原信号s3');

% y1fft = fft(y1,45000);
% y2fft = fft(y2,45000);
% y3fft = fft(y3,45000);
% figure,subplot(131);plot(abs(y1fft));
% subplot(132);plot(abs(y2fft));
% subplot(133);plot(abs(y3fft));

x11 = cos(pi/6)*y1 + cos(4*pi/9)*y2 + cos(3*pi/4)*y3;
x21 = sin(pi/6)*y1 + sin(4*pi/9)*y2 + sin(3*pi/4)*y3;

test1 = fft(x11);
test2 = fft(x21);
% [cA1, cD1] = dwt(x11,'db1');
% [cA2, cD2] = dwt(x21,'db1');

figure,plot(real(test1),real(test2),'*');title('实部');
figure,plot(imag(test1),imag(test2),'*');title('虚部');
% figure,plot(cA2,cA1,'*');title('小波变换低频');
% figure,plot(cD2,cD1,'*');title('小波变换高频');