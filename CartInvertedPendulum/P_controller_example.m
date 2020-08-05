close all;
%% This script shows an example of using a proportional controller to stablize a cart inverted pendulum. 

% Parameters specifying the build of the cart inverted pendulum.
g=9.81;
mp=.23;
l=.6413;
r=l/2;
J=1/3*mp*l^2;
gamma=.0024;
mc=.38;
c=0.9;

% Magnitude of the process noise to be added to the input
noise_mag=1;

% Initial state.
% Recall state vector s=(x,theta, dx/dt,dtheta/dt)

s0 = [0;pi/8;0;0];

% Create cart inverted pendulum simulator
model = cart_inverted_model(s0,g,mp,l,r,J,gamma,mc,c);

% Specify the time of simulation.
t0 = 0;
t = t0;
dt = 0.03;
t_end = 20;

% Specify some animation related parameters.
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]*0.5);

canvas_size_ratio = 10;
aspect_ratio = 1;
xl = [-1,1]* canvas_size_ratio * model.l * aspect_ratio;

%%
% The following is a stablizing controller.
% Recall state vector s=(x,theta, dx/dt,dtheta/dt)

K= [0.572 +15.7 2.12 +4.02];

%%
% Start simulation
for i =1:floor((t_end-t0)/dt)
    
    % Drawing the current model state.
    ax = gca;
    draw_model(ax,model);
    title("sim time="+t0+i*dt);
    
    % Closing the loop of feedback here.
    u = K*model.s;
    
    % Add some noise to create the difficulty in control.
    noise = (rand()-0.5)*noise_mag;
    
    % Simulate for dt time duration, with input u+noise acting on the
    % system.
    model.simulate(u+noise,dt);
    
        
    % If the cart goes out of pre-defined boundary, stop simulation.
        if model.s(1)>xl(2) || model.s(1)<xl(1) 
            break
        end
    
    % Update simulation time and pause for a while to create the correct
    % sense of time.
    t=t+dt;
    pause(dt/5);
end
