close all;
%% This script shows an example of using a proportional controller to stablize a cart inverted pendulum. 

% Parameters specifying the build of the cart inverted pendulum.
m     = 10;      % mass
delta = 2;       % Viscocity coefficient, for simplicity, 
                 % assumed to be zero;
Fhill = 0;       % Assume the vehicle runs on a flat road; 

V0    = 0;       % initial velocity m/s
y0  = 0;     % initial location m

s0 = [y0;V0;0]; % System State: s = [y;v;int_y]

y_target = 5; % Target position to reach
v_target = 0; % Target velocity, which should be 0.

% Magnitude of the process noise to be added to the input
noise_mag=0;

% Create cart inverted pendulum simulator
model = cruise_control_model(m,delta,Fhill,s0,noise_mag);

% Specify the time of simulation.
t0 = 0;
t = t0;
dt = 0.03;
t_end = 3;
% 
% % Specify some animation related parameters.
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]*1);
 
%% The following is a working PID controller.

K= -[100 50 0];
% 
% %%
% Start simulation
for i =1:floor((t_end-t0)/dt)
    
    % Drawing the current model state.
    ax = gca;
    draw_model(ax,model,y_target);
    title("sim time="+t0+i*dt);
    
    % Closing the loop of feedback here.
    u = K*(model.s-[y_target;v_target;0]);
    
    
    % Simulate for dt time duration, with input u+noise acting on the
    % system.
    model.simulate(u,dt);
    
    % Update simulation time and pause for a while to create the correct
    % sense of time.
    t=t+dt;
    pause(dt/5);
end
