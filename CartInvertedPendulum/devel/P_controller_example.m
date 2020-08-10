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
% Recall state vector s=(x,theta,I_x,I_theta, dx/dt,dtheta/dt)

s0 = [0;pi/8;0;0;0;0];

% Create cart inverted pendulum simulator
model = cart_inverted_model(s0,g,mp,l,r,J,gamma,mc,c,noise_mag);

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
% Recall state vector s=(x,theta,I_x,I_theta, dx/dt,dtheta/dt)

K= [0.5 16 0.1 0.0 2 4];

%%
% Start simulation
for i =1:floor((t_end-t0)/dt)
    
    % Drawing the current model state.
    ax = gca;
    draw_model(ax,model);
    title("sim time="+t0+i*dt);
    
    % Closing the loop of feedback here.
    u = K*model.s;
    
    
    % Simulate for dt time duration, with input u+noise acting on the
    % system.
    model.simulate(u,dt);
    
        
    % If the cart goes out of pre-defined boundary, stop simulation.
        if model.s(1)>xl(2) || model.s(1)<xl(1) 
            break
        end
    
    % Update simulation time and pause for a while to create the correct
    % sense of time.
    t=t+dt;
    pause(dt/5);
end
