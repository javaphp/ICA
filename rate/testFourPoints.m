clc;clear all;close all;
%% �������·�����Ƿ����ҵ�˳ʱ�����ʱ������Ļ�����,�����
data1=[cos(pi/7) cos(pi/3) cos(5*pi/9) cos(4*pi/5)];
data2=[sin(pi/7) sin(pi/3) sin(5*pi/9) sin(4*pi/5)];

%% ����ԭ�ź�

A = zeros(2,3); %���Ľ�

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
end
baseCopy = baseAnglePositive;

jk=1;km=1;
for j=1:4
    angles(1,j) = atan2(data2(1,j),data1(1,j));
    angles1=angles(1,j);   %��ʱ��
    angles2=angles(1,j);   %˳ʱ��
    if(angles(1,j)<0) 
        angles1 = 2*pi+angles(1,j);   %�Ѹõ�ĽǶ�ת��Ϊ0,2*pi
    elseif(angles(1,j)>0)
        angles2 = angles(1,j) - 2*pi;     %�Ѹõ�ĽǶ�ת��Ϊ-2*pi,0
    end
    
    for k=1:3
        deltaAngle1(1,k)=baseAnglePositive(1,k)-angles1;  %��ʱ�����������
        deltaAngle2(1,k)= angles1 - baseAnglePositive(1,k);  %˳ʱ�����������
    end
    
    %�ҳ�������
    baseAnglePositive(4) = angles1;
    baseAnglePositive
    sorted_angle = sort(baseAnglePositive);
    index=0;
     for n=1:4     %b-1
        if(sorted_angle(n) == angles1)
            index = n;
            break;
        end
     end
    if(index==1)
        index1=4;   %Ҫ�жϵ�����Ƕ�����С��
        index2 = 2;
    elseif(index==4)
        index1 = 1;
        index2 = 3;   %Ҫ�жϵ�����Ƕ�������
    else
        index1 = index -1;
        index2 = index + 1;
    end
    disp('�Աߵ������Ƕ��ǣ�')
    num1 = sorted_angle(index1)
    num2 = sorted_angle(index2)
    for p=1:3
        if(baseCopy(p) == num1)
            indexJ(1,j) = p
        elseif(baseCopy(p) == num2)
            indexK(1,j) = p
        end
    end
    jk = jk+1;
    km = km+1;
    
end



