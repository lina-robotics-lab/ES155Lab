close all;
g=9.81;
mp=.23;
l=.6413;
r=l/2;
J=1/3*mp*l^2;
gamma=.024;
mc=.38;
c=0.9;


x0 = [0;pi/8;0;0];

model = cart_inverted_model(x0,g,mp,l,r,J,gamma,mc,c);
model.s;

% State vector s=(x,theta, dx/dt,dtheta/dt)

t0 = 0 ;
t = t0;
dt = 0.1;
t_end = 0.1;

for i =1:floor((t_end-t0)/dt)

ax = gca;
cla(ax);
draw_model(ax,model);


model.simulate(0,dt);
t=t+dt;
pause(dt/3);
end

function ax=draw_model(ax,model)
canvas_size_ratio = 1.2;
aspect_ratio = 1.8;
xl = [-1,1]* canvas_size_ratio * model.l * aspect_ratio;
yl = [-1,1]*canvas_size_ratio * model.l;

width = 0.5*model.l;
height = 0.2*model.l;
x = model.s(1)-1/2*width;
y=0-height;

% Draw Pendulum
pen_width = width*0.15;
pen_l = model.l;
pen_x = model.s(1)-pen_width/2;
p=rectangle('Parent',ax,'Position',[pen_x 0 pen_width pen_l],"FaceColor",[0.6 0.6 0.6],'EdgeColor','None','Curvature',[0.2,0.2])
hold on;


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
end