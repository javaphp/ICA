clc; clear all; close all;

[y1,Fs]=wavread('../shengxia.wav');
[y2,Fs]=wavread('../yanhua.wav');
[y3,Fs]=wavread('../niba.wav');
y1 = y1(:,1);
y2 = y2(:,1);
y3 = y3(:,1);
s = y1;
s2 = y2;
s3 = y3;
Len = length(s);
len2 = length(s2);
len3 = length(s3);

[ca1, cd1] = dwt(s, 'db1'); % 采用db1小波基分解
a1 = upcoef('a', ca1, 'db1', 1, Len); % 从系数得到近似信号
d1 = upcoef('d', cd1, 'db1', 1, Len); % 从系数得到细节信号
s1 = a1+d1; % 重构信号
figure;
subplot(2, 2, 1); plot(s); title('初始电源信号');
subplot(2, 2, 2); plot(ca1); title('一层小波分解的低频信息');
subplot(2, 2, 3); plot(cd1); title('一层小波分解的高频信息');
subplot(2, 2, 4); plot(s1, 'r-'); title('一层小波分解的重构信号');

[ca1, cd1] = dwt(s2, 'db1'); % 采用db1小波基分解
a1 = upcoef('a', ca1, 'db1', 1, Len); % 从系数得到近似信号
d1 = upcoef('d', cd1, 'db1', 1, Len); % 从系数得到细节信号
sBack = a1+d1; % 重构信号
figure;
subplot(2, 2, 1); plot(s2); title('初始电源信号');
subplot(2, 2, 2); plot(ca1); title('一层小波分解的低频信息');
subplot(2, 2, 3); plot(cd1); title('一层小波分解的高频信息');
subplot(2, 2, 4); plot(sBack, 'r-'); title('一层小波分解的重构信号');

[ca1, cd1] = dwt(s3, 'db1'); % 采用db1小波基分解
a1 = upcoef('a', ca1, 'db1', 1, Len); % 从系数得到近似信号
d1 = upcoef('d', cd1, 'db1', 1, Len); % 从系数得到细节信号
s3Back = a1+d1; % 重构信号
figure;
subplot(2, 2, 1); plot(s3); title('初始电源信号');
subplot(2, 2, 2); plot(ca1); title('一层小波分解的低频信息');
subplot(2, 2, 3); plot(cd1); title('一层小波分解的高频信息');
subplot(2, 2, 4); plot(s3Back, 'r-'); title('一层小波分解的重构信号');

