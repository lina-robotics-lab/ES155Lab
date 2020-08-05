classdef UI_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                    matlab.ui.Figure
        StartSimulationButton       matlab.ui.control.StateButton
        ResetButton                 matlab.ui.control.Button
        InitialAngledegSliderLabel  matlab.ui.control.Label
        InitialAngledegSlider       matlab.ui.control.Slider
        KvSpinnerLabel              matlab.ui.control.Label
        KvSpinner                   matlab.ui.control.Spinner
        KxSpinnerLabel              matlab.ui.control.Label
        KxSpinner                   matlab.ui.control.Spinner
        KthetaSpinnerLabel          matlab.ui.control.Label
        KthetaSpinner               matlab.ui.control.Spinner
        KomegaSpinnerLabel          matlab.ui.control.Label
        KomegaSpinner               matlab.ui.control.Spinner
        TextArea                    matlab.ui.control.TextArea
        ControlModeButtonGroup      matlab.ui.container.ButtonGroup
        ArrowKeyOnlyButton          matlab.ui.control.RadioButton
        PControllerButton           matlab.ui.control.RadioButton
        UIAxes                      matlab.ui.control.UIAxes
        u
        dt
    end
    % The list of events detectable to the outside world.
    events
        Reset
        ChangeInitialAngle
        RequestModelState
    end
    methods (Access = public)
        function updateAxes(app,ext_model)
            draw_model(app.UIAxes,ext_model);
        end
    end
    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
          
        end
        
        

        % Selection changed function: ControlModeButtonGroup
        function ControlModeButtonGroupSelectionChanged(app, event)
            selectedButton = app.ControlModeButtonGroup.SelectedObject;
            
            if selectedButton.Text == "Arrow Key Only"
                setPControllerVisibility(app,"off");
            else
                setPControllerVisibility(app,"on");
            end
            
            % A helper function to set the Visibility of P controller
            % setters.
            function setPControllerVisibility(app,on_off_flag)
                tohide = [app.KvSpinner,app.KvSpinnerLabel,...
                      app.KomegaSpinner,app.KomegaSpinnerLabel,...
                      app.KthetaSpinner,app.KthetaSpinnerLabel,...
                      app.KxSpinner,app.KxSpinnerLabel];
                for h = tohide
                    h.Enable = on_off_flag;
                end
            end
        end

        % Value changed function: StartSimulationButton
        function StartSimulationButtonValueChanged(app, event)
            value = app.StartSimulationButton.Value;
            if app.StartSimulationButton.Value==1
%                 disp('starting')
                % The state has changed to running simulation.
                app.InitialAngledegSlider.Enable='off';
                app.InitialAngledegSliderLabel.Enable='off';
                app.StartSimulationButton.Text = 'Press to Pause';
            else
%                 disp('pausing')
                % The state has changed to pausing.
                app.StartSimulationButton.Text = 'Start Simulation';
            end
                 
            while isprop(app,'StartSimulationButton')==1 && app.StartSimulationButton.Value==1
%                 disp('Request for simulation');
%                 disp(rand());
                notify(app,'RequestModelState');
                pause(app.dt);
            end
           
        end

        % Button pushed function: ResetButton
        function ResetButtonPushed(app, event)
            app.InitialAngledegSlider.Enable='on';
            app.InitialAngledegSliderLabel.Enable='on';
            app.InitialAngledegSlider.Value=0;
            app.StartSimulationButton.Value = 0;
            % Manually call the simulation button changed event. [] means
            % an empty event.
            StartSimulationButtonValueChanged(app,[]);
            notify(app,'Reset');
        end
        function InitialAngledegSliderValueChanging(app, event)
            changingValue = event.Value;
            app.InitialAngledegSlider.Value = changingValue;
            notify(app,'ChangeInitialAngle')
        end
    end

    % Component initialization
    methods (Access = private)
        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 877 554];
            app.UIFigure.Name = 'MATLAB App';

            % Create StartSimulationButton
            app.StartSimulationButton = uibutton(app.UIFigure, 'state');
            app.StartSimulationButton.ValueChangedFcn = createCallbackFcn(app, @StartSimulationButtonValueChanged, true);
            app.StartSimulationButton.Text = 'Start Simulation';
            app.StartSimulationButton.FontSize = 20;
            app.StartSimulationButton.Position = [38 71 157 31];

            % Create ResetButton
            app.ResetButton = uibutton(app.UIFigure, 'push');
            app.ResetButton.ButtonPushedFcn = createCallbackFcn(app, @ResetButtonPushed, true);
            app.ResetButton.FontSize = 20;
            app.ResetButton.Position = [205 71 144 31];
            app.ResetButton.Text = 'Reset';

            % Create InitialAngledegSliderLabel
            app.InitialAngledegSliderLabel = uilabel(app.UIFigure);
            app.InitialAngledegSliderLabel.HorizontalAlignment = 'right';
            app.InitialAngledegSliderLabel.FontSize = 20;
            app.InitialAngledegSliderLabel.Position = [24 424 156 24];
            app.InitialAngledegSliderLabel.Text = 'Initial Angle(deg)';

            % Create InitialAngledegSlider
            app.InitialAngledegSlider = uislider(app.UIFigure);
            app.InitialAngledegSlider.Limits = [0 360];
            app.InitialAngledegSlider.ValueChangingFcn = createCallbackFcn(app, @InitialAngledegSliderValueChanging, true);
            app.InitialAngledegSlider.FontSize = 20;
            app.InitialAngledegSlider.Position = [195 436 194 3];

            % Create KthetaSpinner_2Label
            app.KthetaSpinnerLabel = uilabel(app.UIFigure);
            app.KthetaSpinnerLabel.HorizontalAlignment = 'right';
            app.KthetaSpinnerLabel.FontSize = 20;
            app.KthetaSpinnerLabel.Enable = 'off';
            app.KthetaSpinnerLabel.Position = [226 303 63 24];
            app.KthetaSpinnerLabel.Text = 'Ktheta';
            

            % Create KthetaSpinner
            app.KthetaSpinner = uispinner(app.UIFigure);
            app.KthetaSpinner.FontSize = 20;
            app.KthetaSpinner.Enable = 'off';
            app.KthetaSpinner.Position = [304 302 100 25];
            app.KthetaSpinner.Value = 15.7;

            % Create KxSpinnerLabel
            app.KxSpinnerLabel = uilabel(app.UIFigure);
            app.KxSpinnerLabel.HorizontalAlignment = 'right';
            app.KxSpinnerLabel.FontSize = 20;
            app.KxSpinnerLabel.Enable = 'off';
            app.KxSpinnerLabel.Position = [254 339 34 24];
            app.KxSpinnerLabel.Text = 'Kx ';

            % Create KxSpinner
            app.KxSpinner = uispinner(app.UIFigure);
            app.KxSpinner.FontSize = 20;
            app.KxSpinner.Enable = 'off';
            app.KxSpinner.Position = [303 338 100 25];
            app.KxSpinner.Value = 0.572;

            % Create KvSpinnerLabel
            app.KvSpinnerLabel = uilabel(app.UIFigure);
            app.KvSpinnerLabel.HorizontalAlignment = 'right';
            app.KvSpinnerLabel.FontSize = 20;
            app.KvSpinnerLabel.Enable = 'off';
            app.KvSpinnerLabel.Position = [260 268 29 24];
            app.KvSpinnerLabel.Text = 'Kv';

            % Create KvSpinner
            app.KvSpinner = uispinner(app.UIFigure);
            app.KvSpinner.FontSize = 20;
            app.KvSpinner.Enable = 'off';
            app.KvSpinner.Position = [304 267 100 25];
            app.KvSpinner.Value = 2.12;

            % Create KomegaSpinnerLabel
            app.KomegaSpinnerLabel = uilabel(app.UIFigure);
            app.KomegaSpinnerLabel.HorizontalAlignment = 'right';
            app.KomegaSpinnerLabel.FontSize = 20;
            app.KomegaSpinnerLabel.Enable = 'off';
            app.KomegaSpinnerLabel.Position = [210 230 80 24];
            app.KomegaSpinnerLabel.Text = 'Komega';

            % Create KomegaSpinner
            app.KomegaSpinner = uispinner(app.UIFigure);
            app.KomegaSpinner.FontSize = 20;
            app.KomegaSpinner.Enable = 'off';
            app.KomegaSpinner.Position = [305 229 100 25];
            app.KomegaSpinner.Value = 4.02;

            % Create TextArea
            app.TextArea = uitextarea(app.UIFigure);
            app.TextArea.FontSize = 20;
            app.TextArea.BackgroundColor = [0.9412 0.9412 0.9412];
            app.TextArea.Position = [47 139 316 76];
            app.TextArea.Value = {'Press Left/Right Arrow Key to Directly Apply Forces on the Cart Body'};

            % Create ControlModeButtonGroup
            app.ControlModeButtonGroup = uibuttongroup(app.UIFigure);
            app.ControlModeButtonGroup.SelectionChangedFcn = createCallbackFcn(app, @ControlModeButtonGroupSelectionChanged, true);
            app.ControlModeButtonGroup.Title = 'Control Mode';
            app.ControlModeButtonGroup.FontSize = 20;
            app.ControlModeButtonGroup.Position = [28 281 167 82];

            % Create ArrowKeyOnlyButton
            app.ArrowKeyOnlyButton = uiradiobutton(app.ControlModeButtonGroup);
            app.ArrowKeyOnlyButton.Text = 'Arrow Key Only';
            app.ArrowKeyOnlyButton.FontSize = 20;
            app.ArrowKeyOnlyButton.Position = [11 26 161 23];
            app.ArrowKeyOnlyButton.Value = true;

            % Create PControllerButton
            app.PControllerButton = uiradiobutton(app.ControlModeButtonGroup);
            app.PControllerButton.Text = 'P Controller';
            app.PControllerButton.FontSize = 20;
            app.PControllerButton.Position = [11 4 128 23];

            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFigure);
            title(app.UIAxes, '')
            xlabel(app.UIAxes, 'X')
            ylabel(app.UIAxes, 'Y')
            app.UIAxes.Position = [428 46 428 411];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
    
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = UI_exported()
            % Initialize default control input u.
            app.u = 0;
            app.dt= 1/30;% Update the animation at 24 fps
            
            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
        
        function u=getInput(app,s)
            selectedButton = app.ControlModeButtonGroup.SelectedObject;
            
            if selectedButton.Text == "Arrow Key Only"
                u=app.u;
            else
                % Recall state vector s=(x,theta, dx/dt,dtheta/dt)

                K=[app.KxSpinner.Value,app.KthetaSpinner.Value,app.KvSpinner.Value,app.KomegaSpinner.Value];
                u=app.u + K*s;
            end
        end
    end
end