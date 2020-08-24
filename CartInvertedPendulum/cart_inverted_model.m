classdef cart_inverted_model<handle
    % We must define the class to inherit from 'handle' in order to be able
    % to modify its properties.
   properties
        g=9.81;
        mp=.23;
        l=.6413;
        r=0;
        J=0;
        gamma=.024;
        mc=.38;
        c=0.9;
        M=0;
        R=0;
        K=0;
        s0 = [0;0;0;0;0;0];
        s = [0;0;0;0;0;0];
        process_noise_mag=1;
        state_history = [];
        time_stamps = [];
        sim_time = 0;
   end
   % Events detectable by the outside world.
   events
       requestSimulate
       simulationDone
   end
   methods(Access=public)
      function obj = cart_inverted_model(s0,g,mp,l,r,J,gamma,mc,c,process_noise_mag)
          obj.s0 = s0;
          obj.s = s0;
          
          obj.g = g;
          obj.mp = mp;
          obj.l = l;
          obj.r = r;
          obj.J = J;
          obj.gamma = gamma;
          obj.mc = mc;
          obj.c = c;
          
          obj.process_noise_mag=process_noise_mag;
          
        obj.M=mc+mp;
        obj.R=mp*r;
        obj.K=J+mp*r^2;
        
          
        
           addlistener(obj,'requestSimulate',@(obj,event) requestSimulateCallback(obj,event));
           
           % Initialize the state history container.
           obj.resetStateHistory();
      end
      
      function requestSimulateCallback(obj,event)
          obj.simulate(event.u,event.dt);
          notify(obj,'simulationDone');
      end
      function history=getStateHistory(obj)
          history.x = obj.state_history(1,:);
          history.theta = obj.state_history(2,:);
          history.Ix = obj.state_history(3,:);
          history.Itheta=obj.state_history(4,:);
          history.v = obj.state_history(5,:);
          history.omega = obj.state_history(6,:);
          history.time = obj.time_stamps;
      end
      function obj=resetStateHistory(obj)
          obj.state_history = [obj.s0];
          obj.sim_time = 0;
          obj.time_stamps = [obj.sim_time];
      end
      function obj=simulate(obj,u,time_duration)
          % Simulate the system under the influence of input u for
          % time_duration amount of time.
        
        curr_s = obj.s;      
        params = {obj.g, obj.M, obj.R, obj.K, obj.c, obj.gamma} ;

        Tspan = [0 time_duration];
        
        % time domain ODE simulaiton
        % Adding process noise
        u = u + (rand()-0.5)*obj.process_noise_mag;
        [t,new_s] = ode45(@(t,s) stateTransFunc(t,s,u,params),Tspan,curr_s);
        
        % Update the object state.
        obj.sim_time = obj.sim_time+time_duration;
        obj.s(:) = new_s(end,:);
        
        % Record the state after the simulation step.
        obj.state_history = [obj.state_history,obj.s];
        obj.time_stamps = [obj.time_stamps,obj.sim_time];
       
        
        % The local helper function
        function xdot=stateTransFunc(t,s,u,params)
            [g, M, R, K, c, gamma] = params{:} ;
            % State vector s=(x,theta, I_x,I_theta,dx/dt,dtheta/dt) => PID
            F = u;
            
            v = s(5);
            theta = s(2);
            omega = s(6);

            xdot = [0; 0; 0; 0 ; 0 ; 0];
            
            xdot(1)=v;
            xdot(2)=omega;
            xdot(3)=s(1); % I_x
            xdot(4)=s(2); % I_theta

            xdot(6) = M*gamma*omega - M*g*R*sin(theta) + (F-c*v+R*sin(theta)*omega^2)*R*cos(theta);
            xdot(6) = xdot(6)/(R^2*cos(theta)^2-M*K);

        %     xdot(3) = (R*g*sin(theta)-gamma*omega-K*xdot(4))/(R*cos(theta)) ;
            xdot(5) = R^2*g*sin(theta)*cos(theta)-K*(F-c*v+R*sin(theta)*omega^2)-gamma*R*omega*cos(theta);
            xdot(5) = xdot(5)/(R^2*cos(theta)^2-M*K);
        end
      end
   end
end