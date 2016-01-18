function [ count1 count2 count3 ] = calculatePoints( x11, x21, A)
%% 计算各基向量方向上点的个数

count1 = 0;count2 = 0;count3 = 0;
[row col] = size(x11);  
N = row * col;        %样本的个数
kt1 = A(2,1)/A(1,1);
kt2 = A(2,2)/A(1,2);
kt3 = A(2,3)/A(1,3);
for loop=1:N
    currentSlope = x21(1,loop)/x11(1,loop);
    distance1 = abs(currentSlope - kt1);
    distance2 = abs(currentSlope - kt2);
    distance3 = abs(currentSlope - kt3);
end


count1 = 0;
count2 = 0;
count3 = 1;

end

