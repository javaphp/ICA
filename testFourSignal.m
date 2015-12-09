clc;clear all;close all;
%% 采用fft后混合，s2分离有点变化

n1=40;
window=boxcar(n1);
w1=window;

%[y1,Fs,bits]=wavread('shengxia.wav');
[y1,Fs,bits]=wavread('media/nv.wav');
[y2,Fs,bits]=wavread('huiyin.wav');
[y3,Fs,bits]=wavread('niba.wav');
[y4,Fs,bits]=wavread('4.wav');
originSource1 = y1;
y1 = y1(:,1);
y2 = y2(:,1);
y3 = y3(:,1);
y4 = y4(:,1);

[row col] = size(y1);
length1 = row * col;
y1 = reshape(y1,1,row*col);
[row col] = size(y2);
length2 = row * col;
y2 = reshape(y2,1,row*col);
[row col] = size(y3);
length3 = row * col;
y3 = reshape(y3,1,row*col);
[row col] = size(y4);
length4 = row * col;
y4 = reshape(y4,1,row*col);

y1 = y1(1,1:45000);
y2 = y2(1,1:45000);
y3 = y3(1,1:45000);
y4 = y4(1,1:45000);

y1fft = fft(y1);
y2fft = fft(y2);
y3fft = fft(y3);
y4fft = fft(y4);
[row col] = size(y1fft);
length1 = row * col;
[row col] = size(y2fft);
length2 = row * col;
[row col] = size(y3fft);
length3 = row * col;

mytest1 = real(y1fft);
%figure,plot(mytest1);title('原信号s1实部');
mytest2 = real(y2fft);
%figure,plot(mytest2);title('原信号s2实部');
mytest3 = real(y3fft);
%figure,plot(mytest3);title('原信号s3实部');
mytest4 = real(y4fft);

mytest1Imag = imag(y1fft);
%figure,plot(mytest1);title('原信号s1实部');
mytest2Imag = imag(y2fft);
%figure,plot(mytest2);title('原信号s2实部');
mytest3Imag = imag(y3fft);
%figure,plot(mytest3);title('原信号s3实部');
mytest4Imag = imag(y4fft);


maxLength = max([length1 length2 length3]);
x = zeros(1,maxLength);x2 = zeros(1,maxLength);x3 = zeros(1,maxLength);x4 = zeros(1,maxLength);
xImag = zeros(1,maxLength);x2Imag = zeros(1,maxLength);x3Imag = zeros(1,maxLength);x4Imag = zeros(1,maxLength);
for j=1:length1
    x(1,j) = mytest1(1,j);
    xImag(1,j) = mytest1Imag(1,j);
end
for j=1:length2
    x2(1,j) = mytest2(1,j);
    x2Imag(1,j) = mytest2Imag(1,j);
end
for j=1:length3
    x3(1,j) = mytest3(1,j);
    x3Imag(1,j) = mytest3Imag(1,j);
end
for j=1:length3
    x4(1,j) = mytest4(1,j);
    x4Imag(1,j) = mytest4Imag(1,j);
end
% x=mytest1(1:45000);
% x2 = mytest2(1:45000);
% x3 = mytest3(1:45000);

% x11 = 0.866*x + 0.1736*x2 - 0.1736*x3 - 0.9396*x4;
% x21 = 0.5*x + 0.9848*x2 + 0.9848*x3 + 0.342*x4;
x11 = cos(pi/6)*x + cos(4*pi/9)*x2 + cos(3*pi/4)*x3 + cos(5*pi/6)*x4;
x21 = sin(pi/6)*x + sin(4*pi/9)*x2 + sin(3*pi/4)*x3 + sin(5*pi/6)*x4;
x11Imag = cos(pi/6)*xImag + cos(4*pi/9)*x2Imag + cos(3*pi/4)*x3Imag + cos(5*pi/6)*x4Imag;
x21Imag = sin(pi/6)*xImag + sin(4*pi/9)*x2Imag + sin(3*pi/4)*x3Imag + sin(5*pi/6)*x4Imag;

figure,
axis([0 20 -1 2]);
plot(x,x11,'*');
hold on;
plot(x2,x11,'*');
hold on;
plot(x3,x11,'*');
hold on;
plot(x4,x11,'*');
title('时域散点图');

t=1:length(x);
n=length(x);

S = x11;
S2 = x21;
SImag = x11Imag;
S2Imag = x21Imag;

%% 开始估计原信号
A = zeros(2,4); %待改进
signal = [x11;x21];
signalImag = [x11Imag;x21Imag];

A=[cos(pi/6) cos(4*pi/9) cos(3*pi/4) cos(5*pi/6);sin(pi/6) sin(4*pi/9) sin(3*pi/4) sin(5*pi/6)];

[row col] = size(S);
sLength = row * col;
s1 = zeros(1,sLength);
s2 = zeros(1,sLength);
s3 = zeros(1,sLength);
s4 = zeros(1,sLength);
s1Imag = zeros(1,sLength);
s2Imag = zeros(1,sLength);
s3Imag = zeros(1,sLength);
s4Imag = zeros(1,sLength);

ai1 = abs(A(1,1)/A(2,1));
ai2 = abs(A(1,2)/A(2,2));
ai3 = abs(A(1,3)/A(2,3));
ai4 = abs(A(1,4)/A(2,4));

for j=1:sLength
    kt = abs(S(1,j)/S2(1,j));
    ktImag = abs(SImag(1,j)/S2Imag(1,j));
    
    kt1 = abs(kt-ai1);
    kt2 = abs(kt-ai2);
    kt3 = abs(kt-ai3);
    kt4 = abs(kt-ai4);
    
    kt1Imag = abs(ktImag-ai1);
    kt2Imag = abs(ktImag-ai2);
    kt3Imag = abs(ktImag-ai3);
    kt4Imag = abs(ktImag-ai4);
    
    if (kt1<kt2 && kt1<kt3 && kt1<kt4)
        s1(1,j) = S(1,j)/A(1,1);
    elseif (kt2<kt1 && kt2<kt3 && kt2<kt4) 
        s2(1,j) = S(1,j)/A(1,2);
    elseif (kt3<kt1 && kt3<kt2 && kt3<kt4) 
        s3(1,j) = S(1,j)/A(1,3);
    elseif (kt4<kt1 && kt4<kt2 && kt4<kt3) 
        s4(1,j) = S(1,j)/A(1,4);
    end
    
    if (kt1Imag<kt2Imag && kt1Imag<kt3Imag && kt1Imag<kt4Imag)
        s1Imag(1,j) = SImag(1,j)/A(1,1);
    elseif (kt2Imag<kt1Imag && kt2Imag<kt3Imag && kt2Imag<kt4Imag) 
        s2Imag(1,j) = SImag(1,j)/A(1,2);
    elseif (kt3Imag<kt1Imag && kt3Imag<kt2Imag && kt3Imag<kt4Imag) 
        s3Imag(1,j) = SImag(1,j)/A(1,3);
    elseif (kt4Imag<kt1Imag && kt4Imag<kt2Imag && kt4Imag<kt3Imag) 
        s4Imag(1,j) = SImag(1,j)/A(1,4);
    end
    
    final1(1,j) = s1(1,j) + s1Imag(1,j)*i;
    final2(1,j) = s2(1,j) + s2Imag(1,j)*i;
    final3(1,j) = s3(1,j) + s3Imag(1,j)*i;
    final4(1,j) = s4(1,j) + s4Imag(1,j)*i;
    
end
ss1 = ifft(final1);
ss2 = ifft(final2);
ss3 = ifft(final3);
ss4 = ifft(final4);

% figure,plot(y1);title('原信号s1');
% figure,plot(y2);title('原信号s2');
% figure,plot(y3);title('原信号s3');
figure,subplot(411),plot(y1);title('原信号s1');
subplot(412),plot(y2);title('原信号s2');
subplot(413),plot(y3);title('原信号s3');
subplot(414),plot(y4);title('原信号s4');

% figure,plot(s1Imag);title('估计信号s1');
% figure,plot(s2Imag);title('估计信号s2');
% figure,plot(s3Imag);title('估计信号s3');

% figure,plot(ss1);title('估计信号s1');
% figure,plot(ss2);title('估计信号s2');
% figure,plot(ss3);title('估计信号s3');
figure,subplot(411),plot(ss1);title('估计信号s1');
subplot(412),plot(ss2);title('估计信号s2');
subplot(413),plot(ss3);title('估计信号s3');
subplot(414),plot(ss4);title('估计信号s4');

            






















