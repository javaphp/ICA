clc;clear all;close all;
%% �������·���������ź�,ʹ��������������ǽⷽ����,�ɹ�
atanGate = 0; % �۲��ź�����������ֵ��δ��
areaCount = 200; %�۲�����������ֵ����Сֵ����������
areaNum = 50; %�۲��������ÿ��������������С��ֵ

n1=40;
window=boxcar(n1);
w1=window;

[y1,Fs,bits]=wavread('shengxia.wav');
% [y2,Fs2,bits]=wavread('media/gao.wav');
[y3,Fs,bits]=wavread('media/nv.wav');
[y2,Fs,bits]=wavread('yanhua.wav');
% [y3,Fs,bits]=wavread('huiyin.wav');
% [y2,Fs,bits]=wavread('niba.wav');

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

M = 10000;
N=50000;
% y1 = y1(1,M+1:N+M);
% y2 = y2(1,M+1:N+M);
% y3 = y3(1,M+1:N+M);
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

%% ����ԭ�ź�

A = zeros(2,3); %���Ľ�
signal = [x11;x21];
%signalImag = [x11Imag;x21Imag];

A=[cos(pi/6) cos(4*pi/9) cos(3*pi/4);sin(pi/6) sin(4*pi/9) sin(3*pi/4)];
a1Angle=atan2(A(2,1),A(1,1));
a2Angle=atan2(A(2,2),A(1,2));
a3Angle=atan2(A(2,3),A(1,3));
baseAngle=[a1Angle a2Angle a3Angle];

for j=1:3
    if(baseAngle(1,j)<0)
        baseAngle(1,j) = baseAngle(1,j) + 2*pi;
    end
end
baseCopy = baseAngle;
baseAnglePositive=baseAngle;   %�ѽǶ�ת��Ϊ0,2*pi��Χ��,atan2�ķ�Χ��-Pi��pi

Sreal1 = x11Real;
Simag1 = x11Imag;
Sreal2 = x21Real;
Simag2 = x21Imag;
[row col] = size(Sreal1);
sLength = row * col;

final1 = zeros(1,N);final2 = zeros(1,N);final3 = zeros(1,N);
real1 = zeros(1,N);real2 = zeros(1,N);real3 = zeros(1,N);
image1 = zeros(1,N);image2 = zeros(1,N);image3 = zeros(1,N);
recover1 = zeros(1,N);recover2 = zeros(1,N);recover3 = zeros(1,N);
x11Decode=zeros(1,N);x21Decode=zeros(1,N);   %ʹ�����·�������������

%��ÿһ��������·���ķ���
for j=1:N
    angles(1,j) = atan2(Sreal2(1,j),Sreal1(1,j));
    angles1=angles(1,j);   %��ʱ��
    %�Ѹõ�ĽǶ�ת��Ϊ0,2*pi
    if(angles1<0)
        angles1 = angles1 + 2*pi;
    end
    
    baseAnglePositive(4) = angles1;
    sorted_angle = sort(baseAnglePositive);
    index = 0;
    for n=1:4
        if(sorted_angle(n) == angles1)
            index = n;
            break;
        end
    end
    if(index == 1)
        index1 = 4; %˳ʱ��
        index2 = 2; %��ʱ��
    elseif(index == 4) 
        index1 = 3;
        index2 = 1;
    else
        index1 = index - 1;
        index2 = index + 1;
    end
    num1 = sorted_angle(index1);
    num2 = sorted_angle(index2);
    for p=1:3
        if(baseCopy(p) == num1)
            indexJ(1,j) = p;
        elseif(baseCopy(p) == num2)
            indexK(1,j) = p;
        end
    end
     
    %����Ԫһ�η���
    syms power1 power2
    switch indexJ(1,j)
        case 1
            switch indexK(1,j)
                case 2
                    w=[A(1,1) A(1,2);A(2,1) A(2,2)];
                    xf = [Sreal1(1,j);Sreal2(1,j)];
%                     decodeSignal = inv(w)*xf;
                    decodeSignal = w\xf;
                    real1(1,j) = decodeSignal(1,1);
                    real2(1,j) = decodeSignal(2,1);
                case 3
                    disp('���ǲ����ܵ���');
                    w=[A(1,1) A(1,3);A(2,1) A(2,3)];
                    xf = [Sreal1(1,j);Sreal2(1,j)];
%                     decodeSignal = inv(w)*xf;
                    decodeSignal = w\xf;
                    real1(1,j) = decodeSignal(1,1);
                    real3(1,j) = decodeSignal(2,1);
            end
            
        case 2
            switch indexK(1,j)
                case 1   %������?  ����֤��������
                    disp('���ǲ����ܵ���');
                    w=[A(1,1) A(1,2);A(2,1) A(2,2)];
                    xf = [Sreal1(1,j);Sreal2(1,j)];
%                     decodeSignal = inv(w)*xf;
                    decodeSignal = w\xf;
                    real1(1,j) = decodeSignal(1,1);
                    real2(1,j) = decodeSignal(2,1);
                case 3
                    w=[A(1,2) A(1,3);A(2,2) A(2,3)];
                    xf = [Sreal1(1,j);Sreal2(1,j)];
%                     decodeSignal = inv(w)*xf;
                    decodeSignal = w\xf;
                    real2(1,j) = decodeSignal(1,1);
                    real3(1,j) = decodeSignal(2,1);
            end
        case 3
            switch indexK(1,j)
                case 1     
%                     w=[A(1,3) A(1,1);A(2,3) A(2,1)];
%                     xf = [Sreal1(1,j);Sreal2(1,j)];
% %                     decodeSignal = inv(w)*xf;
%                     decodeSignal = w\xf;
%                     real3(1,j) = decodeSignal(1,1);
%                     real1(1,j) = decodeSignal(2,1);
                    w=[A(1,1) A(1,3);A(2,1) A(2,3)];
                    xf = [Sreal1(1,j);Sreal2(1,j)];
%                     decodeSignal = inv(w)*xf;
                    decodeSignal = w\xf;
                    real1(1,j) = decodeSignal(1,1);
                    real3(1,j) = decodeSignal(2,1);
                case 2    %������    ����֤��������
                    disp('���ǲ����ܵ���');
                    w=[A(1,2) A(1,3);A(2,2) A(2,3)];
                    xf = [Sreal1(1,j);Sreal2(1,j)];
                    decodeSignal = inv(w)*xf;
                    real3(1,j) = decodeSignal(1,1);
                    real2(1,j) = decodeSignal(2,1);
            end
    end
    
    %�鲿
    angles(1,j) = atan2(Simag2(1,j),Simag1(1,j));
    angles1=angles(1,j);   %��ʱ��
    %�Ѹõ�ĽǶ�ת��Ϊ0,2*pi
    if(angles1<0)
        angles1 = angles1 + 2*pi;
    end
    
    baseAnglePositive(4) = angles1;
    sorted_angle = sort(baseAnglePositive);
    index = 0;
    for n=1:4
        if(sorted_angle(n) == angles1)
            index = n;
            break;
        end
    end
    if(index == 1)
        index1 = 4;
        index2 = 2;
    elseif(index == 4) 
        index1 = 3;
        index2 = 1;
    else
        index1 = index - 1;
        index2 = index + 1;
    end
    num1 = sorted_angle(index1);
    num2 = sorted_angle(index2);
    for p=1:3
        if(baseCopy(p) == num1)
            indexJ(1,j) = p;
        elseif(baseCopy(p) == num2)
            indexK(1,j) = p;
        end
    end
     
    %����Ԫһ�η���
    syms power1 power2
    switch indexJ(1,j)
        case 1
            switch indexK(1,j)
                case 2
                    w=[A(1,1) A(1,2);A(2,1) A(2,2)];
                    xf = [Simag1(1,j);Simag2(1,j)];
%                     decodeSignal = inv(w)*xf;
                    decodeSignal = w\xf;
                    image1(1,j) = decodeSignal(1,1);
                    image2(1,j) = decodeSignal(2,1);
                case 3   
                    disp('���ǲ����ܵ���');
                    w=[A(1,1) A(1,3);A(2,1) A(2,3)];
                    xf = [Simag1(1,j);Simag2(1,j)];
%                     decodeSignal = inv(w)*xf;
                    decodeSignal = w\xf;
                    image1(1,j) = decodeSignal(1,1);
                    image3(1,j) = decodeSignal(2,1);
            end
            
        case 2
            switch indexK(1,j)
                case 1   %������   ����֤��������
                    disp('���ǲ����ܵ���');
                    w=[A(1,1) A(1,2);A(2,1) A(2,2)];
                    xf = [Simag1(1,j);Simag2(1,j)];
                    decodeSignal = inv(w)*xf;
                    image2(1,j) = decodeSignal(1,1);
                    image1(1,j) = decodeSignal(2,1);
                case 3
                    w=[A(1,2) A(1,3);A(2,2) A(2,3)];
                    xf = [Simag1(1,j);Simag2(1,j)];
%                     decodeSignal = inv(w)*xf;
                    decodeSignal = w\xf;
                    image2(1,j) = decodeSignal(1,1);
                    image3(1,j) = decodeSignal(2,1);
            end
        case 3
            switch indexK(1,j)
                case 1
                    w=[A(1,1) A(1,3);A(2,1) A(2,3)];
                    xf = [Simag1(1,j);Simag2(1,j)];
%                     decodeSignal = inv(w)*xf;
                    decodeSignal = w\xf;
                    image1(1,j) = decodeSignal(1,1);
                    image3(1,j) = decodeSignal(2,1);
                case 2    %������    ����֤��������
                    disp('���ǲ����ܵ���');
                    w=[A(1,2) A(1,3);A(2,2) A(2,3)];
                    xf = [Simag2(1,j);Simag1(1,j)];
                    decodeSignal = inv(w)*xf;
                    image3(1,j) = decodeSignal(1,1);
                    image2(1,j) = decodeSignal(2,1);
            end
    end
    j
end
for j=1:N
    recover1(1,j) = real1(1,j) + image1(1,j) * i;
    recover2(1,j) = real2(1,j) + image2(1,j) * i;
    recover3(1,j) = real3(1,j) + image3(1,j) * i;
end

figure,subplot(311),plot(real1);title('�ָ���ʵ��1');
subplot(312),plot(real2);title('�ָ���ʵ��2');
subplot(313),plot(real3);title('�ָ���ʵ��3');

figure,subplot(311),plot(image1);title('�ָ����鲿1');
subplot(312),plot(image2);title('�ָ����鲿2');
subplot(313),plot(image3);title('�ָ����鲿3');

figure,subplot(311),plot(real(fft(y1))),title('ԭ�ź�ʵ��')
subplot(312),plot(real(fft(y2))),title('ԭ�ź�ʵ��')
subplot(313),plot(real(fft(y3))),title('ԭ�ź�ʵ��')

figure,subplot(311),plot(imag(fft(y1))),title('ԭ�ź��鲿')
subplot(312),plot(imag(fft(y2))),title('ԭ�ź��鲿')
subplot(313),plot(imag(fft(y3))),title('ԭ�ź��鲿')

final1 = ifft(recover1);
final2 = ifft(recover2);
final3 = ifft(recover3);

figure,subplot(311),plot(y1),title('ԭ�ź�');
subplot(312),plot(y2);
subplot(313),plot(y3);

figure,subplot(311),plot(real(final1)),axis([0 N -0.5 0.5]);title('�ָ����ź�');
subplot(312),plot(real(final2));axis([0 N -0.2 0.2]);
subplot(313),plot(real(final3));axis([0 N -0.2 0.2]);

% figure,subplot(311),plot(real(final1));title('�ָ����ź�');
% subplot(312),plot(real(final2));
% subplot(313),plot(real(final3));

%% �Ÿɱ�
originSquare = 0;
minusSquare = 0;

for k = 1:N
    originSquare = originSquare + originSource1(1,k)^2;
    originSquare = originSquare + originSource2(1,k)^2;
    originSquare = originSquare + originSource3(1,k)^2;
    minusSquare = minusSquare + (real(recover1(1,k))-originSource1(1,k))^2;
    minusSquare = minusSquare + (real(recover2(1,k))-originSource2(1,k))^2;
    minusSquare = minusSquare + (real(recover3(1,k))-originSource3(1,k))^2;
end
originSquare = originSquare/3;
minusSquare = minusSquare/3;
SIR_before = originSquare/minusSquare




