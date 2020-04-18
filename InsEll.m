function [ C,d ] = InsEll( A,b )
sizeA = size(A);
    n = sizeA(2);
    m = sizeA(1);
    cvx_begin quiet
        variable C(n,n) symmetric
        variable d(n)
        maximize( det_rootn( C ) )
        subject to            
           for j = 1:m
               norm( C*A(j,:)', 2 ) + A(j,:)*d <= b(j);
           end
    cvx_end
end