clc;clear all;close all;
%% ���ñ��ʾ�������Ƿ��äԴ����,�����ݽ��з��飬������ֵ���鱣�������⣬�����ݷ��飬����ֱ����ϣ����еĵ�������ֱ�ߵĵ���������
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

[x11Row x11Col] = size(x11);
[x21Row x121Col] = size(x21);
for j=1:x11Row
    for k=1:x11Col
        atanReal(j,k) = atan(x21Real(j,k)/x11Real(j,k));
        atanImag(j,k) = atan(x21Imag(j,k)/x11Imag(j,k));
    end
end
realMin = min(atanReal(:));
realMax = max(atanReal(:));
imagMin = min(atanImag(:));
imagMax = max(atanImag(:));

areaLengthReal = (realMax - realMin)/areaCount;
areaLengthImag = (imagMax - imagMin)/areaCount;

areaRealDetail = zeros(areaCount,2);   %ʵ���������Ҷ˵���ɵľ���
areaImagDetail = zeros(areaCount,2);   %�鲿�������Ҷ˵���ɵľ���
tempRealLeft = realMin;
tempImagLeft = imagMin;
for j=1:areaCount
    areaRealDetail(j,1) = tempRealLeft; %������˵�
    areaRealDetail(j,2) = areaRealDetail(j,1) + areaLengthReal;  %�����Ҷ˵�
    tempRealLeft = areaRealDetail(j,2);
    
    areaImagDetail(j,1) = tempImagLeft; %������˵�
    areaImagDetail(j,2) = areaImagDetail(j,1) + areaLengthImag;  %�����Ҷ˵�
    tempImagLeft = areaImagDetail(j,2);
end
indexReal = zeros(1,areaCount);
indexImag = zeros(1,areaCount);
for m=1:areaCount
    for j=1:x11Row
        for k=1:x11Col
            if(atanReal(j,k)>=areaRealDetail(m,1) && atanReal(j,k)<areaRealDetail(m,2))
                indexReal(1,m) = indexImag(1,m) + 1;             %����ʵ������������Ŀ
            end
            
            if(atanImag(j,k)>=areaImagDetail(m,1) && atanImag(j,k)<areaImagDetail(m,2))
                indexImag(1,m) = indexImag(1,m) + 1;             %�����鲿����������Ŀ
            end
        end
    end
end
for m=1:areaCount
    if(indexReal(1,m)<areaNum)
        for j=1:x11Row
            for k=1:x11Col
                if(atanReal(j,k)>=areaRealDetail(m,1) && atanReal(j,k)<areaRealDetail(m,2))
                    x11Real(j,k) = 0;             %�Ѳ�������������ԭ���ݻ�Ϊ0
                    x21Real(j,k) = 0;
                end
            end
        end
    end
    
    if(indexImag(1,m)<areaNum)
        for j=1:x11Row
            for k=1:x11Col
                if(atanImag(j,k)>=areaImagDetail(m,1) && atanImag(j,k)<areaImagDetail(m,2))
                    x11Imag(j,k) = 0;             %�Ѳ�������������ԭ���ݻ�Ϊ0
                    x21Imag(j,k) = 0;
                end
            end
        end
    end
end

figure,plot(real(x11),real(x21),'*');title('ʵ��');
figure,plot(imag(x11),imag(x21),'*');title('�鲿');

%% ����ԭ�ź�
A = zeros(2,3); %���Ľ�
signal = [x11;x21];
%signalImag = [x11Imag;x21Imag];

A=[cos(pi/6) cos(4*pi/9) cos(3*pi/4);sin(pi/6) sin(4*pi/9) sin(3*pi/4)];
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
lineReal11 = zeros(1,N);lineReal12 = zeros(1,N);lineReal13 = zeros(1,N);
lineReal21 = zeros(1,N);lineReal22 = zeros(1,N);lineReal23 = zeros(1,N);
lineImag11 = zeros(1,N);lineImag12 = zeros(1,N);lineImag13 = zeros(1,N);
lineImag21 = zeros(1,N);lineImag22 = zeros(1,N);lineImag23 = zeros(1,N);

for j=1:sLength
    kt = abs(Sreal1(1,j)/Sreal2(1,j));
    ktImag = abs(Simag1(1,j)/Simag2(1,j));
    
    signReal = Sreal1(1,j)/Sreal2(1,j);
    signImag = Simag1(1,j)/Simag2(1,j);
    
    kt1 = abs(kt-ai1);
    kt2 = abs(kt-ai2);
    kt3 = abs(kt-ai3);
    
    kt1Imag = abs(ktImag-ai1);
    kt2Imag = abs(ktImag-ai2);
    kt3Imag = abs(ktImag-ai3);
    
    if(Sreal2(1,j) ~= 0)
        if (kt1<kt2 && kt1<kt3 && signReal/signAi1>0)
            s1(1,j) = Sreal1(1,j)/A(1,1);
            lineReal11(1,j) = x11Real(1,j);
            lineReal21(1,j) = x21Real(1,j);
        elseif (kt2<kt1 && kt2<kt3 && signReal/signAi2>0) 
            s2(1,j) = Sreal1(1,j)/A(1,2);
            lineReal12(1,j) = x11Real(1,j);
            lineReal22(1,j) = x21Real(1,j);
        elseif (kt3<kt1 && kt3<kt2 && signReal/signAi3>0)  
            s3(1,j) = Sreal1(1,j)/A(1,3);
            lineReal13(1,j) = x11Real(1,j);
            lineReal23(1,j) = x21Real(1,j);
        end
    end
    
    if(Simag2(1,j) ~= 0)
        if (kt1Imag<kt2Imag && kt1Imag<kt3Imag && signImag/signAi1>0)
            s1Imag(1,j) = Simag1(1,j)/A(1,1);
            lineImag11(1,j) = Simag1(1,j);
            lineImag21(1,j) = Simag2(1,j);
        elseif (kt2Imag<kt1Imag && kt2Imag<kt3Imag && signImag/signAi2>0) 
            s2Imag(1,j) = Simag1(1,j)/A(1,2);
            lineImag12(1,j) = Simag1(1,j);
            lineImag22(1,j) = Simag2(1,j);
        elseif (kt3Imag<kt1Imag && kt3Imag<kt2Imag && signImag/signAi3>0) 
            s3Imag(1,j) = Simag1(1,j)/A(1,3);
            lineImag13(1,j) = Simag1(1,j);
            lineImag23(1,j) = Simag2(1,j);
        end
    end
    
    final1(1,j) = s1(1,j) + s1Imag(1,j)*i;
    final2(1,j) = s2(1,j) + s2Imag(1,j)*i;
    final3(1,j) = s3(1,j) + s3Imag(1,j)*i;
    
end

ss1 = ifft(final1);
ss2 = ifft(final2);
ss3 = ifft(final3);

figure,subplot(311),plot(y1);title('ԭ�ź�s1');
subplot(312),plot(y2);title('ԭ�ź�s2');
subplot(313),plot(y3);title('ԭ�ź�s3');

originSquare = 0;
minusSquare = 0;
%�Ÿɱ�
for k = 1:N
    originSquare = originSquare + originSource1(1,k)^2;
    originSquare = originSquare + originSource2(1,k)^2;
    originSquare = originSquare + originSource3(1,k)^2;
    minusSquare = minusSquare + (real(ss1(1,k))-originSource1(1,k))^2;
    minusSquare = minusSquare + (real(ss2(1,k))-originSource2(1,k))^2;
    minusSquare = minusSquare + (real(ss3(1,k))-originSource3(1,k))^2;
end
originSquare = originSquare/3;
minusSquare = minusSquare/3;
SIR_before = originSquare/minusSquare;

%% ʵ�����鲿fftͼ��
figure,subplot(311),plot(real(ss1)),title('�����ָ��ź�');
subplot(312),plot(real(ss2)),
subplot(313),plot(real(ss3)),


%% �������ֱ��
    %x=[1,1.5,2,2.5,3];y=[0.9,1.7,2.2,2.6,3];  
    p=polyfit(lineReal11, lineReal21,1);  
    x1=linspace(min(lineReal11),max(lineReal11));  
    y1=polyval(p,x1);  
    figure,subplot(311);plot(lineReal11,lineReal21,'*',x1,y1);  
    
%p=polyfit(lineReal11, lineReal21,1);
% ��ʾ���ǰ��ֱ�ߣ����з���Ϊ���ǰ���ݣ�ֱ��Ϊ��Ϻ��ֱ��
%yy=polyval(p,lineReal11);
%figure,subplot(311);plot(lineReal11, lineReal21,'s',lineReal11,yy);title('��ϵ�ֱ��30')
%��ϵ�ֱ�߷���
function1 = poly2sym(p,'x')

p=polyfit(lineReal12, lineReal22,1);
% ��ʾ���ǰ��ֱ�ߣ����з���Ϊ���ǰ���ݣ�ֱ��Ϊ��Ϻ��ֱ��
yy=polyval(p,lineReal12);
subplot(312);plot(lineReal12, lineReal22,'s',lineReal12,yy);title('��ϵ�ֱ��80')
%��ϵ�ֱ�߷���
function2 = poly2sym(p,'x')
p=polyfit(lineReal13, lineReal23,1);
% ��ʾ���ǰ��ֱ�ߣ����з���Ϊ���ǰ���ݣ�ֱ��Ϊ��Ϻ��ֱ��
yy=polyval(p,lineReal13);
subplot(313);plot(lineReal13, lineReal23,'s',lineReal13,yy);title('��ϵ�ֱ��135')
%��ϵ�ֱ�߷���
function3 = poly2sym(p,'x')

%% �鲿�����ֱ��
p=polyfit(lineImag11, lineImag21,1);
% ��ʾ���ǰ��ֱ�ߣ����з���Ϊ���ǰ���ݣ�ֱ��Ϊ��Ϻ��ֱ��
yy=polyval(p,lineImag11);
figure,subplot(311);plot(lineImag11, lineImag21,'s',lineImag11,yy);title('��ϵ�ֱ���鲿30')
%��ϵ�ֱ�߷���
functionImag1 = poly2sym(p,'x')

p=polyfit(lineImag12, lineImag22,1);
% ��ʾ���ǰ��ֱ�ߣ����з���Ϊ���ǰ���ݣ�ֱ��Ϊ��Ϻ��ֱ��
yy=polyval(p,lineImag12);
subplot(312);plot(lineImag12, lineImag22,'s',lineImag12,yy);title('��ϵ�ֱ���鲿80')
%��ϵ�ֱ�߷���
functionImag2 = poly2sym(p,'x')

p=polyfit(lineReal13, lineReal23,1);
% ��ʾ���ǰ��ֱ�ߣ����з���Ϊ���ǰ���ݣ�ֱ��Ϊ��Ϻ��ֱ��
yy=polyval(p,lineImag13);
subplot(313);plot(lineImag13, lineImag23,'s',lineImag13,yy);title('��ϵ�ֱ��135')
%��ϵ�ֱ�߷���
functionImag3 = poly2sym(p,'x')

%% ɸѡ�����ֱ��̫Զ�ĵ�,ɸѡ�ĵ���Ϊ0
%TODO �������Ժ�Ҫ��Ϊֱ���ϵĵ�
a1=4740677986623709/9007199254740992; b1 = 6561648807593965/288230376151711744;
a2 = 2559747240020583/562949953421312; b2 = 2410539232636079/18014398509481984;
a3 = - (4240264807956945/4503599627370496); b3 = - 793710701151507/288230376151711744;

distanceGate = 10; %����ֱ�ߡ����롱��ֵ
largeDistanceCount = 0;
for j=1:N
    lineReal11(1,j) = (lineReal21(1,j) - b1)/a1;
    lineReal12(1,j) = (lineReal22(1,j) - b2)/a2;
    lineReal13(1,j) = (lineReal23(1,j) - b3)/a3;
    lineImag11(1,j) = (lineImag21(1,j) - b1)/a1;
    lineImag12(1,j) = (lineImag22(1,j) - b2)/a2;
    lineImag13(1,j) = (lineImag23(1,j) - b3)/a3;
    
end

%% �޸��źź����¹���
for j=1:N
    signal1Real(1,j) = lineReal11(1,j)/A(1,1);
    signal2Real(1,j) = lineReal12(1,j)/A(1,2);
    signal3Real(1,j) = lineReal13(1,j)/A(1,3);
    
    signal1Imag(1,j) = lineImag11(1,j)/A(1,1);
    signal2Imag(1,j) = lineImag12(1,j)/A(1,2);
    signal3Imag(1,j) = lineImag13(1,j)/A(1,3);
    
    signal1(1,j) = signal1Real(1,j) + signal1Imag(1,j)*i;
    signal2(1,j) = signal2Real(1,j) + signal2Imag(1,j)*i;
    signal3(1,j) = signal3Real(1,j) + signal3Imag(1,j)*i;
end

recover1 = ifft(signal1);
recover2 = ifft(signal2);
recover3 = ifft(signal3);
figure,subplot(311),plot(real(recover1));title('������ָ�');
subplot(312),plot(real(recover2));
subplot(313),plot(real(recover3));

%�Ÿɱ�
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
SIR_after = originSquare/minusSquare;
            





