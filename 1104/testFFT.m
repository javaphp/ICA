n1=40;
window=boxcar(n1);
w1=window;
%figure(1);
%stem(w1);
%?��ƽ���źŲ���%?
fs=1000;
a=0:1/fs:1;
f0=0;
f1=150;
y1=chirp(a,f0,1,f1);

x=y1(1:510);
%figure(2);
%plot(x);
%?��ʱ����Ҷ�任%??
t=1:length(x);
n=length(x);
[S,F,T,P]=spectrogram(x,w1,32,256);  %SΪ��������ʱ����Ҷ�任��Ľ��
%surf(T,F,10*log10(abs(P)));
%axis tight;
%view(0,90);