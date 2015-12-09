clc;clear all;close all;

[y1,Fs,bits]=wavread('shengxia.wav');
wlen = 200;
inc = 80;
win = hanning(wlen);
y = stftms(y1,win,1024,inc);



















