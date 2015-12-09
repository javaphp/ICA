clc;clear all;close all;
%% 采用fft后混合，两个信号混合，两个观测信号，分离效果良好

n1=40;
window=boxcar(n1);
w1=window;

[y1,Fs,bits]=wavread('shengxia.wav');
%[y2,Fs,bits]=wavread('huiyin.wav');
[y3,Fs,bits]=wavread('niba.wav');
originSource1 = y1;
y1 = y1(:,1);
%y2 = y2(:,1);
y3 = y3(:,1);

[row col] = size(y1);
length1 = row * col;
y1 = reshape(y1,1,row*col);
%[row col] = size(y2);
%length2 = row * col;
%y2 = reshape(y2,1,row*col);
[row col] = size(y3);
length3 = row * col;
y3 = reshape(y3,1,row*col);

y1 = y1(1,1:45000);
%y2 = y2(1,1:45000);
y3 = y3(1,1:45000);

y1fft = fft(y1);
%y2fft = fft(y2);
y3fft = fft(y3);
[row col] = size(y1fft);
length1 = row * col;
%[row col] = size(y2fft);
%length2 = row * col;
[row col] = size(y3fft);
length3 = row * col;

mytest1 = real(y1fft);
%figure,plot(mytest1);title('原信号s1实部');
%mytest2 = real(y2fft);
%figure,plot(mytest2);title('原信号s2实部');
mytest3 = real(y3fft);
%figure,plot(mytest3);title('原信号s3实部');

mytest1Imag = imag(y1fft);
%figure,plot(mytest1);title('原信号s1实部');
%mytest2Imag = imag(y2fft);
%figure,plot(mytest2);title('原信号s2实部');
mytest3Imag = imag(y3fft);
%figure,plot(mytest3);title('原信号s3实部');


maxLength = max([length1 length3]);
x = zeros(1,maxLength);x3 = zeros(1,maxLength);
xImag = zeros(1,maxLength);x3Imag = zeros(1,maxLength);
for j=1:length1
    x(1,j) = mytest1(1,j);
    xImag(1,j) = mytest1Imag(1,j);
end

for j=1:length3
    x3(1,j) = mytest3(1,j);
    x3Imag(1,j) = mytest3Imag(1,j);
end
% x=mytest1(1:45000);
% x2 = mytest2(1:45000);
% x3 = mytest3(1:45000);

% x11 = 0.866*x + 0.1736*x2 - 0.1736*x3 - 0.9396*x4;
% x21 = 0.5*x + 0.9848*x2 + 0.9848*x3 + 0.342*x4;
x11 = cos(pi/6)*x + cos(3*pi/4)*x3;
x21 = sin(pi/6)*x + sin(3*pi/4)*x3;
x11Imag = cos(pi/6)*xImag + cos(3*pi/4)*x3Imag;
x21Imag = sin(pi/6)*xImag + sin(3*pi/4)*x3Imag;

figure,
axis([0 20 -1 2]);
plot(x,x11,'*');

hold on;
plot(x3,x11,'*');
title('时域散点图');


t=1:length(x);
n=length(x);

S = x11;
S2 = x21;
SImag = x11Imag;
S2Imag = x21Imag;

%% 开始估计原信号
A = zeros(2,3); %待改进
signal = [x11;x21];
signalImag = [x11Imag;x21Imag];

A=[cos(pi/6) cos(3*pi/4);sin(pi/6) sin(3*pi/4)];

[row col] = size(S);
sLength = row * col;
s1 = zeros(1,sLength);
s3 = zeros(1,sLength);
s1Imag = zeros(1,sLength);
s3Imag = zeros(1,sLength);

ai1 = abs(A(1,1)/A(2,1));
ai3 = abs(A(1,2)/A(2,2));

for j=1:sLength
    kt = abs(S(1,j)/S2(1,j));
    ktImag = abs(SImag(1,j)/S2Imag(1,j));
    
    kt1 = abs(kt-ai1);
    kt3 = abs(kt-ai3);
    
    kt1Imag = abs(ktImag-ai1);
    kt3Imag = abs(ktImag-ai3);
    
    if (kt1<kt3)
        s1(1,j) = S(1,j)/A(1,1);
    elseif (kt3<kt1) 
        s3(1,j) = S(1,j)/A(1,2);
    end
    
    if (kt1Imag<kt3Imag)
        s1Imag(1,j) = SImag(1,j)/A(1,1);
    elseif (kt3Imag<kt1Imag) 
        s3Imag(1,j) = SImag(1,j)/A(1,2);
    end
    
    final1(1,j) = s1(1,j) + s1Imag(1,j)*i;
    final3(1,j) = s3(1,j) + s3Imag(1,j)*i;
    
end
ss1 = ifft(final1);
ss3 = ifft(final3);


% figure,plot(y1);title('原信号s1');
% figure,plot(y2);title('原信号s2');
% figure,plot(y3);title('原信号s3');
figure,subplot(211),plot(y1);title('原信号s1');
subplot(212),plot(y3);title('原信号s3');

% figure,plot(s1Imag);title('估计信号s1');
% figure,plot(s2Imag);title('估计信号s2');
% figure,plot(s3Imag);title('估计信号s3');

% figure,plot(ss1);title('估计信号s1');
% figure,plot(ss2);title('估计信号s2');
% figure,plot(ss3);title('估计信号s3');
figure,subplot(211),plot(ss1);title('估计信号s1');
subplot(212),plot(ss3);title('估计信号s3');
