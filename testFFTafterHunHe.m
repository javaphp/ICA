clc;clear all;close all;
%% 采用fft后混合，混合后在做fft，散点图只显示两条直线

n1=40;
window=boxcar(n1);
w1=window;

% [y1,Fs,bits]=wavread('shengxia.wav');
% %[y2,Fs,bits]=wavread('media/nv.wav');
% [y2,Fs,bits]=wavread('huiyin.wav');
[y3,Fs,bits]=wavread('niba.wav');
[y1,Fs1,bits]=wavread('shengxia.wav');
[y2,Fs2,bits]=wavread('media/gao.wav');
%[y2,Fs2,bits]=wavread('media/nv.wav');
%[y3,Fs3,bits]=wavread('huiyin.wav');

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

N = 100000;  % 原数据去的点数
y1 = y1(1,1:N);
y2 = y2(1,1:N);
y3 = y3(1,1:N);

y1fft = fft(y1);
y2fft = fft(y2);
y3fft = fft(y3);
[row col] = size(y1fft);
length1 = row * col;
[row col] = size(y2fft);
length2 = row * col;
[row col] = size(y3fft);
length3 = row * col;

% x11 = cos(pi/6)*y1fft + cos(4*pi/9)*y2fft + cos(3*pi/4)*y3fft;
% x21 = sin(pi/6)*y1fft + sin(4*pi/9)*y2fft + sin(3*pi/4)*y3fft;
% 
% figure,plot(real(x11),real(x21),'*');title('实部');
% figure,plot(imag(x11),imag(x21),'*');title('虚部');
% figure,plot(abs(x11),abs(x21),'*');title('模');

x11 = cos(pi/6)*y1 + cos(4*pi/9)*y2 + cos(3*pi/4)*y3;
x21 = sin(pi/6)*y1 + sin(4*pi/9)*y2 + sin(3*pi/4)*y3;

x11 = fft(x11);
x21 = fft(x21);

figure,plot(real(x11),real(x21),'*');title('实部');
figure,plot(imag(x11),imag(x21),'*');title('虚部');

%% 估计原信号
A = zeros(2,3); %待改进
signal = [x11;x21];
%signalImag = [x11Imag;x21Imag];

A=[cos(pi/6) cos(4*pi/9) cos(3*pi/4);sin(pi/6) sin(4*pi/9) sin(3*pi/4)];
Sreal1 = real(x11);
Simag1 = imag(x11);
Sreal2 = real(x21);
Simag2 = imag(x21);
[row col] = size(Sreal1);
sLength = row * col;
s1 = zeros(1,sLength);
s2 = zeros(1,sLength);
s3 = zeros(1,sLength);
s1Imag = zeros(1,sLength);
s2Imag = zeros(1,sLength);
s3Imag = zeros(1,sLength);

ai1 = abs(A(1,1)/A(2,1));
ai2 = abs(A(1,2)/A(2,2));
ai3 = abs(A(1,3)/A(2,3));

final1 = zeros(1,37500);final2 = zeros(1,37500);final3 = zeros(1,37490);

for j=1:sLength
    kt = abs(Sreal1(1,j)/Sreal2(1,j));
    ktImag = abs(Simag1(1,j)/Simag2(1,j));
    
    kt1 = abs(kt-ai1);
    kt2 = abs(kt-ai2);
    kt3 = abs(kt-ai3);
    
    kt1Imag = abs(ktImag-ai1);
    kt2Imag = abs(ktImag-ai2);
    kt3Imag = abs(ktImag-ai3);
    
    if (kt1<kt2 && kt1<kt3)
        s1(1,j) = Sreal1(1,j)/A(1,1);
    elseif (kt2<kt1 && kt2<kt3) 
        s2(1,j) = Sreal1(1,j)/A(1,2);
    elseif (kt3<kt1 && kt3<kt2) 
        s3(1,j) = Sreal1(1,j)/A(1,3);
    end
    
    if (kt1Imag<kt2Imag && kt1Imag<kt3Imag)
        s1Imag(1,j) = Simag1(1,j)/A(1,1);
    elseif (kt2Imag<kt1Imag && kt2Imag<kt3Imag) 
        s2Imag(1,j) = Simag1(1,j)/A(1,2);
    elseif (kt3Imag<kt1Imag && kt3Imag<kt2Imag) 
        s3Imag(1,j) = Simag1(1,j)/A(1,3);
    end
    
    final1(1,j) = s1(1,j) + s1Imag(1,j)*i;
    final2(1,j) = s2(1,j) + s2Imag(1,j)*i;
    final3(1,j) = s3(1,j) + s3Imag(1,j)*i;
    
end

ss1 = ifft(final1);
ss2 = ifft(final2);
ss3 = ifft(final3);

figure,subplot(311),plot(y1);title('原信号s1');
subplot(312),plot(y2);title('原信号s2');
subplot(313),plot(y3);title('原信号s3');

%% 实部和虚部fft图像
figure,subplot(311),plot(real(ss1)),title('不填充恢复信号');
subplot(312),plot(real(ss2)),
subplot(313),plot(real(ss3)),


            






