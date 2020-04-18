% Run this to generate the test data
clc;
% Specify boundaries and number of obstacles
n=14;       % number of obstacles
limit=10;    % abs max of boundary

xv=[-10 -8 -10 -10 -8;
    -10 -5 -5 -10 -10;
    -10 -5 -7 -10 -10;
    -3 -3 0 0 -3;
    0 0 4 4 0;
    4 4 6 6 4;
    6 6 10 10 6;
    -6 -1 -1 -6 -1;
    -1 1 1 -1 -1;
    1 6 1 1 6;
    6 10 10 8 6;
    8 10 10 8 8;
    1 4 4 1 1;
    4 5 7 4 4].'; 
yv=[10 6 2 10 6;
    2 2 -2 -2 2;
    -7 -5 -10 -10 -7;
    -5 2 2 -5 -5;
    -10 -3 -3 -10 -10;
    -10 -7 -7 -10 -10;
    -10 -7 -3 -10 -10;
    10 10 8 10 10;
    10 10 6 8 10;
    10 10 8 10 10;
    10 10 6 6 10;
    6 6 2 2 6;
    4 6 2 2 4;
    4 4 -1 -1 4].';
figure
plot(xv,yv);
% plot(xv,yv,1,0.5,'+');
axis equal

%Add boundaries
boundaryx=[-limit -limit limit limit -limit;
            -limit limit limit -limit -limit;
            -limit -limit limit limit -limit;
            -limit limit limit -limit -limit;
            -limit -limit limit limit -limit];
boundaryy=[-limit limit limit -limit -limit;
            limit limit -limit -limit limit;
            -limit limit limit -limit -limit;
            limit limit -limit -limit limit;
            -limit limit limit -limit -limit];
%xv(:,i+1)=[limit; limit; NaN*ones(m-2,1)]; yv(:,i+1)=[limit; -limit; NaN*ones(m-2,1)];

hold on
plot(boundaryx,boundaryy,'k');
title('Test Environment');
axis equal

% Now add boundaries to list of obstacles
xv(:,n+1:n+5)=boundaryx;
yv(:,n+1:n+5)=boundaryy;
