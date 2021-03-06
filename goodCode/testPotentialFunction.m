clc;clear all;close all;
%% 三个信号混合，原来角度为30 80 135，采用势函数进行估计，完美估计出三个信号斜率，成功

n1=40;
window=boxcar(n1);
w1=window;

[y1,Fs,bits]=wavread('shengxia.wav');
[y3,Fs,bits]=wavread('yanhua.wav');
[y2,Fs,bits]=wavread('niba.wav');
% [y3,Fs,bits]=wavread('wang.wav');
y1 = y1(:,1);
y2 = y2(:,1);
y3 = y3(:,1);
% y4 = y4(:,1);
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
% [row col] = size(y4);
% y4 = reshape(y4,1,row*col);

N = 70000;

x=y1(1:N);
x2 = y2(1:N);
x3 = y3(1:N);
% x4 = y4(1:N);
% x11 = 0.866*x + 0.1736*x2 - 0.1736*x3 - 0.9396*x4;
% x21 = 0.5*x + 0.9848*x2 + 0.9848*x3 + 0.342*x4;
x11 = cos(pi/6)*x + cos(4*pi/9)*x2 + cos(3*pi/4)*x3;
x21 = sin(pi/6)*x + sin(4*pi/9)*x2 + sin(3*pi/4)*x3;
figure,
axis([0 20 -1 2]);
plot(x11,x21,'*');
title('时域散点图');

s11 = fft(x11);
s21 = fft(x21);
s11Real = real(s11);
s11Imag = imag(s11);
s21Real = real(s21);
s21Imag = imag(s21);

figure,plot(s11Real,s21Real,'*');title('频域散点图');

%% 聚类判断方法，基于势函数
[row col] = size(s11);
length = row*col;
index = 1;

%% 把0到2*pi的点映射到0到pi
for j=1:length
    if(s11Real(1,j)>0 && s21Real(1,j)<0)    %第四象限点
        s11Real(1,j) = -s11Real(1,j);
        s21Real(1,j) = -s21Real(1,j);
    elseif(s11Real(1,j)<0 && s21Real(1,j)<0)   %第三象限点
        s11Real(1,j) = -s11Real(1,j);
        s21Real(1,j) = -s21Real(1,j);
    end
end
figure,plot(s11Real,s21Real,'*');title('映射后的频域散点图');
count = 0;    %符合条件的个数
c=25;       %权重wi门限，小于该值则wi=0
for k=0:pi/180:pi     %范围是0到pi
    sum = 0;k    %求和中间统计量
    for j=1:60000
        wi = s11Real(1,j)^2 + s21Real(1,j)^2;   %权重
        w(1,j) = wi;
        temp = -abs(2.25*(atan2(s21Real(1,j),s11Real(1,j))-k));
        if(wi>c && (-temp < pi/4))   %论文要求的要小于pi/4
            fi = exp(temp);
            potential(1,index) = sum + wi*fi;
            sum = potential(1,index);
            count = count + 1;
        end
    end
    index = index + 1;
end
count
figure,plot(potential);title('势函数图像');hold on;
%% 计算极大值位置
maxIndex = find(diff(sign(diff(potential)))==-2)+1;
[maxRow maxCol] = size(maxIndex);
for i=1:maxCol
    plot(maxIndex(1,i),potential(1,maxIndex(1,i)),'ko')%标出空心点
    hold on;
end


%% 细分
% index = 1;
% count = 0;    %符合条件的个数
% c=25;       %权重wi门限，小于该值则wi=0
% for k=32*pi/180:pi/250:119*pi/180     %范围是0到pi
%     sum = 0;k    %求和中间统计量
%     for j=1:60000
%         wi = s11Real(1,j)^2 + s21Real(1,j)^2;   %权重
%         w(1,j) = wi;
%         temp = -abs(1*(atan2(s21Real(1,j),s11Real(1,j))-k));
%         if(wi>c && (-temp < pi/4))   %论文要求的要小于pi/4
%             fi = exp(temp);
%             potential2(1,index) = sum + wi*fi;
%             sum = potential2(1,index);
%             count = count + 1;
%         end
%     end
%     index = index + 1;
% end
% count
% figure,plot(potential2);title('势函数图像');hold on;
% %% 计算极大值位置
% maxIndex1 = find(diff(sign(diff(potential2)))==-2)+1;
% [maxRow maxCol] = size(maxIndex1);
% for i=1:maxCol
%     plot(maxIndex1(1,i),potential2(1,maxIndex1(1,i)),'ko')%标出空心点
%     hold on;
% end





















