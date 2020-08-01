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
t_end = 10;

for i =1:floor((t_end-t0)/dt)

ax = gca;
cla(ax);
draw_model(ax,model);


model.simulate(0,dt);
t=t+dt;
pause(dt/3);
end

function ax=draw_model(ax,model)
canvas_size_ratio = 2;
aspect_ratio = 2;
xl = [-1,1]* canvas_size_ratio * model.l * aspect_ratio;
yl = [-1,1]*canvas_size_ratio * model.l;

width = 2*model.l;
height = 0.8*model.l;
x = model.s(1)-1/2*width;
y=0-height;

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