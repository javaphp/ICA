clc;clear all;close all;
%% ͨ������ֱ�߸��������ƻ�Ͼ���
atanGate = 0; % �۲��ź�����������ֵ��δ��
areaCount = 200; %�۲�����������ֵ����Сֵ����������
areaNum = 50; %�۲��������ÿ��������������С��ֵ

n1=40;
window=boxcar(n1);
w1=window;

[y1,Fs,bits]=wavread('shengxia.wav');
%[y2,Fs2,bits]=wavread('media/gao.wav');
%[y3,Fs,bits]=wavread('media/nv.wav');
[y3,Fs,bits]=wavread('yanhua.wav');
%[y3,Fs,bits]=wavread('huiyin.wav');
[y2,Fs,bits]=wavread('niba.wav');

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

N=50000;
y1 = y1(1,1:N);
y2 = y2(1,1:N);
y3 = y3(1,1:N);
originSource1 = y1;
originSource2 = y2;
originSource3 = y3;

x11 = cos(pi/6)*y1 + cos(4*pi/9)*y2 + cos(3*pi/4)*y3;
x21 = sin(pi/6)*y1 + sin(4*pi/9)*y2 + sin(3*pi/4)*y3;

x11 = fft(x11);
x21 = fft(x21);
x11Real = real(x11);
x21Real = real(x21);
x11Imag = imag(x11);
x21Imag = imag(x21);

figure,plot(real(x11),real(x21),'*');title('ʵ��');
figure,plot(imag(x11),imag(x21),'*');title('�鲿');

%% ͳ�Ƹ����޵�ĸ���
quadrant1Points = zeros(2,N);quadrant2Points = zeros(2,N);
quadrant3Points = zeros(2,N);quadrant4Points = zeros(2,N);     %�����޵���ϸ��,���������ʽ����һ����x11

quadrant1 = 0;quadrant2 = 0;
quadrant3 = 0;quadrant4 = 0;
for j=1:N
    if(x11Real(1,j)>0 && x21Real(1,j)>0)
        quadrant1 = quadrant1 + 1;
        quadrant1Points(1,j) = x11Real(1,j);
        quadrant1Points(2,j) = x21Real(1,j);
    elseif(x11Real(1,j)<0 && x21Real(1,j)>0)
        quadrant2 = quadrant2 + 1;
        quadrant2Points(1,j) = x11Real(1,j);
        quadrant2Points(2,j) = x21Real(1,j);
    elseif(x11Real(1,j)<0 && x21Real(1,j)<0)
        quadrant3 = quadrant3 + 1;
        quadrant3Points(1,j) = x11Real(1,j);
        quadrant3Points(2,j) = x21Real(1,j);
    elseif(x11Real(1,j)>0 && x21Real(1,j)<0)
        quadrant4 = quadrant4 + 1;
        quadrant4Points(1,j) = x11Real(1,j);
        quadrant4Points(2,j) = x21Real(1,j);
    end
end
% quadrant1
% quadrant2
% quadrant3
% quadrant4
% allCount = quadrant1 + quadrant2 + quadrant3 + quadrant4

if((quadrant1 - quadrant2)>0)
    lineRate = min(quadrant1,quadrant3)/max(quadrant2,quadrant4);    %1  3��2  4���޹��Ƶ����ޱ�
    flag1 = true;    %��ʾһ�����޵ĵ����ȶ������޶࣬false���෴
else 
    lineRate = min(quadrant2,quadrant4)/max(quadrant1,quadrant3);    %1  3��2  4���޹��Ƶ����ޱ�
    flag1 = false;
end
if(lineRate<1)
    lineRate = ceil(1/lineRate);
else
    lineRate = ceil(lineRate);
end
lineRate

%���ٵ����޵ĵ����ֱ�߸����Ĺ���,ʵ��֤����ʹ������رȷ����ж�׼ȷһЩ�����ԸĽ�����������
angleTemp = zeros(1,N);
for j=1:N
    if(flag1)
        angleTemp(1,j) = atan2(quadrant2Points(2,j),quadrant2Points(1,j));
    else
        angleTemp(1,j) = atan2(quadrant1Points(2,j),quadrant1Points(1,j));
    end
end
variance = var(angleTemp)    %����
[a,b]=xcorr(angleTemp,'unbiased');
figure,plot(b,a);title('�����');         %�����

% for j=1:N
%     angleTemp2(1,j) = atan2(quadrant1Points(2,j),quadrant1Points(1,j));
% end
% variance = var(angleTemp2)    %����
% [a,b]=xcorr(angleTemp2,'unbiased');
% figure,plot(b,a);title('�����');         %�����

%������϶�����޸�ֱ��б��
k=1;
for j=1:N
    if(quadrant1Points(1,j)~=0)
        angles(1,k) = atan2(quadrant1Points(2,j),quadrant1Points(1,j));
        k=k+1;
    end
end
maxAngle = max(angles);minAngle = min(angles);
% meanAngle = mean(angles);    ֱ����ƽ��б��Ч������
meanAngle = (maxAngle + minAngle)/2;
[row col] = size(angles);
index1 = 1;index2 = 1;    %��������±�
for j=1:(row*col)
    if(angles(1,j)>meanAngle)
        line1(1,index1) = angles(1,j);
        index1 = index1 + 1;
    else
        line2(1,index2) = angles(1,j);
        index2 = index2 + 1;
    end
end
meanLine1 = mean(line1)
meanLine2 = mean(line2)

%% ���Զ�����б�����ֵ��Сֵƽ��ֵ
% k=1;
% for j=1:N
%     if(quadrant2Points(1,j)~=0)
%         angles2(1,k) = atan2(quadrant2Points(2,j),quadrant2Points(1,j));
%         k=k+1;
%     end
% end
% mean2 = mean(angles2)
% min2 = min(angles2)
% max2 = max(angles2)

%�Ÿɱ�
% originSquare = 0;
% minusSquare = 0;
% 
% for k = 1:N
%     originSquare = originSquare + originSource1(1,k)^2;
%     originSquare = originSquare + originSource2(1,k)^2;
%     originSquare = originSquare + originSource3(1,k)^2;
%     minusSquare = minusSquare + (real(recover1(1,k))-originSource1(1,k))^2;
%     minusSquare = minusSquare + (real(recover2(1,k))-originSource2(1,k))^2;
%     minusSquare = minusSquare + (real(recover3(1,k))-originSource3(1,k))^2;
% end
% originSquare = originSquare/3;
% minusSquare = minusSquare/3;
% SIR_after = originSquare/minusSquare
            






