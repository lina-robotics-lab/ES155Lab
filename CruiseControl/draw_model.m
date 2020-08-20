

function ax=draw_model(ax,model,target_pos)
        cla(ax);
        
        width = 1.8;
        height = 1.2;
        x = model.s(1)-1/2*width;
        y=0-height;
     
       
        xl = [-10,10]*width;
        yl = [-1.2,1.5]* height;
       
        % Draw Target Position indicator
        plot(ax,target_pos*[1,1],yl,'LineStyle','--','Color','blue','DisplayName','Target Position');
        hold(ax,'on');
        
        % Draw Wheels
        wheel_d = width*0.2; 
        wheel_x = [x+1/5*width,x+3/5*width];
        wheel_y = [1,1]*(y-wheel_d*0.5);
        wheel_spec = [wheel_x(1),wheel_y(1),wheel_d,wheel_d];
                % Use curved rectangle to draw wheels.
        rectangle('Parent',ax, 'Position',wheel_spec,'Curvature',[1 1],'FaceColor','k')
    
        hold(ax,'on');
         
        wheel_spec = [wheel_x(2),wheel_y(2),wheel_d,wheel_d];
        rectangle('Parent',ax, 'Position',wheel_spec,'Curvature',[1 1],'FaceColor','k')
     
        hold(ax,'on');

      
        % Draw Cart Body
        rectangle('Parent',ax,'Position',[x y width height],"FaceColor",[196,154,71]/256,'EdgeColor','None','Curvature',[0.2,0.2])
         hold(ax,'on');
   

        % Draw Ground
        plot(xl,[1 1]*(y-wheel_d/2),'Parent',ax,'Color','k');
         hold(ax,'on');

        % Set Aspect Ratio
        set(ax,'DataAspectRatio',[1 1 1]);
   
        hold(ax,'on');
        
%         legend();
         
        axis(ax,[xl yl]);
        
        set(gca,'ytick',[]);
      
       
% A helper function to do a 2D rotation transformation.
    function [x_rot,y_rot]=rotPoints(origin,theta,x,y)
        x_diff = x-origin(1);
        y_diff = y-origin(2);
        coord_diff = [x_diff;y_diff];
        rot = transpose(origin) + rotMat(theta)*coord_diff;
        x_rot = rot(1,:);
        y_rot = rot(2,:);
        function rm=rotMat(theta)
            rm = [[cos(theta) -sin(theta)];[sin(theta) cos(theta)]];
        end
    end

end