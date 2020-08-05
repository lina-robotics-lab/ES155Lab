% State vector s=(x,theta, dx/dt,dtheta/dt)
g=9.81;
mp=.23;
l=.6413;
r=l/2;
J=1/3*mp*l^2;
gamma=.024;
mc=.38;
c=0.9;


M=mc+mp;
R=mp*r;
K=J+mp*r^2;

params = {g, M, R, K, c, gamma} ;

Tspan = [0 0.01] ;
x0    = [0;pi/4;0;0];     
u = 1;
% initial condition
[t,x] = ode45(@(t,x) stateTransFunc(t,state,u,params),Tspan,x0);        % time domain ODE simulaiton

function xdot=stateTransFunc(t,state,u,params)
    [g, M, R, K, c, gamma] = params{:} ;
    % State vector s=(x,theta, dx/dt,dtheta/dt)
    F = u;
    v = x(3);
    theta = x(2);
    omega = x(4);
    
    xdot = [0; 0; 0; 0];
    xdot(1)=x(3);
    xdot(2)=x(4);
    
    xdot(4) = M*gamma*omega - M*g*R*sin(theta) + (F-c*v+R*sin(theta)*omega^2)*R*cos(theta);
    xdot(4) = xdot(4)/(R^2*cos(theta)^2-M*K);
    
%     xdot(3) = (R*g*sin(theta)-gamma*omega-K*xdot(4))/(R*cos(theta)) ;
    xdot(3) = R^2*g*sin(theta)*cos(theta)-K*(F-c*v+R*sin(theta)*omega^2)-gamma*R*omega*cos(theta);
    xdot(3) = xdot(3)/(R^2*cos(theta)^2-M*K);
end
