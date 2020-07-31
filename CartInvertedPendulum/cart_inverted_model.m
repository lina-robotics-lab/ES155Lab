% State vector s=(x,theta, dx/dt,dtheta/dt)
g=9.81;
mp=.23;
l=.6413;
r=l/2;
J=1/3*mp*l^2;
gamma=.0024;
mc=.38;
c=.9;


M=mc+mp;
R=mp*r;
K=J+mp*r^2;

params = {g, M, R, K, c, gamma} ;

Tspan = [0 10] ;
x0    = [0,pi/4,0,0];     
u = 0;
% initial condition
[t,x] = ode45(@(t,x) stateTransFunc(t,x,u,params),Tspan,x0);        % time domain ODE simulaiton

function xdot=stateTransFunc(t,x,u,params)
    [g, M, R, K, c, gamma] = params{:} ;
    disp([g,M,R])
    % State vector s=(x,theta, dx/dt,dtheta/dt)
    F = u;
    v = x(3);
    theta = x(2);
    omega = x(4);
    
    xdot = [0; 0; 0; 0];
    xdot(1)=x(3);
    xdot(2)=x(4);
    
    xdot(3) = F - c * v + (M/(R*cos(theta))) * (R*g*sin(theta)+gamma*omega) + R*sin(theta)*omega^2;
    xdot(3) = xdot(3)/(R*cos(theta)-M*K/(R*cos(theta)));
    
    xdot(4) = -(R*g*sin(theta)+gamma*omega+K*xdot(3))/(R*cos(theta)) ;
    
end
% poles = [-1,-2-i,-2+i,-3]
% 
% K=place(A,B,poles)
% K=[0 0 0 0]
