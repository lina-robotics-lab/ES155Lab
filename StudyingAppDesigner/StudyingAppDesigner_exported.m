classdef StudyingAppDesigner_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure               matlab.ui.Figure
        PSliderLabel           matlab.ui.control.Label
        PSlider                matlab.ui.control.Slider
        PValueLabel            matlab.ui.control.Label
        UIAxes                 matlab.ui.control.UIAxes
        SimulationStartButton  matlab.ui.control.Button
    end

    
    properties (Access = private)
        simulating = false; % Description
        x = linspace(0,pi,100);
        phase = 0;
        y = 0;
        
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            while true
                    pause(0.2);
                 if isprop(app,'simulating')==1 % Check if the close button is clicked.
                    if ~app.simulating
                        continue;
                    else
                        app.phase=app.phase+1;
                        app.y =  10*sin(2*app.x+app.phase*pi/10)+app.PSlider.Value;
                        plot(app.UIAxes,app.x,app.y);
                        xlim(app.UIAxes,[0 pi]);
                        ylim(app.UIAxes,[0 100]);
                    end
                 else
                     break
                 end
            end
        end

        % Value changing function: PSlider
        function PSliderValueChanging(app, event)
            changingValue = event.Value;
            app.PValueLabel.Text = "P value="+changingValue;
            app.PSlider.Value=changingValue;
        end

        % Button pushed function: SimulationStartButton
        function SimulationStartButtonPushed(app, event)
            app.simulating = ~app.simulating; % Flip the simulating bit.
            if app.simulating
                app.SimulationStartButton.Text='Pause Simulation' ;
            else
                app.SimulationStartButton.Text = "Start Simulation";
            end
            
            
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'MATLAB App';

            % Create PSliderLabel
            app.PSliderLabel = uilabel(app.UIFigure);
            app.PSliderLabel.HorizontalAlignment = 'right';
            app.PSliderLabel.Position = [64 392 25 22];
            app.PSliderLabel.Text = 'P';

            % Create PSlider
            app.PSlider = uislider(app.UIFigure);
            app.PSlider.ValueChangingFcn = createCallbackFcn(app, @PSliderValueChanging, true);
            app.PSlider.Position = [110 401 150 3];

            % Create PValueLabel
            app.PValueLabel = uilabel(app.UIFigure);
            app.PValueLabel.Position = [81 324 126 22];
            app.PValueLabel.Text = 'P Value=';

            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFigure);
            title(app.UIAxes, 'Title')
            xlabel(app.UIAxes, 'X')
            ylabel(app.UIAxes, 'Y')
            app.UIAxes.Position = [35 48 300 185];

            % Create SimulationStartButton
            app.SimulationStartButton = uibutton(app.UIFigure, 'push');
            app.SimulationStartButton.ButtonPushedFcn = createCallbackFcn(app, @SimulationStartButtonPushed, true);
            app.SimulationStartButton.Position = [448 392 100 22];
            app.SimulationStartButton.Text = 'Simulation Start';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = StudyingAppDesigner_exported

            % Create UIFigure and components
            createComponents(app);

            % Register the app with App Designer
            registerApp(app, app.UIFigure);

            % Execute the startup function
            runStartupFcn(app, @startupFcn);

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            
            delete(app.UIFigure);
            
        end
    end
end