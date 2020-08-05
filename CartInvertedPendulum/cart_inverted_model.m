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
        s0 = [0;0;0;0];
        s = [0;0;0;0];
   end
   % Events detectable by the outside world.
   events
       requestSimulate
       simulationDone
   end
   methods(Access=public)
      function obj = cart_inverted_model(s0,g,mp,l,r,J,gamma,mc,c)
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
          
        obj.M=mc+mp;
        obj.R=mp*r;
        obj.K=J+mp*r^2;
        
           addlistener(obj,'requestSimulate',@(obj,event) requestSimulateCallback(obj,event));
      end
      
      function requestSimulateCallback(obj,event)
%           disp('request received');
          obj.simulate(event.u,event.dt);
          notify(obj,'simulationDone');
      end
      function obj=simulate(obj,u,time_duration)
          % Simulate the system under the influence of input u for
          % time_duration amount of time.
        
        curr_s = obj.s;      
        params = {obj.g, obj.M, obj.R, obj.K, obj.c, obj.gamma} ;

        Tspan = [0 time_duration];
        
        % time domain ODE simulaiton
        [t,new_s] = ode45(@(t,s) stateTransFunc(t,s,u,params),Tspan,curr_s);        
        
        % Update the object state.
        obj.s(:) = new_s(end,:);

        
        % The local helper function
        function xdot=stateTransFunc(t,s,u,params)
            [g, M, R, K, c, gamma] = params{:} ;
            % State vector s=(x,theta, dx/dt,dtheta/dt)
            F = u;
            v = s(3);
            theta = s(2);
            omega = s(4);

            xdot = [0; 0; 0; 0];
            xdot(1)=s(3);
            xdot(2)=s(4);

            xdot(4) = M*gamma*omega - M*g*R*sin(theta) + (F-c*v+R*sin(theta)*omega^2)*R*cos(theta);
            xdot(4) = xdot(4)/(R^2*cos(theta)^2-M*K);

        %     xdot(3) = (R*g*sin(theta)-gamma*omega-K*xdot(4))/(R*cos(theta)) ;
            xdot(3) = R^2*g*sin(theta)*cos(theta)-K*(F-c*v+R*sin(theta)*omega^2)-gamma*R*omega*cos(theta);
            xdot(3) = xdot(3)/(R^2*cos(theta)^2-M*K);
        end
      end
   end
end