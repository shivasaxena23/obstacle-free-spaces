clearAllMemoizedCaches;
clc;

EnvData;
%%%%%%%%%%%%%%%%%%%%%%

x = xv(1:4,:);
y = yv(1:4,:);
Check=size(x,2);
for i=1:Check
    O(:,:,i)=[x(:,i) y(:,i)];
end
%%%%%%%%%%%%%%%%%%%%%%

C = 0.01*[1 0; 0 1];    % define small circle
d = zeros(1,2);
[d(1),d(2)] = getpts;   % get d_0, double click an empty spot on the figure
d = d';
hold on; plot(d(1),d(2),'xk');
txt='  d_0'; text(d(1),d(2),txt); 
hold off;

%% Implemented Solution

num_iterations = 0;
area = det(C);
threshold = 0.01;
growth = 100;

while growth > threshold
    % Calculate the separating hyperplanes (to find the obstacle-free
    % polyhedral region)
    O_remaining = O;
    num_vertices = size(O_remaining,1);
    dim = size(O_remaining,2);
    num_iterations = num_iterations + 1;
    A = [];
    b = [];
    while size(O_remaining,3) ~= 0  % while O_remaining is not empty
        [a_i,b_i,l_star]=Sep(C,d,O_remaining);

	% add the new hyperplane to the polyhedral
        A = [A; a_i']; 
        b = [b; b_i];
        O_excluded = [l_star]; % indices of obstacles that the hyperplane a_i*x=b_i separates
        for j = 1:size(O_remaining,3)
            if isequal(a_i'*O_remaining(:,:,j)'>=b_i,ones(1,num_vertices))
                % if all of the obstacle vertices are on the other side of
                % the hyperplane, then don't bother calculating a
                % hyperplane for that obstacle
                O_excluded = [O_excluded, j];
            end
        end

        O_remaining(:,:,O_excluded) = [];
    end

    prev_C=C;
    prev_d=d;
    
    % Calculate the inscribed ellipsoid
    [ C,d ] = InsEll( A,b);
    
    growth = (det(C) - det(prev_C))/det(prev_C);
    area = [area det(C)];
    
    %% Results

    
    theta = linspace(0,2*pi,200);
    prev_ellipse_inner = prev_C*[cos(theta); sin(theta)]+prev_d;
    ellipse_inner=C*[cos(theta); sin(theta)]+d; 
    
    points =poly2D(A,b)';
    [k,av] = convhull(points);
    v_x = points(:,1);
    v_y = points(:,2);
     
    
    figure('Position',[0 0 850 325]);
    subplot(1,2,1)
        plot(xv,yv);
        hold on
        plot(v_x(k), v_y(k), 'bo-');
        plot( prev_ellipse_inner(1,:), prev_ellipse_inner(2,:), 'r--' );
        title(['Iteration ',num2str(num_iterations)]);
        axis([-10, 10,-10, 10]);
        hold off;
        
    subplot(1,2,2)
        plot(xv,yv);
        hold on
        plot(v_x(k), v_y(k), 'bo-');
        plot( ellipse_inner(1,:), ellipse_inner(2,:), 'r--' );
        axis([-10, 10,-10, 10]);
        hold off;
        
end
%%% Area of the ellipse for each iteration

figure('Position',[600 0 450 200]);
    area = area*pi;
    
    plot([0:1:size(area,2)-1],area);
    xticks(0:1:size(area,2)-1);
    grid on;
    ylabel('Area');
    xlabel('Number of iterations');
    title('Area of the ellipse for each iteration');
    snapnow;