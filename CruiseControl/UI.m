classdef UI < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                    matlab.ui.Figure
        StartSimulationButton       matlab.ui.control.StateButton
        ResetCartButton             matlab.ui.control.Button
        TargetPositionSliderLabel  matlab.ui.control.Label
        TargetPositionSlider       matlab.ui.control.Slider
        HillAngledegSliderLabel        matlab.ui.control.Label
        HillAngledegSlider             matlab.ui.control.Slider
        KxSpinnerLabel              matlab.ui.control.Label
        KxSpinner                   matlab.ui.control.Spinner
        KvSpinnerLabel              matlab.ui.control.Label
        KvSpinner                   matlab.ui.control.Spinner
        ControlModeButtonGroup      matlab.ui.container.ButtonGroup
        FreeFallButton          matlab.ui.control.RadioButton
        PDControllerButton           matlab.ui.control.RadioButton
        PIDControllerButton          matlab.ui.control.RadioButton
        UIAxes                      matlab.ui.control.UIAxes
        ResetGainsButton            matlab.ui.control.Button
        ConfirmButton                matlab.ui.control.Button
        ConfirmButton_2                matlab.ui.control.Button
        TypeinTargetPositionEditFieldLabel  matlab.ui.control.Label
        TypeinTargetPositionEditField  matlab.ui.control.NumericEditField
        TypeinHillAngleEditFieldLabel  matlab.ui.control.Label
        TypeinHillAngleEditField       matlab.ui.control.NumericEditField
        KIxSpinnerLabel              matlab.ui.control.Label
        KIxSpinner                   matlab.ui.control.Spinner
        frame_rate
        default_Kx
        default_Kv
        default_KIx 
      end
    % The list of events detectable to the outside world.
    events
        Reset
        ChangeTargetPosition
        ChangeHillAngle
        RequestSimulate
    end
    methods (Access = public)
        function updateAxes(app,ext_model)
            draw_model(app.UIAxes,ext_model,app.TargetPositionSlider.Value);
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
                
                case "No Control"
                    setPDControllerVisibility(app,"off");
                    setIControllerVisibility(app,"off");
                case "PD Controller"
                    setPDControllerVisibility(app,"on");
                    setIControllerVisibility(app,"off");
                    
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
                app.setTargetPositionVisibility('off');
                app.setHillAngleVisibility('off');
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
            app.setTargetPositionVisibility('on');
            app.setHillAngleVisibility("on");
            app.StartSimulationButton.Value = 0;
            app.setControlModeVisibility('on');
            % Manually call the simulation button changed event. [] means
            % an empty event.
            StartSimulationButtonValueChanged(app,[]);
            app.ResetCartButton.Enable = 'off';
      
            notify(app,'Reset');
       end
       function ResetGainsButtonPushed(app,event)
           app.KxSpinner.Value = app.default_Kx;
           app.KvSpinner.Value = app.default_Kv;
           app.KIxSpinner.Value = app.default_KIx;
           end
        function TargetPositionSliderValueChanging(app, event)
            changingValue = event.Value;
            app.TargetPositionSlider.Value = changingValue;
            app.TypeinTargetPositionEditField.Value=changingValue;
            
            notify(app,'ChangeTargetPosition');
        end     
        
         % Value changing function: HillAngledegSlider
        function HillAngledegSliderValueChanging(app, event)
            changingValue = event.Value;
            app.HillAngledegSlider.Value = changingValue;
            app.TypeinHillAngleEditField.Value=changingValue;
            
            notify(app,'ChangeHillAngle');
        end
        
         % Button pushed function: ConfirmButton
        function ConfirmButtonPushed(app, event)
            app.TargetPositionSlider.Value=app.TypeinTargetPositionEditField.Value;
            notify(app,'ChangeTargetPosition');
        end
        
         % Button pushed function: ConfirmButton
        function ConfirmButton_2Pushed(app, event)
            app.HillAngledegSlider.Value=app.TypeinHillAngleEditField.Value;
            notify(app,'ChangeHillAngle');
        end
    end
    
    methods(Access=private)
         % A helper function to set the Visibility of P controller
            % spinner
            function setPDControllerVisibility(app,on_off_flag)
                tohide = [app.KvSpinner,app.KvSpinnerLabel,...
                       app.KxSpinner,app.KxSpinnerLabel,app.ResetGainsButton,...,
                      ];
                for h = tohide
                    h.Enable = on_off_flag;
                end
            end
            function setIControllerVisibility(app,on_off_flag)
                 tohide = [app.KIxSpinner,app.KIxSpinnerLabel];
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
            function setTargetPositionVisibility(app,on_off_flag)
                tohide = [app.TargetPositionSlider,app.TargetPositionSliderLabel,...
                        app.TypeinTargetPositionEditField,app.TypeinTargetPositionEditFieldLabel,...
                        app.ConfirmButton];
                 for h = tohide
                    h.Enable = on_off_flag;
                end    
            end
            
             function setHillAngleVisibility(app,on_off_flag)
                tohide = [app.HillAngledegSlider,app.HillAngledegSliderLabel,...
                        app.TypeinHillAngleEditField,app.TypeinHillAngleEditFieldLabel,...
                        app.ConfirmButton_2];
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
   
   
            % Create TargetPositionSliderLabel
            app.TargetPositionSliderLabel = uilabel(app.UIFigure);
            app.TargetPositionSliderLabel.HorizontalAlignment = 'right';
            app.TargetPositionSliderLabel.FontSize = 14;
            app.TargetPositionSliderLabel.Position = [23 449 111 22];
            app.TargetPositionSliderLabel.Text = 'Target Position';

            % Create TargetPositionSlider
            app.TargetPositionSlider = uislider(app.UIFigure);
            app.TargetPositionSlider.Limits = [-5 5];
            app.TargetPositionSlider.ValueChangingFcn = createCallbackFcn(app, @TargetPositionSliderValueChanging, true);
            app.TargetPositionSlider.FontSize = 14;
            app.TargetPositionSlider.Position = [149 459 177 3];
            
                 % Create HillAngledegSliderLabel
            app.HillAngledegSliderLabel = uilabel(app.UIFigure);
            app.HillAngledegSliderLabel.HorizontalAlignment = 'right';
            app.HillAngledegSliderLabel.FontSize = 14;
            app.HillAngledegSliderLabel.Position = [430 449 97 22];
            app.HillAngledegSliderLabel.Text = 'Hill Angle(deg)';

            % Create HillAngledegSlider
            app.HillAngledegSlider = uislider(app.UIFigure);
            app.HillAngledegSlider.Limits = [-15 15];
            app.HillAngledegSlider.ValueChangingFcn = createCallbackFcn(app, @HillAngledegSliderValueChanging, true);
            app.HillAngledegSlider.FontSize = 14;
            app.HillAngledegSlider.Position = [550 459 177 3];


            % Create KxSpinnerLabel
            app.KxSpinnerLabel = uilabel(app.UIFigure);
            app.KxSpinnerLabel.HorizontalAlignment = 'right';
            app.KxSpinnerLabel.FontSize = 16;
            app.KxSpinnerLabel.Enable = 'off';
            app.KxSpinnerLabel.Position = [209 330 29 22];
            app.KxSpinnerLabel.Text = 'Kx ';

            % Create KxSpinner
            app.KxSpinner = uispinner(app.UIFigure);
            app.KxSpinner.Step = 0.01;
            app.KxSpinner.FontSize = 16;
            app.KxSpinner.Enable = 'off';
            app.KxSpinner.Position = [253 330 100 22];
            app.KxSpinner.Value = app.default_Kx;

            % Create KvSpinnerLabel
            app.KvSpinnerLabel = uilabel(app.UIFigure);
            app.KvSpinnerLabel.HorizontalAlignment = 'right';
            app.KvSpinnerLabel.FontSize = 16;
            app.KvSpinnerLabel.Enable = 'off';
            app.KvSpinnerLabel.Position = [214 290 25 22];
            app.KvSpinnerLabel.Text = 'Kv';

            % Create KvSpinner
            app.KvSpinner = uispinner(app.UIFigure);
            app.KvSpinner.Step = 0.01;
            app.KvSpinner.FontSize = 16;
            app.KvSpinner.Enable = 'off';
            app.KvSpinner.Position = [254 290 100 22];
            app.KvSpinner.Value = app.default_Kv;

                      
             % Create ControlModeButtonGroup
            app.ControlModeButtonGroup = uibuttongroup(app.UIFigure);
            app.ControlModeButtonGroup.SelectionChangedFcn = createCallbackFcn(app, @ControlModeButtonGroupSelectionChanged, true);
            app.ControlModeButtonGroup.Title = 'Control Mode';
            app.ControlModeButtonGroup.FontSize = 16;
            app.ControlModeButtonGroup.Position = [12 260 153 100];


            % Create FreeFallButton
            app.FreeFallButton = uiradiobutton(app.ControlModeButtonGroup);
            app.FreeFallButton.Text = 'No Control';
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
            app.UIAxes.Position = [450 0 350 350];
%             app.UIAxes.Visible = 'off';
%            
            
             % Create ResetGainsButton
            app.ResetGainsButton = uibutton(app.UIFigure, 'push');
            app.ResetGainsButton.Enable = 'off';
            app.ResetGainsButton.Position = [250 200 100 22];
            app.ResetGainsButton.Text = 'Reset Gains';
            app.ResetGainsButton.ButtonPushedFcn = createCallbackFcn(app, @ResetGainsButtonPushed, true);
          
            % Create ConfirmButton
            app.ConfirmButton = uibutton(app.UIFigure, 'push');
            app.ConfirmButton.ButtonPushedFcn = createCallbackFcn(app, @ConfirmButtonPushed, true);
            app.ConfirmButton.Position = [252 392 100 22];
            app.ConfirmButton.Text = 'Confirm';
            
              % Create ConfirmButton_2
            app.ConfirmButton_2 = uibutton(app.UIFigure, 'push');
            app.ConfirmButton_2.ButtonPushedFcn = createCallbackFcn(app, @ConfirmButton_2Pushed, true);
            app.ConfirmButton_2.Position = [660 392 100 22];
            app.ConfirmButton_2.Text = 'Confirm';


            % Create TypeinTargetPositionEditFieldLabel
            app.TypeinTargetPositionEditFieldLabel = uilabel(app.UIFigure);
            app.TypeinTargetPositionEditFieldLabel.HorizontalAlignment = 'right';
            app.TypeinTargetPositionEditFieldLabel.Position = [10 392 110 22];
            app.TypeinTargetPositionEditFieldLabel.Text = 'Type in Target Pos';

            % Create TypeinTargetPositionEditField
            app.TypeinTargetPositionEditField = uieditfield(app.UIFigure, 'numeric');
            app.TypeinTargetPositionEditField.Limits = [-5 5];
            app.TypeinTargetPositionEditField.HorizontalAlignment = 'left';
            app.TypeinTargetPositionEditField.Position = [135 392 100 22];
            
             % Create TypeinHillAngleEditFieldLabel
            app.TypeinHillAngleEditFieldLabel = uilabel(app.UIFigure);
            app.TypeinHillAngleEditFieldLabel.HorizontalAlignment = 'right';
            app.TypeinHillAngleEditFieldLabel.Position = [420 392 98 22];
            app.TypeinHillAngleEditFieldLabel.Text = 'Type in Hill Angle';

            % Create TypeinHillAngleEditField
            app.TypeinHillAngleEditField = uieditfield(app.UIFigure, 'numeric');
            app.TypeinHillAngleEditField.Limits = [-15 15];
            app.TypeinHillAngleEditField.HorizontalAlignment = 'left';
            app.TypeinHillAngleEditField.Position = [530 392 100 22];
            
              % Create KIxSpinnerLabel
            app.KIxSpinnerLabel = uilabel(app.UIFigure);
            app.KIxSpinnerLabel.HorizontalAlignment = 'right';
            app.KIxSpinnerLabel.FontSize = 16;
            app.KIxSpinnerLabel.Enable = 'off';
            app.KIxSpinnerLabel.Position = [209 250 29 22];
            app.KIxSpinnerLabel.Text = 'KIx';

            % Create KIxSpinner
            app.KIxSpinner = uispinner(app.UIFigure);
            app.KIxSpinner.Step = 0.01;
            app.KIxSpinner.FontSize = 16;
            app.KIxSpinner.Enable = 'off';
            app.KIxSpinner.Position = [253 250 100 22];
       
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
            
            app.default_Kx=100;
            app.default_Kv = 50;
            app.default_KIx = 0;
            
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
            target_s = [app.TargetPositionSlider.Value;0;0];
             % Recall state vector s=(x,dx/dt,Ix)
            if selectedButton.Text == "No Control"
                u=0;
            elseif selectedButton.Text == "PD Controller"
                K=[app.KxSpinner.Value,app.KvSpinner.Value,0];
                
                u= -K*(s-target_s);
            elseif selectedButton.Text == "PID Controller"
               K=[app.KxSpinner.Value,app.KvSpinner.Value,app.KIxSpinner.Value];
               u= -K*(s-target_s);
            end
        end
    end
end