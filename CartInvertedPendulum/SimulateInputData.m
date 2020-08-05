classdef (ConstructOnLoad) SimulateInputData < event.EventData
   properties
      u
      dt
   end
   
   methods
      function data = SimulateInputData(u,dt)
         data.u = u;
         data.dt = dt;
      end
   end
end