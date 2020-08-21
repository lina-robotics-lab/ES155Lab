classdef cruise_control_model<handle
    % The model for the system dynamics concerned with cruise control.
    
    % We must define the class to inherit from 'handle' in order to be able
    % to modify its properties.
   properties
        m;      % Mass of the car
        delta;       % Viscocity coefficient
                         
        Fhill;       % The gravitational force.

        V0;       % initial velocity m/s
        
        s0; % initial state [y0 ; v0 ;int_y0]
        
        s; % System state [y;v;int_y]
        
        target_y; % Reference State to reach.
        
        process_noise_mag;
   end
   % Events detectable by the outside world.
   events
       requestSimulate
       simulationDone
   end
   methods(Access=public)
      function obj = cruise_control_model(m,delta,Fhill,s0,target_y,process_noise_mag)
         obj.m = m;
         
         obj.delta = delta;
         
         obj.Fhill = Fhill;
          
         obj.s0 = s0; % [y,v,int_y]
         
         obj.s = obj.s0; %[y,v,int_y]
         
         obj.target_y = target_y;
         
         obj.process_noise_mag = process_noise_mag;
         
         addlistener(obj,'requestSimulate',@(obj,event) requestSimulateCallback(obj,event));
      end
      
      function requestSimulateCallback(obj,event)
          obj.simulate(event.u,event.dt);
          notify(obj,'simulationDone');
      end
      function obj=simulate(obj,u,time_duration)
          % Simulate the system under the influence of input u for
          % time_duration amount of time.
          
        %         Recall system state = [y,v,int_y]
        curr_s = obj.s;      
        
        params.m = obj.m;
        params.delta = obj.delta;
        params.Fhill = obj.Fhill;
        
        
        Tspan = [0 time_duration];
        
        % time domain ODE simulaiton
        % Adding process noise
        u = u + (rand()-0.5)*obj.process_noise_mag;
        
        [t,new_s_offset] = ode45(@(t,s) stateTransFunc(t,s,u,params),Tspan,curr_s-[obj.target_y;0;0]);        
        
        % Update the object state.
               
        obj.s(:) = new_s_offset(end,:)'+[obj.target_y;0;0];

        
        % The local helper function
        function sdot=stateTransFunc(t,s,u,params)
            % Vehicle dynamcis 
            % t: time;   s: [y;v;int_y] ;  para: system parameters

                m     = params.m;           % mass
                delta = params.delta;       % Viscocity coefficient
                Fhill = params.Fhill;       % 

                % By default, control input is zero.
                Fengine = u;
                
                sdot = zeros(3,1);
                % dynamcis
                sdot(1) = s(2);                              % position part
                sdot(2) = (-delta*s(2) + Fhill + Fengine)/m; % velocity part
                sdot(3) = s(1); % integration part

        end
      end
   end
end