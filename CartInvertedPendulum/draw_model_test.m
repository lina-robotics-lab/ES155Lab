close all;
g=9.81;
mp=.23;
l=.6413;
r=l/2;
J=1/3*mp*l^2;
gamma=.0024;
mc=.38;
c=0.9;


x0 = [0;0;0;0];

model = cart_inverted_model(x0,g,mp,l,r,J,gamma,mc,c);
model.s;

% State vector s=(x,theta, dx/dt,dtheta/dt)

t0 = 0 ;
t = t0;
dt = 0.03;
t_end = 50;

set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]*0.5);

canvas_size_ratio = 2;
aspect_ratio = 1;
xl = [-1,1]* canvas_size_ratio * model.l * aspect_ratio;

% The following is a stablizing controller.

K= [0.572 +15.7 2.12 +4.02];



for i =1:floor((t_end-t0)/dt)

ax = gca;
cla(ax);
draw_model(ax,model);
title("sim time="+t0+i*dt);

u = K*model.s;
% u = 1;

noise = (rand()-0.5)*1;
model.simulate(u+noise,dt);
t=t+dt;
if model.s(1)>xl(2) || model.s(1)<xl(1)
    break
end
pause(dt/5);
end


function ax=draw_model(ax,model)
canvas_size_ratio = 2;
aspect_ratio = 1;
xl = [-1,1]* canvas_size_ratio * model.l * aspect_ratio;
yl = [-0.2,1]*canvas_size_ratio * model.l;

width = 0.5*model.l;
height = 0.2*model.l;
x = model.s(1)-1/2*width;
y=0-height;

% Draw Pendulum
pen_width = width*0.05;
pen_l = model.l;
pen_x = model.s(1)-pen_width/2;
theta = model.s(2);
% p=rectangle('Parent',ax,'Position',[pen_x 0 pen_width pen_l],"FaceColor",[0.6 0.6 0.6],'EdgeColor','None','Curvature',[0.2,0.2]);
v_x = [pen_x pen_x pen_x + pen_width pen_x + pen_width];
v_y = [0 pen_l pen_l 0];

% Since we are using the clockwise as the positive direction of angular
% increase, the theta here should take its negative.
[v_x,v_y]=rotPoints([model.s(1) 0],-theta,v_x,v_y);
pgon = polyshape(v_x,v_y);
plot(ax,pgon,'FaceColor',[0.3,0.3,0.3],'EdgeColor','None');
axis equal;

hold on;


% Draw Vertical Basis Line
plot(model.s(1)*[1 1],[0,yl(2)],'LineStyle','--')


% Draw Wheels
wheel_d = width*0.2; 
wheel_x = [x+1/5*width,x+3/5*width];
wheel_y = [1,1]*(y-wheel_d*0.5);
wheel_spec = [wheel_x(1),wheel_y(1),wheel_d,wheel_d];
        % Use curved rectangle to draw wheels.
rectangle('Parent',ax, 'Position',wheel_spec,'Curvature',[1 1],'FaceColor','k')
hold on;
wheel_spec = [wheel_x(2),wheel_y(2),wheel_d,wheel_d];
rectangle('Parent',ax, 'Position',wheel_spec,'Curvature',[1 1],'FaceColor','k')
hold on;

% Draw Pivot
pivot_d = width*0.15; 
pivot_x = x+0.5*width-0.5*pivot_d;
pivot_y = -0.5*pivot_d;
pivot_spec = [pivot_x,pivot_y,pivot_d,pivot_d];
rectangle('Parent',ax, 'Position',pivot_spec,'Curvature',[1 1],'FaceColor','w')
hold on;

% Draw Cart Body
rectangle('Parent',ax,'Position',[x y width height],"FaceColor",[196,154,71]/256,'EdgeColor','None','Curvature',[0.2,0.2])
hold on;


% Draw Ground
plot(xl,[1 1]*(y-wheel_d/2),'Parent',ax,'Color','k');
hold on;

% Set Aspect Ratio
set(ax,'DataAspectRatio',[1 1 1])
xlim(xl);
ylim(yl);


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

end