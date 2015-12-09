clc;clear all;close all;

[y1,Fs,bits]=wavread('shengxia.wav');
[y2,Fs,bits]=wavread('../yanhua.wav');
[y3,Fs,bits]=wavread('../niba.wav');

y1 = y1(:,1);
y2 = y2(:,1);
y3 = y3(:,1);

wlen = 200;
inc = 80;
win = hanning(wlen);
y = stftms(y1,win,300,inc);

y22 = stftms(y2,win,300,inc);
y33 = stftms(y3,win,300,inc);

[row col] = size(y);
y1new = reshape(y,1,row*col);
[row col] = size(y22);
y2new = reshape(y22,1,row*col);
[row col] = size(y33);
y3new = reshape(y33,1,row*col);
