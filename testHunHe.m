clc;clear all;close all;
%% 聚类方法成功出现两个峰值，识别出两个信号数
%窗口函数%?
n1=40;
window=boxcar(n1);
w1=window;
%figure(1);
%stem(w1);
%?非平稳信号产生%?
fs=1000;
a=0:1/fs:1;
f0=0;
f1=150;
%y1=chirp(a,f0,1,f1);
[y1,Fs,bits]=wavread('beyond.wav');

% for t22 = 1:600
%     y2(1,t22) = square((1/150)*pi*t22,50);
% end
fs2 = 2500;
b = 0:1/fs:1;
f2 = 250;
%y2 = chirp(b,f0,1,f2);
[y2,Fs,bits]=wavread('liu.wav');
y1 = y1(:,1);
y2 = y2(:,2);
% figure,
% plot(y2);
% figure,
% plot(y1);

[row col] = size(y1);
y1 = reshape(y1,1,row*col);
[row col] = size(y2);
y2 = reshape(y2,1,row*col);

x=y1(1:5100);
x2 = y2(1:5100);
x11 = 0.45259*x + 0.14647*x2;
x21 = 0.7662*x + 0.060863*x2;


t=1:length(x);
n=length(x);
[S,F,T,P]=spectrogram(x11,w1,32,256);  %S为复数，短时傅里叶变换后的结果

t2=1:length(x2);
n2=length(x2);
[S2,F,T,P]=spectrogram(x21,w1,32,256);  %S为复数，短时傅里叶变换后的结果


%% 聚类判断方法，基于势函数
[row col] = size(S);
length = row*col*2;
originLength = row*col;
StoOneDimension = zeros(1, row*col);
test = reshape(S,1,originLength);
test2 = reshape(S2,1,originLength);
StoOneDimension = [test,test2];
re = zeros(1,length);
im = zeros(1,length);
angle1 = zeros(1,length);
distance = zeros(1,length);
for i=1:1:length
    re(1,i) = real(StoOneDimension(1,i));
    im(1,i) = imag(StoOneDimension(1,i));
    
    angle1(1,i) = angle(StoOneDimension(1,i));
    distance(1,i) = re(1,i)^2+im(1,i)^2;
end

%f=zeros(1,21);
for x=1:100
    y = x/10;
    f(1,x) = 0;
    for i=1:length
        temp = f(1,x);
        a = -abs(10*(angle1(1,i)-y));
        f(1,x) = distance(1,i)*exp(a);
        f(1,x) = f(1,x) + temp;
    end
end
figure
z=1:100
plot(z,f(1,z));
hold on;



















