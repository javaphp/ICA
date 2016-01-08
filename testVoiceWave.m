clear all;close all;clc;

[y1,Fs,bits]=wavread('shengxia.wav');
[y2,Fs,bits]=wavread('yanhua.wav');
[y3,Fs,bits]=wavread('niba.wav');

y1 = y1(:,1);
y2 = y2(:,1);
y3 = y3(:,1);

[row col] = size(y1);
y1 = reshape(y1,1,row*col);
[row col] = size(y2);
y2 = reshape(y2,1,row*col);
[row col] = size(y3);
y3 = reshape(y3,1,row*col);

x=y1(1:51000);
x2 = y2(1:51000);
x3 = y3(1:51000);

figure
subplot(311);
plot(y1);title('Í¼Ïñ1');
subplot(312)
plot(y2);
subplot(313)
plot(y3);


[y4,Fs,bits]=wavread('./media/1.wav');
[y5,Fs,bits]=wavread('./media/2.wav');
[y6,Fs,bits]=wavread('./media/3.wav');
 
[y7,Fs,bits]=wavread('./media/ganlan.wav');
[y8,Fs,bits]=wavread('./media/gao.wav');

y4 = y4(:,1);
y5 = y5(:,1);
y6 = y6(:,1);
y7 = y7(:,1);
y8 = y8(:,1);

figure
subplot(311)
plot(y4);
subplot(312)
plot(y5);
subplot(313)
plot(y6);
figure,
subplot(211),plot(y7);
subplot(212),plot(y8);
