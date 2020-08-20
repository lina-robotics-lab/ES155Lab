clear all;
%% System paramters
m     = 10;      % mass
delta = 0;       % Viscocity coefficient, for simplicity, 
                 % assumed to be zero for Case 1 & Case 2;
Fhill = 1;       % Assume the vehicle runs on a flat road; 

V0    = 0;       % initial velocity m/s
Vdes  = 1;     % Desired velocity m/s

% put all system parameter into one single variable
para.m     = m; 
para.delta = delta; 
para.Fhill = Fhill;
para.V0    = V0;
para.Vdes  = Vdes;


tspan = [0,30]; % simulation time period
y0    = [0;V0]; % initial conditon

%% simulate the vehicle's trajectory when no input is applied
[t,y] = ode45(@(t,y) stateTransFunc(t,y,para),tspan,y0);

% plot
figure
subplot(2,1,1);
plot(t,y(:,1),'-o')
title('Cruise Control Case 1: no control');
xlabel('Time $t$','Interpreter','latex');
ylabel('Position $y$','Interpreter','latex');
legend('Postion','Location','best');

subplot(2,1,2);
plot(t,y(:,2),'->'); hold on;
plot(t,Vdes,'k-<');
ylim([0,4])

xlabel('Time $t$','Interpreter','latex');
ylabel('Velocity $v$','Interpreter','latex');
legend('Velocity','Desired velocity','Location','best');

% Development Script for cruise_control_dynamics
function ydot = stateTransFunc(t,y,para)
% Vehicle dynamcis 
% t: time;   y: position and velocity;  para: system parameters

    m     = para.m;           % mass
    delta = para.delta;       % Viscocity coefficient
    Fhill = para.Fhill;       % 
      
    % By default, control input is zero.
    Fengine = 0;
    if isprop(para,'Fengine')
        Fengine = para.Fengine
    end
    
    ydot = zeros(2,1);
    % dynamcis
    ydot(1) = y(2);                              % position part
    ydot(2) = (-delta*y(2) + Fhill + Fengine)/m; % velocity part
    
end
