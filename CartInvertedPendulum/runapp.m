% Parameters specifying the build of the cart inverted pendulum.
g=9.81;
mp=.23;
l=.6413;
r=l/2;
J=1/3*mp*l^2;
gamma=.0024;
mc=.38;
c=0.9;

dt = 0.05;
% Magnitude of the process noise to be added to the input
global noise_mag;
noise_mag=1;

% Initial state.
% Recall state vector s=(x,theta, dx/dt,dtheta/dt)

s0 = [0;0;0;0];

% Create cart inverted pendulum simulator
model = cart_inverted_model(s0,g,mp,l,r,J,gamma,mc,c);


% Create the UI instance. The UI window will pop up automatically.
UI = UI_exported();

% Create UI listeners
addlistener(UI,'RequestModelState',@(app,event) UIRequestCallback(app,event,model,dt));
addlistener(UI,'Reset',@(app,event) ResetCallback(app,event,model));
addlistener(UI,'ChangeInitialAngle',@(app,event) InitialAngleCallback(app,event,model));
addlistener(UI,'ObjectBeingDestroyed',@AppClosedCallback);

% Create simulation model listeners
addlistener(model,'simulationDone',@(model,event) SimulationDoneCallback(UI,model,event));

UI.updateAxes(model);

function model = defaultModel()
    g=9.81;
    mp=.23;
    l=.6413;
    r=l/2;
    J=1/3*mp*l^2;
    gamma=.0024;
    mc=.38;
    c=0.9;

    % Initial state.
    % Recall state vector s=(x,theta, dx/dt,dtheta/dt)

    s0 = [0;0;0;0];

    % Create cart inverted pendulum simulator
    model = cart_inverted_model(s0,g,mp,l,r,J,gamma,mc,c);
end


function SimulationDoneCallback(app,model,event)
%     disp('Simulation Done received');
    app.updateAxes(model);
end

function UIRequestCallback(app,event,model,dt)
    global noise_mag;
    start_or_pause = app.StartSimulationButton.Value;
    
    
    if start_or_pause==1
        notify(model,'requestSimulate',SimulateInputData(app.getInput(model.s)+(rand()-0.5)*noise_mag,dt));
    else
        % If currently it is pausing, do nothing
%         disp('nothing to be done');
    end
end

function ResetCallback(app,event,model)
    % When reset button is pushed, stop the simulation and set the model
    % back to initial state.
    default_model=defaultModel();
    
    model.s0=default_model.s0;
    model.s=default_model.s;
    app.updateAxes(model);
end
function InitialAngleCallback(app,event,model)
    theta = app.InitialAngledegSlider.Value/360 * 2 * pi;
    model.s0=[0;theta;0;0];
    model.s = model.s0;
    app.updateAxes(model);
end

function AppClosedCallback(app,event)
    global appClosed;
    appClosed=true;
end