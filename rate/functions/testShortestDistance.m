clc;clear all;close all;
%% �������·���������ź�
atanGate = 0; % �۲��ź�����������ֵ��δ��
areaCount = 200; %�۲�����������ֵ����Сֵ����������
areaNum = 50; %�۲��������ÿ��������������С��ֵ

n1=40;
window=boxcar(n1);
w1=window;

[y1,Fs,bits]=wavread('shengxia.wav');
% [y2,Fs2,bits]=wavread('media/gao.wav');
% [y3,Fs,bits]=wavread('media/nv.wav');
[y3,Fs,bits]=wavread('yanhua.wav');
% [y3,Fs,bits]=wavread('huiyin.wav');
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

N=10000;
y1 = y1(1,20000:N+20000);
y2 = y2(1,20000:N+20000);
y3 = y3(1,20000:N+20000);
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
baseAnglePositive=baseAngle;   %�ѽǶ�ת��Ϊ0,2*pi��Χ��,atan2�ķ�Χ��-Pi��pi
baseAngleNegative=baseAngle;   %�ѽǶ�ת��Ϊ-2*pi,0��Χ��,atan2�ķ�Χ��-Pi��pi
for j=1:3
    if(baseAngle(1,j)<0)
        baseAnglePositive(1,j) = 2*pi + baseAngle(1,j);
    end
    if(baseAngle(1,j)>0)
        baseAngleNegative(1,j) = baseAngle(1,j) - 2*pi;
    end
end
baseCopy = baseAnglePositive;

% baseAngleOpposite = [a1Angle-2*pi a2Angle-2*pi a3Angle-2*pi];
% Sreal1 = real(x11);
% Simag1 = imag(x11);
% Sreal2 = real(x21);
% Simag2 = imag(x21);
Sreal1 = x11Real;
Simag1 = x11Imag;
Sreal2 = x21Real;
Simag2 = x21Imag;
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

signAi1 = A(1,1)/A(2,1);
signAi2 = A(1,2)/A(2,2);
signAi3 = A(1,3)/A(2,3);

final1 = zeros(1,N);final2 = zeros(1,N);final3 = zeros(1,N);
real1 = zeros(1,N);real2 = zeros(1,N);real3 = zeros(1,N);
image1 = zeros(1,N);image2 = zeros(1,N);image3 = zeros(1,N);
recover1 = zeros(1,N);recover2 = zeros(1,N);recover3 = zeros(1,N);
x11Decode=zeros(1,N);x21Decode=zeros(1,N);   %ʹ�����·�������������

%��ÿһ��������·���ķ���
for j=1:N
    angles(1,j) = atan2(Sreal2(1,j),Sreal1(1,j));
    angles1=angles(1,j);   %��ʱ��
    if(angles(1,j)<0) 
        angles1 = 2*pi+angles(1,j);   %�Ѹõ�ĽǶ�ת��Ϊ0,2*pi
    elseif(angles(1,j)>0)
        angles2 = angles(1,j) - 2*pi;     %�Ѹõ�ĽǶ�ת��Ϊ-2*pi,0
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
                    s=solve('power1*A(1,1)+power2*A(1,2)=Sreal1(1,j)','power1*A(2,1)+power2*A(2,2)=Sreal2(1,j)');
                    real1(1,j) = eval(s.power1)*A(1,1);
                    real2(1,j) = eval(s.power2)*A(1,2);
                case 3
                    s=solve('power1*A(1,1)+power2*A(1,3)=Sreal1(1,j)','power1*A(2,1)+power2*A(2,3)=Sreal2(1,j)');
                    real1(1,j) = eval(s.power1)*A(1,1);
                    real3(1,j) = eval(s.power2)*A(1,3);
            end
            
        case 2
            switch indexK(1,j)
                case 1
                    s=solve('power1*A(1,2)+power2*A(1,1)=Sreal1(1,j)','power1*A(2,2)+power2*A(2,1)=Sreal2(1,j)');
                    real2(1,j) = eval(s.power1)*A(1,2);
                    real1(1,j) = eval(s.power2)*A(1,1);
                case 3
                    s=solve('power1*A(1,2)+power2*A(1,3)=Sreal1(1,j)','power1*A(2,2)+power2*A(2,3)=Sreal2(1,j)');
                    real2(1,j) = eval(s.power1)*A(1,2);
                    real3(1,j) = eval(s.power2)*A(1,3);
            end
        case 3
            switch indexK(1,j)
                case 1
                    s=solve('power1*A(1,3)+power2*A(1,1)=Sreal1(1,j)','power1*A(2,3)+power2*A(2,1)=Sreal2(1,j)');
                    real3(1,j) = eval(s.power1)*A(1,3);
                    real1(1,j) = eval(s.power2)*A(1,1);
                case 2
                    s=solve('power1*A(1,3)+power2*A(1,2)=Sreal1(1,j)','power1*A(2,3)+power2*A(2,2)=Sreal2(1,j)');
                    real3(1,j) = eval(s.power1)*A(1,3);
                    real2(1,j) = eval(s.power2)*A(1,2);
            end
    end
    
    %�鲿
    angles(1,j) = atan2(Simag2(1,j),Simag1(1,j));
    angles1=angles(1,j);   %��ʱ��
    if(angles(1,j)<0) 
        angles1 = 2*pi+angles(1,j);   %�Ѹõ�ĽǶ�ת��Ϊ0,2*pi
    elseif(angles(1,j)>0)
        angles2 = angles(1,j) - 2*pi;     %�Ѹõ�ĽǶ�ת��Ϊ-2*pi,0
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
                    s=solve('power1*A(1,1)+power2*A(1,2)=Simag1(1,j)','power1*A(2,1)+power2*A(2,2)=Simag2(1,j)');
                    image1(1,j) = eval(s.power1)*A(1,1);
                    image2(1,j) = eval(s.power2)*A(1,2);
                case 3
                    s=solve('power1*A(1,1)+power2*A(1,3)=Simag1(1,j)','power1*A(2,1)+power2*A(2,3)=Simag2(1,j)');
                    image1(1,j) = eval(s.power1)*A(1,1);
                    image3(1,j) = eval(s.power2)*A(1,3);
            end
            
            
        case 2
            switch indexK(1,j)
                case 1
                    s=solve('power1*A(1,2)+power2*A(1,1)=Simag1(1,j)','power1*A(2,2)+power2*A(2,1)=Simag2(1,j)');
                    image2(1,j) = eval(s.power1)*A(1,2);
                    image1(1,j) = eval(s.power2)*A(1,1);
                case 3
                    s=solve('power1*A(1,2)+power2*A(1,3)=Simag1(1,j)','power1*A(2,2)+power2*A(2,3)=Simag2(1,j)');
                    image2(1,j) = eval(s.power1)*A(1,2);
                    image3(1,j) = eval(s.power2)*A(1,3);
            end
        case 3
            switch indexK(1,j)
                case 1
                    s=solve('power1*A(1,3)+power2*A(1,1)=Simag1(1,j)','power1*A(2,3)+power2*A(2,1)=Simag2(1,j)');
                    image3(1,j) = eval(s.power1)*A(1,3);
                    image1(1,j) = eval(s.power2)*A(1,1);
                case 2
                    s=solve('power1*A(1,3)+power2*A(1,2)=Simag1(1,j)','power1*A(2,3)+power2*A(2,2)=Simag2(1,j)');
                    image3(1,j) = eval(s.power1)*A(1,3);
                    image2(1,j) = eval(s.power2)*A(1,2);
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

final1 = ifft(recover1);
final2 = ifft(recover2);
final3 = ifft(recover3);

figure,subplot(311),plot(y1),title('ԭ�ź�');
subplot(312),plot(y2);
subplot(313),plot(y3);

figure,subplot(311),plot(real(final1)),axis([0 25000 -0.2 0.2]);title('�ָ����ź�');
subplot(312),plot(real(final2));axis([0 25000 -1 1]);
subplot(313),plot(real(final3));axis([0 25000 -0.2 0.2]);

% figure,subplot(311),plot(real(final1));title('�ָ����ź�');
% subplot(312),plot(real(final2));
% subplot(313),plot(real(final3));




