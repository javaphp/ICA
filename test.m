clc;clear all;close all;
%% 

n1=40;
window=boxcar(n1);
w1=window;

[y1,Fs,bits]=wavread('shengxia.wav');
[y2,Fs,bits]=wavread('yanhua.wav');
[y3,Fs,bits]=wavread('niba.wav');
[y4,Fs,bits]=wavread('wang.wav');
y1 = y1(:,1);
y2 = y2(:,1);
y3 = y3(:,1);
y4 = y4(:,1);
% figure,
% plot(y2);
% figure,
% plot(y1);

mytest1 = real(fft(y1));
figure,plot(mytest1);
mytest2 = real(fft(y2));
figure,plot(mytest2);
mytest3 = real(fft(y3));
figure,plot(mytest3);