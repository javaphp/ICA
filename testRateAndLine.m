clc;clear all;close all;
%% ���ñ��ʾ�������Ƿ��äԴ����,�����ݽ��з��飬������ֵ���鱣�������⣬�����ݷ��飬����ֱ����ϣ�����ֱ�߸�����ʹ��ֱ�ߵĵ����
atanGate = 0; % �۲��ź�����������ֵ��δ��
areaCount = 200; %�۲�����������ֵ����Сֵ����������
areaNum = 150; %�۲��������ÿ��������������С��ֵ

n1=40;
window=boxcar(n1);
w1=window;

[y1,Fs,bits]=wavread('shengxia.wav');
%[y2,Fs2,bits]=wavread('media/gao.wav');
%[y2,Fs,bits]=wavread('media/nv.wav');
[y3,Fs,bits]=wavread('huiyin.wav');
[y2,Fs,bits]=wavread('niba.wav');
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

final1 = zeros(1,45000);final2 = zeros(1,45000);final3 = zeros(1,45000);
lineReal11 = zeros(1,45000);lineReal12 = zeros(1,45000);lineReal13 = zeros(1,45000);
lineReal21 = zeros(1,45000);lineReal22 = zeros(1,45000);lineReal23 = zeros(1,45000);
lineImag11 = zeros(1,45000);lineImag12 = zeros(1,45000);lineImag13 = zeros(1,45000);
lineImag21 = zeros(1,45000);lineImag22 = zeros(1,45000);lineImag23 = zeros(1,45000);

for j=1:sLength
    kt = abs(Sreal1(1,j)/Sreal2(1,j));
    ktImag = abs(Simag1(1,j)/Simag2(1,j));
    
    kt1 = abs(kt-ai1);
    kt2 = abs(kt-ai2);
    kt3 = abs(kt-ai3);
    
    kt1Imag = abs(ktImag-ai1);
    kt2Imag = abs(ktImag-ai2);
    kt3Imag = abs(ktImag-ai3);
    
    if(Sreal2(1,j) ~= 0)
        if (kt1<kt2 && kt1<kt3)
            s1(1,j) = Sreal1(1,j)/A(1,1);
            lineReal11(1,j) = x11Real(1,j);
            lineReal21(1,j) = x21Real(1,j);
        elseif (kt2<kt1 && kt2<kt3) 
            s2(1,j) = Sreal1(1,j)/A(1,2);
            lineReal12(1,j) = x11Real(1,j);
            lineReal22(1,j) = x21Real(1,j);
        elseif (kt3<kt1 && kt3<kt2) 
            s3(1,j) = Sreal1(1,j)/A(1,3);
            lineReal13(1,j) = x11Real(1,j);
            lineReal23(1,j) = x21Real(1,j);
        end
    end
    
    if(Simag2(1,j) ~= 0)
        if (kt1Imag<kt2Imag && kt1Imag<kt3Imag)
            s1Imag(1,j) = Simag1(1,j)/A(1,1);
            lineImag11(1,j) = Simag1(1,j);
            lineImag21(1,j) = Simag2(1,j);
        elseif (kt2Imag<kt1Imag && kt2Imag<kt3Imag) 
            s2Imag(1,j) = Simag1(1,j)/A(1,2);
            lineImag12(1,j) = Simag1(1,j);
            lineImag22(1,j) = Simag2(1,j);
        elseif (kt3Imag<kt1Imag && kt3Imag<kt2Imag) 
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

%% ʵ�����鲿fftͼ��
figure,subplot(311),plot(real(ss1)),title('�����ָ��ź�');
subplot(312),plot(real(ss2)),
subplot(313),plot(real(ss3)),

%% �������ֱ��
p=polyfit(lineReal11, lineReal21,1);
% ��ʾ���ǰ��ֱ�ߣ����з���Ϊ���ǰ���ݣ�ֱ��Ϊ��Ϻ��ֱ��
yy=polyval(p,lineReal11);
figure,subplot(311);plot(lineReal11, lineReal21,'s',lineReal11,yy);title('��ϵ�ֱ��30')
%��ϵ�ֱ�߷���
poly2sym(p,'x')

p=polyfit(lineReal12, lineReal22,1);
% ��ʾ���ǰ��ֱ�ߣ����з���Ϊ���ǰ���ݣ�ֱ��Ϊ��Ϻ��ֱ��
yy=polyval(p,lineReal12);
subplot(312);plot(lineReal12, lineReal22,'s',lineReal12,yy);title('��ϵ�ֱ��80')
%��ϵ�ֱ�߷���
poly2sym(p,'x')
p=polyfit(lineReal13, lineReal23,1);
% ��ʾ���ǰ��ֱ�ߣ����з���Ϊ���ǰ���ݣ�ֱ��Ϊ��Ϻ��ֱ��
yy=polyval(p,lineReal13);
subplot(313);plot(lineReal13, lineReal23,'s',lineReal13,yy);title('��ϵ�ֱ��135')
%��ϵ�ֱ�߷���
poly2sym(p,'x')



            





