% Create cart inverted pendulum simulator
model = defaultModel();

% Create the UI instance. The UI window will pop up automatically.
app = UI();

% Create UI listeners
simulate_duration_dt = 0.08;
addlistener(app,'RequestSimulate',@(app,event) UIRequestCallback(app,event,model,simulate_duration_dt));
addlistener(app,'Reset',@(app,event) ResetCallback(app,event,model));
addlistener(app,'ChangeTargetPosition',@(app,event) TargetPositionCallback(app,event,model));
addlistener(app,'ChangeHillAngle',@(app,event) HillAngleCallback(app,event,model));

% Create simulation model listeners
addlistener(model,'simulationDone',@(model,event) SimulationDoneCallback(app,model,event));

app.updateAxes(model);

function model = defaultModel()
    % Parameters to specify the model dynamics.
    m     = 10;      % mass
    delta = 0;       % Viscocity coefficient, for simplicity, 
                     % assumed to be zero;
    Fhill = 0;       % Assume the vehicle runs on a flat road; 

    V0    = 0;       % initial velocity m/s
    y0  = 0;     % initial location m

    s0 = [y0;V0;0]; % System State: s = [y;v;int_y]
    target_y = 0; % Default Target State

    
    % Magnitude of the process noise to be added to the input
    noise_mag=0;

    % Create the model for cruise control dynamics
    model = cruise_control_model(m,delta,Fhill,s0,target_y,noise_mag);

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
end
function TargetPositionCallback(app,event,model)
    
    model.target_y = app.TargetPositionSlider.Value;
    model.s0=[0;0;0]; % System State: s = [y;v;int_y]
    model.s = model.s0;
    app.updateAxes(model);
end
function HillAngleCallback(app,event,model)
    g = 9.842;
    theta = app.HillAngledegSlider.Value;
    model.Fhill = g * model.m * sin(theta/180*pi);
    view(app.UIAxes,[theta,90]);
end
