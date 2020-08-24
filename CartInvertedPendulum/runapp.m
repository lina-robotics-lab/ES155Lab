% Create cart inverted pendulum simulator
model = defaultModel();

% Create the UI instance. The UI window will pop up automatically.
app = UI();

% Create UI listeners
simulate_duration_dt = 0.08;
addlistener(app,'RequestSimulate',@(app,event) UIRequestCallback(app,event,model,simulate_duration_dt));
addlistener(app,'Reset',@(app,event) ResetCallback(app,event,model));
addlistener(app,'ChangeInitialAngle',@(app,event) InitialAngleCallback(app,event,model));

% Create simulation model listeners
addlistener(model,'simulationDone',@(model,event) SimulationDoneCallback(app,model,event));

app.updateAxes(model);

function model = defaultModel()
% Parameters to specify the model dynamics.
    g=9.81;
    mp=.23;
    l=.6413;
    r=l/2;
    J=1/3*mp*l^2;
    gamma=.0024;
    mc=.38;
    c=0.9;
    
    % Change the process noise magnitude if you want some disturbance in
    % the system.
    process_noise_mag=0;

    % Initial state.
    % Recall state vector s=(x,theta,I_x,I_theta, dx/dt,dtheta/dt)
    s0 = [0;0;0;0;0;0];

    % Create cart inverted pendulum simulator
    model = cart_inverted_model(s0,g,mp,l,r,J,gamma,mc,c,process_noise_mag);
end


function SimulationDoneCallback(app,model,event)
    app.updateAxes(model);
end

function UIRequestCallback(app,event,model,dt)
    start_or_pause = app.StartSimulationButton.Value;
  
    if start_or_pause==1
        notify(model,'requestSimulate',SimulateInputData(app.getInput(model.s),dt));
    else
        % If currently it is pausing, do nothing
    end
end

function ResetCallback(app,event,model)
    % When reset button is pushed, stop the simulation and set the model
    % back to initial state.
    default_model=defaultModel();
    
    model.s0=default_model.s0;
    model.s=default_model.s;
    app.updateAxes(model);
    
    % Save Data
    history = model.getStateHistory();
    save("sim-data-"+datestr(now,'yyyy-mmm-dd-HH:MM:SS')+".mat",'history');
end
function InitialAngleCallback(app,event,model)
    theta = app.InitialAngledegSlider.Value/360 * 2 * pi;
    model.s0=[0;theta;0;0;0;0];
    model.s = model.s0;
    app.updateAxes(model);
end
