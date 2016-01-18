clc;clear all;close all;
%% �����źŻ�ϣ�ԭ���Ƕ�Ϊ30 80 135�������ƺ������й��ƣ��������Ƴ������ź�б�ʣ��ɹ�

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
title('ʱ��ɢ��ͼ');

s11 = fft(x11);
s21 = fft(x21);
s11Real = real(s11);
s11Imag = imag(s11);
s21Real = real(s21);
s21Imag = imag(s21);

figure,plot(s11Real,s21Real,'*');title('Ƶ��ɢ��ͼ');

%% �����жϷ����������ƺ���
[row col] = size(s11);
length = row*col;
index = 1;

%% ��0��2*pi�ĵ�ӳ�䵽0��pi
for j=1:length
    if(s11Real(1,j)>0 && s21Real(1,j)<0)    %�������޵�
        s11Real(1,j) = -s11Real(1,j);
        s21Real(1,j) = -s21Real(1,j);
    elseif(s11Real(1,j)<0 && s21Real(1,j)<0)   %�������޵�
        s11Real(1,j) = -s11Real(1,j);
        s21Real(1,j) = -s21Real(1,j);
    end
end
figure,plot(s11Real,s21Real,'*');title('ӳ����Ƶ��ɢ��ͼ');
count = 0;    %���������ĸ���
c=25;       %Ȩ��wi���ޣ�С�ڸ�ֵ��wi=0
for k=0:pi/180:pi     %��Χ��0��pi
    sum = 0;k    %����м�ͳ����
    for j=1:60000
        wi = s11Real(1,j)^2 + s21Real(1,j)^2;   %Ȩ��
        w(1,j) = wi;
        temp = -abs(2.25*(atan2(s21Real(1,j),s11Real(1,j))-k));
        if(wi>c && (-temp < pi/4))   %����Ҫ���ҪС��pi/4
            fi = exp(temp);
            potential(1,index) = sum + wi*fi;
            sum = potential(1,index);
            count = count + 1;
        end
    end
    index = index + 1;
end
count
figure,plot(potential);title('�ƺ���ͼ��');hold on;
%% ���㼫��ֵλ��
maxIndex = find(diff(sign(diff(potential)))==-2)+1;
[maxRow maxCol] = size(maxIndex);
for i=1:maxCol
    plot(maxIndex(1,i),potential(1,maxIndex(1,i)),'ko')%������ĵ�
    hold on;
end


%% ϸ��
% index = 1;
% count = 0;    %���������ĸ���
% c=25;       %Ȩ��wi���ޣ�С�ڸ�ֵ��wi=0
% for k=32*pi/180:pi/250:119*pi/180     %��Χ��0��pi
%     sum = 0;k    %����м�ͳ����
%     for j=1:60000
%         wi = s11Real(1,j)^2 + s21Real(1,j)^2;   %Ȩ��
%         w(1,j) = wi;
%         temp = -abs(1*(atan2(s21Real(1,j),s11Real(1,j))-k));
%         if(wi>c && (-temp < pi/4))   %����Ҫ���ҪС��pi/4
%             fi = exp(temp);
%             potential2(1,index) = sum + wi*fi;
%             sum = potential2(1,index);
%             count = count + 1;
%         end
%     end
%     index = index + 1;
% end
% count
% figure,plot(potential2);title('�ƺ���ͼ��');hold on;
% %% ���㼫��ֵλ��
% maxIndex1 = find(diff(sign(diff(potential2)))==-2)+1;
% [maxRow maxCol] = size(maxIndex1);
% for i=1:maxCol
%     plot(maxIndex1(1,i),potential2(1,maxIndex1(1,i)),'ko')%������ĵ�
%     hold on;
% end




















