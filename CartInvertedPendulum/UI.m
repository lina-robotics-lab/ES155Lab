classdef UI < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                    matlab.ui.Figure
        StartSimulationButton       matlab.ui.control.StateButton
        ResetCartButton             matlab.ui.control.Button
        InitialAngledegSliderLabel  matlab.ui.control.Label
        InitialAngledegSlider       matlab.ui.control.Slider
        KxSpinnerLabel              matlab.ui.control.Label
        KxSpinner                   matlab.ui.control.Spinner
        KvSpinnerLabel              matlab.ui.control.Label
        KvSpinner                   matlab.ui.control.Spinner
        KomegaSpinnerLabel          matlab.ui.control.Label
        KomegaSpinner               matlab.ui.control.Spinner
        ControlModeButtonGroup      matlab.ui.container.ButtonGroup
        FreeFallButton          matlab.ui.control.RadioButton
        PDControllerButton           matlab.ui.control.RadioButton
        PIDControllerButton          matlab.ui.control.RadioButton
        UIAxes                      matlab.ui.control.UIAxes
        KthetaSpinnerLabel          matlab.ui.control.Label
        KthetaSpinner               matlab.ui.control.Spinner
        ResetGainsButton            matlab.ui.control.Button
        ConfirmButton                matlab.ui.control.Button
        TypeinInitialAngleEditFieldLabel  matlab.ui.control.Label
        TypeinInitialAngleEditField  matlab.ui.control.NumericEditField
        KIxSpinnerLabel              matlab.ui.control.Label
        KIxSpinner                   matlab.ui.control.Spinner
        KIthetaSpinnerLabel          matlab.ui.control.Label
        KIthetaSpinner               matlab.ui.control.Spinner
        frame_rate
        default_Kx
        default_Ktheta
        default_Kv
        default_Komega
        default_KIx 
        default_KItheta
    end
    % The list of events detectable to the outside world.
    events
        Reset
        ChangeInitialAngle
        RequestSimulate
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
            
%             selectedButton.Text 
            switch selectedButton.Text 
                
                case "Free Fall"
                    setPDControllerVisibility(app,"off");
                    setIControllerVisibility(app,"off");
                case "PD Controller"
                    setPDControllerVisibility(app,"on");
                    setIControllerVisibility(app,"off");
                    
                    app.KIthetaSpinner.Value = app.default_KItheta;
                    app.KIxSpinner.Value = app.default_KIx;
                case "PID Controller"
                    setPDControllerVisibility(app,"on");
                    setIControllerVisibility(app,"on");
            end
        end

        % Value changed function: StartSimulationButton
        function StartSimulationButtonValueChanged(app, event)
            if app.StartSimulationButton.Value==1
               % The state has changed to running simulation.
                
                app.StartSimulationButton.Text = 'Press to Pause';
                app.setPDControllerVisibility('off');
                app.setIControllerVisibility('off');
                app.setControlModeVisibility('off');    
                app.setInitialAngleVisibility('off');
                app.ResetCartButton.Enable = 'on';
            else
                % The state has changed to pausing.
                app.StartSimulationButton.Text = 'Start Simulation';
                app.ControlModeButtonGroupSelectionChanged([]);
            end
            
            % Spin on this loop, keep requesting to simulate forward the
            % model, until the StartSimulationButton is clicked again.
            while isprop(app,'StartSimulationButton')==1 && app.StartSimulationButton.Value==1
                notify(app,'RequestSimulate');
                pause(1/app.frame_rate);
           end
           
        end

        % Button pushed function: ResetButton
       function ResetCartButtonPushed(app, event)
            app.setInitialAngleVisibility('on');
            app.InitialAngledegSlider.Value=0;
            app.StartSimulationButton.Value = 0;
            app.TypeinInitialAngleEditField.Value = 0;
            app.setControlModeVisibility('on');
            % Manually call the simulation button changed event. [] means
            % an empty event.
            StartSimulationButtonValueChanged(app,[]);
            app.ResetCartButton.Enable = 'off';
            notify(app,'Reset');
       end
       function ResetGainsButtonPushed(app,event)
           app.KxSpinner.Value = app.default_Kx;
           app.KthetaSpinner.Value = app.default_Ktheta;
           app.KvSpinner.Value = app.default_Kv;
           app.KomegaSpinner.Value = app.default_Komega;
           app.KIxSpinner.Value = app.default_KIx;
           app.KIthetaSpinner.Value = app.default_KItheta;
        end
        function InitialAngledegSliderValueChanging(app, event)
            changingValue = event.Value;
            app.InitialAngledegSlider.Value = changingValue;
            app.TypeinInitialAngleEditField.Value=changingValue;
            
            notify(app,'ChangeInitialAngle');
        end     
        
         % Button pushed function: ConfirmButton
        function ConfirmButtonPushed(app, event)
            app.InitialAngledegSlider.Value=app.TypeinInitialAngleEditField.Value;
            notify(app,'ChangeInitialAngle');
        end
    end
    
    methods(Access=private)
         % A helper function to set the Visibility of P controller
            % spinner
            function setPDControllerVisibility(app,on_off_flag)
                tohide = [app.KvSpinner,app.KvSpinnerLabel,...
                      app.KomegaSpinner,app.KomegaSpinnerLabel,...
                      app.KthetaSpinner,app.KthetaSpinnerLabel,...
                      app.KxSpinner,app.KxSpinnerLabel,app.ResetGainsButton,...,
                      ];
                for h = tohide
                    h.Enable = on_off_flag;
                end
            end
            function setIControllerVisibility(app,on_off_flag)
                 tohide = [app.KIthetaSpinner,app.KIthetaSpinnerLabel,...
                            app.KIxSpinner,app.KIxSpinnerLabel];
                for h = tohide
                    h.Enable = on_off_flag;
                end
            end
            
            function setControlModeVisibility(app,on_off_flag)
                tohide = [app.FreeFallButton,app.PDControllerButton,app.PIDControllerButton];
                for h = tohide
                    h.Enable = on_off_flag;
                end
            end
            function setInitialAngleVisibility(app,on_off_flag)
                tohide = [app.InitialAngledegSlider,app.InitialAngledegSliderLabel,...
                        app.TypeinInitialAngleEditField,app.TypeinInitialAngleEditFieldLabel,...
                        app.ConfirmButton];
                 for h = tohide
                    h.Enable = on_off_flag;
                end    
            end
    end

    % Component initialization
    methods (Access = private)
     % Create UIFigure and components
        function createComponents(app)
            
            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 868 512];
            app.UIFigure.Name = 'MATLAB App';


            % Create StartSimulationButton
            app.StartSimulationButton = uibutton(app.UIFigure, 'state');
            app.StartSimulationButton.ValueChangedFcn = createCallbackFcn(app, @StartSimulationButtonValueChanged, true);
            app.StartSimulationButton.Text = 'Start Simulation';
            app.StartSimulationButton.FontSize = 16;
            app.StartSimulationButton.Position = [65 92 128 26];

            % Create ResetCartButton
            app.ResetCartButton = uibutton(app.UIFigure, 'push');
            app.ResetCartButton.ButtonPushedFcn = createCallbackFcn(app, @ResetCartButtonPushed, true);
            app.ResetCartButton.FontSize = 16;
            app.ResetCartButton.Position = [204 92 150 26];
            app.ResetCartButton.Text = 'Stop & Save Data';
            app.ResetCartButton.Enable = 'off';
   
            % Create InitialAngledegSliderLabel
            app.InitialAngledegSliderLabel = uilabel(app.UIFigure);
            app.InitialAngledegSliderLabel.HorizontalAlignment = 'right';
            app.InitialAngledegSliderLabel.FontSize = 14;
            app.InitialAngledegSliderLabel.Position = [23 449 111 22];
            app.InitialAngledegSliderLabel.Text = 'Initial Angle(deg)';

            % Create InitialAngledegSlider
            app.InitialAngledegSlider = uislider(app.UIFigure);
            app.InitialAngledegSlider.Limits = [-180 180];
            app.InitialAngledegSlider.ValueChangingFcn = createCallbackFcn(app, @InitialAngledegSliderValueChanging, true);
            app.InitialAngledegSlider.FontSize = 14;
            app.InitialAngledegSlider.Position = [149 459 177 3];

            % Create KxSpinnerLabel
            app.KxSpinnerLabel = uilabel(app.UIFigure);
            app.KxSpinnerLabel.HorizontalAlignment = 'right';
            app.KxSpinnerLabel.FontSize = 16;
            app.KxSpinnerLabel.Enable = 'off';
            app.KxSpinnerLabel.Position = [209 347 29 22];
            app.KxSpinnerLabel.Text = 'Kx ';

            % Create KxSpinner
            app.KxSpinner = uispinner(app.UIFigure);
            app.KxSpinner.Step = 0.01;
            app.KxSpinner.FontSize = 16;
            app.KxSpinner.Enable = 'off';
            app.KxSpinner.Position = [253 347 100 22];
            app.KxSpinner.Value = app.default_Kx;

            % Create KvSpinnerLabel
            app.KvSpinnerLabel = uilabel(app.UIFigure);
            app.KvSpinnerLabel.HorizontalAlignment = 'right';
            app.KvSpinnerLabel.FontSize = 16;
            app.KvSpinnerLabel.Enable = 'off';
            app.KvSpinnerLabel.Position = [214 276 25 22];
            app.KvSpinnerLabel.Text = 'Kv';

            % Create KvSpinner
            app.KvSpinner = uispinner(app.UIFigure);
            app.KvSpinner.Step = 0.01;
            app.KvSpinner.FontSize = 16;
            app.KvSpinner.Enable = 'off';
            app.KvSpinner.Position = [254 276 100 22];
            app.KvSpinner.Value = app.default_Kv;

            % Create KomegaSpinnerLabel
            app.KomegaSpinnerLabel = uilabel(app.UIFigure);
            app.KomegaSpinnerLabel.HorizontalAlignment = 'right';
            app.KomegaSpinnerLabel.FontSize = 16;
            app.KomegaSpinnerLabel.Enable = 'off';
            app.KomegaSpinnerLabel.Position = [175 238 65 22];
            app.KomegaSpinnerLabel.Text = 'Komega';

            % Create KomegaSpinner
            app.KomegaSpinner = uispinner(app.UIFigure);
            app.KomegaSpinner.Step = 0.01;
            app.KomegaSpinner.FontSize = 16;
            app.KomegaSpinner.Enable = 'off';
            app.KomegaSpinner.Position = [255 238 100 22];
            app.KomegaSpinner.Value = app.default_Komega;
                      
             % Create ControlModeButtonGroup
            app.ControlModeButtonGroup = uibuttongroup(app.UIFigure);
            app.ControlModeButtonGroup.SelectionChangedFcn = createCallbackFcn(app, @ControlModeButtonGroupSelectionChanged, true);
            app.ControlModeButtonGroup.Title = 'Control Mode';
            app.ControlModeButtonGroup.FontSize = 16;
            app.ControlModeButtonGroup.Position = [12 260 153 100];


            % Create FreeFallButton
            app.FreeFallButton = uiradiobutton(app.ControlModeButtonGroup);
            app.FreeFallButton.Text = 'Free Fall';
            app.FreeFallButton.FontSize = 16;
            app.FreeFallButton.Position = [11 46 133 22];
            app.FreeFallButton.Value = true;

            % Create PDControllerButton
            app.PDControllerButton = uiradiobutton(app.ControlModeButtonGroup);
            app.PDControllerButton.Text = 'PD Controller';
            app.PDControllerButton.FontSize = 16;
            app.PDControllerButton.Position = [11 27 120 22];
            
             % Create PIDControllerButton
            app.PIDControllerButton = uiradiobutton(app.ControlModeButtonGroup);
            app.PIDControllerButton.Text = 'PID Controller';
            app.PIDControllerButton.FontSize = 16;
            app.PIDControllerButton.Position = [11 6 122 22];


            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFigure);
            title(app.UIAxes, '')
            app.UIAxes.FontSize = 14;
            app.UIAxes.Position = [370 70 413*1.2 374*1.1];

            % Create KthetaSpinnerLabel
            app.KthetaSpinnerLabel = uilabel(app.UIFigure);
            app.KthetaSpinnerLabel.HorizontalAlignment = 'right';
            app.KthetaSpinnerLabel.FontSize = 16;
            app.KthetaSpinnerLabel.Enable = 'off';
            app.KthetaSpinnerLabel.Position = [187 311 52 22];
            app.KthetaSpinnerLabel.Text = 'Ktheta';

            % Create KthetaSpinner
            app.KthetaSpinner = uispinner(app.UIFigure);
            app.KthetaSpinner.Step = 0.01;
            app.KthetaSpinner.FontSize = 16;
            app.KthetaSpinner.Enable = 'off';
            app.KthetaSpinner.Position = [254 311 100 22];
            app.KthetaSpinner.Value = app.default_Ktheta;
            
             % Create ResetGainsButton
            app.ResetGainsButton = uibutton(app.UIFigure, 'push');
            app.ResetGainsButton.Enable = 'off';
            app.ResetGainsButton.Position = [40 176 100 22];
            app.ResetGainsButton.Text = 'Reset Gains';
            app.ResetGainsButton.ButtonPushedFcn = createCallbackFcn(app, @ResetGainsButtonPushed, true);
          
            % Create ConfirmButton
            app.ConfirmButton = uibutton(app.UIFigure, 'push');
            app.ConfirmButton.ButtonPushedFcn = createCallbackFcn(app, @ConfirmButtonPushed, true);
            app.ConfirmButton.Position = [252 392 100 22];
            app.ConfirmButton.Text = 'Confirm';

            % Create TypeinInitialAngleEditFieldLabel
            app.TypeinInitialAngleEditFieldLabel = uilabel(app.UIFigure);
            app.TypeinInitialAngleEditFieldLabel.HorizontalAlignment = 'right';
            app.TypeinInitialAngleEditFieldLabel.Position = [10 392 110 22];
            app.TypeinInitialAngleEditFieldLabel.Text = 'Type in Initial Angle';

            % Create TypeinInitialAngleEditField
            app.TypeinInitialAngleEditField = uieditfield(app.UIFigure, 'numeric');
            app.TypeinInitialAngleEditField.Limits = [-180 180];
            app.TypeinInitialAngleEditField.HorizontalAlignment = 'left';
            app.TypeinInitialAngleEditField.Position = [135 392 100 22];
            
              % Create KIxSpinnerLabel
            app.KIxSpinnerLabel = uilabel(app.UIFigure);
            app.KIxSpinnerLabel.HorizontalAlignment = 'right';
            app.KIxSpinnerLabel.FontSize = 16;
            app.KIxSpinnerLabel.Enable = 'off';
            app.KIxSpinnerLabel.Position = [209 193 29 22];
            app.KIxSpinnerLabel.Text = 'KIx';

            % Create KIxSpinner
            app.KIxSpinner = uispinner(app.UIFigure);
            app.KIxSpinner.Step = 0.01;
            app.KIxSpinner.FontSize = 16;
            app.KIxSpinner.Enable = 'off';
            app.KIxSpinner.Position = [253 193 100 22];

            % Create KIthetaSpinnerLabel
            app.KIthetaSpinnerLabel = uilabel(app.UIFigure);
            app.KIthetaSpinnerLabel.HorizontalAlignment = 'right';
            app.KIthetaSpinnerLabel.FontSize = 16;
            app.KIthetaSpinnerLabel.Enable = 'off';
            app.KIthetaSpinnerLabel.Position = [183 157 56 22];
            app.KIthetaSpinnerLabel.Text = 'KItheta';

            % Create KIthetaSpinner
            app.KIthetaSpinner = uispinner(app.UIFigure);
            app.KIthetaSpinner.Step = 0.01;
            app.KIthetaSpinner.FontSize = 16;
            app.KIthetaSpinner.Enable = 'off';
            app.KIthetaSpinner.Position = [254 157 100 22];


            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = UI()
            % Initialize default control input u.
            app.frame_rate= 15;% Update the animation at frame_rate fps
            
            app.default_Kx=0.572;
            app.default_Ktheta = 15.7;
            app.default_Kv = 2.12;
            app.default_Komega = 4.02;
            app.default_KIx = 0;
            app.default_KItheta=0;
            
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
             % Recall state vector s=(x,theta,I_x,I_theta, dx/dt,dtheta/dt)
            if selectedButton.Text == "Free Fall"
                u=0;
            elseif selectedButton.Text == "PD Controller"
                K=[app.KxSpinner.Value,app.KthetaSpinner.Value,0,0,app.KvSpinner.Value,app.KomegaSpinner.Value];
                u= K*s;
            elseif selectedButton.Text == "PID Controller"
               K=[app.KxSpinner.Value,app.KthetaSpinner.Value,app.KIxSpinner.Value,app.KIthetaSpinner.Value,app.KvSpinner.Value,app.KomegaSpinner.Value];
               u= K*s;
            end
        end
    end
end