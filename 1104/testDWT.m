clc; clear all; close all;

[y1,Fs]=wavread('../shengxia.wav');
[y2,Fs]=wavread('../yanhua.wav');
[y3,Fs]=wavread('../niba.wav');
y1 = y1(:,1);
y2 = y2(:,1);
y3 = y3(:,1);
s = y1;
s2 = y2;
s3 = y3;
Len = length(s);
len2 = length(s2);
len3 = length(s3);

[ca1, cd1] = dwt(s, 'db1'); % ����db1С�����ֽ�
a1 = upcoef('a', ca1, 'db1', 1, Len); % ��ϵ���õ������ź�
d1 = upcoef('d', cd1, 'db1', 1, Len); % ��ϵ���õ�ϸ���ź�
s1 = a1+d1; % �ع��ź�
figure;
subplot(2, 2, 1); plot(s); title('��ʼ��Դ�ź�');
subplot(2, 2, 2); plot(ca1); title('һ��С���ֽ�ĵ�Ƶ��Ϣ');
subplot(2, 2, 3); plot(cd1); title('һ��С���ֽ�ĸ�Ƶ��Ϣ');
subplot(2, 2, 4); plot(s1, 'r-'); title('һ��С���ֽ���ع��ź�');

[ca1, cd1] = dwt(s2, 'db1'); % ����db1С�����ֽ�
a1 = upcoef('a', ca1, 'db1', 1, Len); % ��ϵ���õ������ź�
d1 = upcoef('d', cd1, 'db1', 1, Len); % ��ϵ���õ�ϸ���ź�
sBack = a1+d1; % �ع��ź�
figure;
subplot(2, 2, 1); plot(s2); title('��ʼ��Դ�ź�');
subplot(2, 2, 2); plot(ca1); title('һ��С���ֽ�ĵ�Ƶ��Ϣ');
subplot(2, 2, 3); plot(cd1); title('һ��С���ֽ�ĸ�Ƶ��Ϣ');
subplot(2, 2, 4); plot(sBack, 'r-'); title('һ��С���ֽ���ع��ź�');

[ca1, cd1] = dwt(s3, 'db1'); % ����db1С�����ֽ�
a1 = upcoef('a', ca1, 'db1', 1, Len); % ��ϵ���õ������ź�
d1 = upcoef('d', cd1, 'db1', 1, Len); % ��ϵ���õ�ϸ���ź�
s3Back = a1+d1; % �ع��ź�
figure;
subplot(2, 2, 1); plot(s3); title('��ʼ��Դ�ź�');
subplot(2, 2, 2); plot(ca1); title('һ��С���ֽ�ĵ�Ƶ��Ϣ');
subplot(2, 2, 3); plot(cd1); title('һ��С���ֽ�ĸ�Ƶ��Ϣ');
subplot(2, 2, 4); plot(s3Back, 'r-'); title('һ��С���ֽ���ع��ź�');

