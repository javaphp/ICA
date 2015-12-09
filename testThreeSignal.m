clc;clear all;close all;
%% �����źŻ�ϣ�ԭ���Ƕ�Ϊ30 80 135�����ƵĽǶ�Ϊ30 80 130���ɹ�

n1=40;
window=boxcar(n1);
w1=window;

[y1,Fs,bits]=wavread('shengxia.wav');
[y2,Fs,bits]=wavread('yanhua.wav');
[y3,Fs,bits]=wavread('niba.wav');
[y4,Fs,bits]=wavread('wang.wav');
y1 = y1(:,1);
y2 = y2(:,1);
y3 = y3(:,1);
y4 = y4(:,1);
% figure,
% plot(y2);
% figure,
% plot(y1);

[row col] = size(y1);
y1 = reshape(y1,1,row*col);
[row col] = size(y2);
y2 = reshape(y2,1,row*col);
[row col] = size(y3);
y3 = reshape(y3,1,row*col);
[row col] = size(y4);
y4 = reshape(y4,1,row*col);

x=y1(1:51000);
x2 = y2(1:51000);
x3 = y3(1:51000);
x4 = y4(1:51000);
% x11 = 0.866*x + 0.1736*x2 - 0.1736*x3 - 0.9396*x4;
% x21 = 0.5*x + 0.9848*x2 + 0.9848*x3 + 0.342*x4;
x11 = cos(pi/6)*x + cos(4*pi/9)*x2 + cos(3*pi/4)*x3;
x21 = sin(pi/6)*x + sin(4*pi/9)*x2 + sin(3*pi/4)*x3;
figure,
axis([0 20 -1 2]);
plot(x,x11,'*');
title('ʱ��ɢ��ͼ');

t=1:length(x);
n=length(x);

[S,F,T,P]=spectrogram(x11,w1,32,256);  %SΪ��������ʱ����Ҷ�任��Ľ��


t2=1:length(x2);
n2=length(x2);
[S2,F,T,P]=spectrogram(x21,w1,32,256);  %SΪ��������ʱ����Ҷ�任��Ľ��

% figure,
% plot(real(S),real(S2),'*');

%% �����жϷ����������ƺ���
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
    f(1,x) = 0;
    y = x/10;
    for i=1:length
        temp = f(1,x);
        a = -abs(10*(angle1(1,i)-y));
        f(1,x) = distance(1,i)*exp(a);
        f(1,x) = f(1,x) + temp;
    end
end
figure
z=10:10:1000
plot(z-180,f(1,z/10));
hold on %���ֵ�ǰͼ��

%axis([-200 370 0 15000]);
title('�ƺ���ͼ��');

%% ���㼫��ֵλ��
maxIndex = find(diff(sign(diff(f)))==-2)+1;
[maxRow maxCol] = size(maxIndex);
for i=1:maxCol
    plot(maxIndex(1,i)*10-180,f(1,maxIndex(1,i)),'ko')%������ĵ�
    hold on;
end


%% ��ʼ����ԭ�ź�
A = zeros(2,3); %���Ľ�
signal = [x11;x21];
% for i=1:maxCol
%     myAngle = (maxIndex(1,i)*10-180)*pi/180;
%     A(:,i) = [cos(myAngle);sin(myAngle)];
% end

A=[cos(pi/6) cos(4*pi/9) cos(3*pi/4);sin(pi/6) sin(4*pi/9) sin(3*pi/4)];

for k=1:3
    [value index] = max(abs(signal)/(A(:,k)'*A(:,k)))
end
% for i=1:51000
%     switch(index(i))
%         case 1
%             s1 = x11/(A(:,1)'*A(:,1));
%         case 2
%             s2 = x21/(A(:,2)'*A(:,2));
%         case 3
%             s3 = x11/(A(:,3)'*A(:,3));
%     end
% end

s1 = zeros(1,51000);
s2 = zeros(1,51000);
s3 = zeros(1,51000);
for i=1:51000
    switch(index(1,i))
        case 1
            s1(1,i) = x11(1,i)/A(1,1);
        case 2
            s2(1,i) = x11(1,i)/A(1,2);
        case 3
            s3(1,i) = x11(1,i)/A(1,3);
    end
end

figure,plot(y1(1:51000));title('ԭ�ź�s1');
figure,plot(y2(1:51000));title('ԭ�ź�s2');
figure,plot(y3(1:51000));title('ԭ�ź�s3');

figure,plot(s1);title('�����ź�s1');
figure,plot(s2);title('�����ź�s2');
figure,plot(s3);title('�����ź�s3');

            






















