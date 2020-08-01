close all;
ax = gca;
x = [0 0 1 1];
y = [1 0 0 1];
[x,y]=rotPoints([0 0],pi/4,x,y);
pgon = polyshape(x,y);
plot(ax,pgon,'FaceColor',[0.3,0.3,0.3],'EdgeColor','None');
axis equal;

function [x_rot,y_rot]=rotPoints(origin,theta,x,y)
    x_diff = x-origin(1);
    y_diff = y-origin(2);
    x_rot = x_diff;
    y_rot = y_diff;
    coord_diff = [x_diff;y_diff];
    rot = transpose(origin) + rotMat(theta)*coord_diff;
    x_rot = rot(1,:);
    y_rot = rot(2,:);
    function rm=rotMat(theta)
        rm = [[cos(theta) -sin(theta)];[sin(theta) cos(theta)]];
    end
end
