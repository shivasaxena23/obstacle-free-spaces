function [a,b,l_star] = Sep(C,d,O_rignal)
%CLOSESTOBSTACLE returns closest obstacle 
O = O_rignal;
Cinv = C^-1;
number_obs = size(O,3);
min_distance = zeros(1,number_obs);
for idx = 1:number_obs
    O(:,1,idx) = O(:,1,idx) - d(1);
    O(:,2,idx) = O(:,2,idx) - d(2);
    
    O(:,:,idx) = (Cinv* O(:,:,idx)')'; %transform into ball space
    min_distance(1,idx) = min(vecnorm(O(:,:,idx)')); %calculate the minimum distance
end

[dist, l_star] = min(min_distance);

O = O_rignal;
V=O(:,:,l_star)';
k=size(O,1); % dimension of vertices
n=size(O,2); % number of vertices

% transform each vertex to the ball space
V_bar=inv(C)*(V-d);

% define and solve problem in cvx
cvx_begin quiet
    variable x_bar(n) 
    variable w(k) nonnegative
    minimize(norm(x_bar))
    subject to
        V_bar*w==x_bar;
        sum(w)==1;
cvx_end

% transform point back to ellipse space
x=C'*x_bar+d;
a=2*inv(C)*inv(C')*(x-d);
b=a.'*x;
end

