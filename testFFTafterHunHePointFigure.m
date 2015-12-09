clc;clear all;close all;
%% ����fft���ϣ���Ϻ�����fft��ɢ��ͼֻ��ʾ����ֱ��

n1=40;
window=boxcar(n1);
w1=window;

[y1,Fs1,bits]=wavread('shengxia.wav');
[y2,Fs2,bits]=wavread('media/nv.wav');
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

figure,subplot(311),plot(y1);title('ԭ�ź�s1');
subplot(312),plot(y2);title('ԭ�ź�s2');
subplot(313),plot(y3);title('ԭ�ź�s3');

y1 = y1(1,1:45000);
y2 = y2(1,1:45000);
y3 = y3(1,1:45000);

x11 = cos(pi/6)*y1 + cos(4*pi/9)*y2 + cos(3*pi/4)*y3;
x21 = sin(pi/6)*y1 + sin(4*pi/9)*y2 + sin(3*pi/4)*y3;

test1 = fft(x11);
test2 = fft(x21);

figure,plot(real(test1),real(test2),'*');title('ʵ��');
figure,plot(imag(test1),imag(test2),'*');title('�鲿');