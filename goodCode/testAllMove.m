clc;clear all;close all;
%% 采用fft后混合，fft变换后把它们的全部移到中间进行稀疏化,最后采用ifft反变换后的实部与原来作比较效果较好，比使用一半做稀疏效果好

n1=40;
window=boxcar(n1);
w1=window;

%[y1,Fs,bits]=wavread('shengxia.wav');
[y1,Fs,bits]=wavread('../media/nv.wav');
[y2,Fs,bits]=wavread('../huiyin.wav');
[y3,Fs,bits]=wavread('../niba.wav');
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

y1 = y1(1,1:45000);
y2 = y2(1,1:45000);
y3 = y3(1,1:45000);

y1fft = fft(y1);
y2fft = fft(y2);
y3fft = fft(y3);
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

mytest1Imag = imag(y1fft);
%figure,plot(mytest1);title('原信号s1实部');
mytest2Imag = imag(y2fft);
%figure,plot(mytest2);title('原信号s2实部');
mytest3Imag = imag(y3fft);
%figure,plot(mytest3);title('原信号s3实部');

maxLength = max([length1 length2 length3]);
fftLength = maxLength;
sixthLength = fftLength/6;
halfLength = fftLength/2;
firstLength = sixthLength;
secondLength = firstLength * 2;
thirdLength = firstLength * 3;
fourthLength = firstLength * 4;
fifthLength = firstLength * 5;

x = zeros(1,maxLength);x2 = zeros(1,maxLength);x3 = zeros(1,maxLength);
xImag = zeros(1,maxLength);x2Imag = zeros(1,maxLength);x3Imag = zeros(1,maxLength);
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

%% 对s2和s3移位
for k=1:firstLength
    tempX2(1,k) = x2(1,k);
    tempX2Imag(1,k) = x2Imag(1,k);
    x2(1,k) = x2(1,firstLength + k);
    x2(1,firstLength + k) = tempX2(1,k);
    x2Imag(1,k) = x2Imag(1,firstLength + k);
    x2Imag(1,firstLength + k) = tempX2Imag(1,k);
    
    tempX2(1,k) = x2(1,k + fourthLength);
    tempX2Imag(1,k) = x2Imag(1,k + fourthLength);
    x2(1,k+fourthLength) = x2(1,k + fifthLength);
    x2(1,k + fifthLength) = tempX2(1,k);
    x2Imag(1,k+fourthLength) = x2Imag(1,k + fifthLength);
    x2Imag(1,k + fifthLength) = tempX2Imag(1,k);
end

for k=1:firstLength
    tempX3(1,k) = x3(1,k);
    tempX3Imag(1,k) = x3Imag(1,k);
    x3(1,k) = x3(1,secondLength + k);
    x3(1,secondLength + k) = tempX3(1,k);
    x3Imag(1,k) = x3Imag(1,secondLength + k);
    x3Imag(1,secondLength + k) = tempX3Imag(1,k);
    
    tempX3(1,k) = x3(1,k + thirdLength);
    tempX3Imag(1,k) = x3Imag(1,k + thirdLength);
    x3(1,k+thirdLength) = x3(1,k + fifthLength);
    x3(1,k + fifthLength) = tempX3(1,k);
    x3Imag(1,k + thirdLength) = x3Imag(1,k + fifthLength);
    x3Imag(1,k + fifthLength) = tempX3Imag(1,k);
end

%% 对称填补稀疏信号
% for k = 0:halfLength-1
%     x2(1,halfLength + k) = x2(1,halfLength - k);
%     x2Imag(1,halfLength + k) = x2Imag(1,halfLength - k);
%     x3(1,halfLength + k) = x3(1,halfLength - k);
%     x3Imag(1,halfLength + k) = x3Imag(1,halfLength - k);
% end

x11 = cos(pi/6)*x + cos(4*pi/9)*x2 + cos(3*pi/4)*x3;
x21 = sin(pi/6)*x + sin(4*pi/9)*x2 + sin(3*pi/4)*x3;
x11Imag = cos(pi/6)*xImag + cos(4*pi/9)*x2Imag + cos(3*pi/4)*x3Imag;
x21Imag = sin(pi/6)*xImag + sin(4*pi/9)*x2Imag + sin(3*pi/4)*x3Imag;

% figure,
% axis([0 20 -1 2]);
% plot(x,x11,'*');
% hold on;
% plot(x2,x11,'*');
% hold on;
% plot(x3,x11,'*');
% title('时域散点图');

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

A=[cos(pi/6) cos(4*pi/9) cos(3*pi/4);sin(pi/6) sin(4*pi/9) sin(3*pi/4)];

[row col] = size(S);
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

final1 = zeros(1,37500);final2 = zeros(1,37500);final3 = zeros(1,37500);

for j=1:sLength
    kt = abs(S(1,j)/S2(1,j));
    ktImag = abs(SImag(1,j)/S2Imag(1,j));
    
    kt1 = abs(kt-ai1);
    kt2 = abs(kt-ai2);
    kt3 = abs(kt-ai3);
    
    kt1Imag = abs(ktImag-ai1);
    kt2Imag = abs(ktImag-ai2);
    kt3Imag = abs(ktImag-ai3);
    
    if (kt1<kt2 && kt1<kt3)
        s1(1,j) = S(1,j)/A(1,1);
    elseif (kt2<kt1 && kt2<kt3) 
        s2(1,j) = S(1,j)/A(1,2);
    elseif (kt3<kt1 && kt3<kt2) 
        s3(1,j) = S(1,j)/A(1,3);
    end
    
    if (kt1Imag<kt2Imag && kt1Imag<kt3Imag)
        s1Imag(1,j) = SImag(1,j)/A(1,1);
    elseif (kt2Imag<kt1Imag && kt2Imag<kt3Imag) 
        s2Imag(1,j) = SImag(1,j)/A(1,2);
    elseif (kt3Imag<kt1Imag && kt3Imag<kt2Imag) 
        s3Imag(1,j) = SImag(1,j)/A(1,3);
    end
    
    final1(1,j) = s1(1,j) + s1Imag(1,j)*i;
    final2(1,j) = s2(1,j) + s2Imag(1,j)*i;
    final3(1,j) = s3(1,j) + s3Imag(1,j)*i;
    
end
%% 对s2和s3估计的信号进行移位恢复原来的模样
for k=1:firstLength
    tempSignal2(1,k) = final2(1,k);
    final2(1,k) = final2(1,firstLength + k);
    final2(1,firstLength + k) = tempSignal2(1,k);
    tempSignal22(1,k) = final2(1,k+fourthLength);
    final2(1,k+fourthLength) = final2(1,k+fifthLength);
    final2(1,k+fifthLength) = tempSignal22(1,k);
    
    tempSignal3(1,k) = final3(1,k);
    final3(1,k) = final3(1,secondLength + k);
    final3(1,secondLength + k) = tempSignal3(1,k);
    tempSignal32(1,k) = final3(1,k+thirdLength);
    final3(1,k+thirdLength) = final3(1,k+fifthLength);
    final3(1,k+fifthLength) = tempSignal32(1,k);
    
end
%% 对称填补稀疏信号
% for k = 0:halfLength-1
%     final2(1,halfLength + k) = final2(1,halfLength - k);
%     
%     final3(1,halfLength + k) = final3(1,halfLength - k);
%     
% end

ss1 = ifft(final1);
ss2 = ifft(final2);
ss3 = ifft(final3);

% figure,plot(y1);title('原信号s1');
% figure,plot(y2);title('原信号s2');
% figure,plot(y3);title('原信号s3');
figure,subplot(311),plot(y1);title('原信号s1');
subplot(312),plot(y2);title('原信号s2');
subplot(313),plot(y3);title('原信号s3');

%% 实部和虚部fft图像
% figure,subplot(211),plot(real(final1));title('估计信号s1实部fft');
% subplot(212),plot(mytest1);title('原信号s1实部fft');
% figure,subplot(211),plot(real(final2));title('估计信号s2实部fft');
% subplot(212),plot(mytest2);title('原信号s2实部fft');
% figure,subplot(211),plot(real(final3));title('估计信号s3实部fft');
% subplot(212),plot(mytest3);title('原信号s3实部fft');
% 
% figure,subplot(211),plot(imag(final1));title('估计信号s1虚部fft');
% subplot(212),plot(mytest1Imag);title('原信号s1虚部fft');
% figure,subplot(211),plot(imag(final2));title('估计信号s2虚部fft');
% subplot(212),plot(mytest2Imag);title('原信号s2虚部fft');
% figure,subplot(211),plot(imag(final3));title('估计信号s3虚部fft');
% subplot(212),plot(mytest3Imag);title('原信号s3虚部fft');

figure,subplot(311),plot(ss1),title('不填充恢复信号');
subplot(312),plot(ss2),
subplot(313),plot(ss3),

%% 采用ifft变换后的信号实部与原信号作比较，效果较好
figure,subplot(311),plot(real(ss1)),
subplot(312),plot(real(ss2)),
subplot(313),plot(real(ss3)),
            






















