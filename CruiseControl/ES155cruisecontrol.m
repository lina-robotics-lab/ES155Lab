function ES155cruisecontrol

%help ode45
%  [t,y] = ode45(@cruisecontrol,[0 20],[2]);
%% open loop and P Control 
%[t,y] = ode45(@cruisecontrol,[0 80],[2;0]);
%% PI Control
[t,y] = ode45(@cruisecontrol,[0 80],[2;0;0]);
%%
subplot(2,1,1);
plot(t,y(:,1))
title('Cruise Control Case 1: no control');
xlabel('Time $t$','Interpreter','latex');
ylabel('Position $y$','Interpreter','latex');
legend('Postion');

subplot(2,1,2);
plot(t,y(:,2)); 
ylim([0,4])

xlabel('Time $t$','Interpreter','latex');
ylabel('Velocity $v$','Interpreter','latex');
legend('Velocity');
end


function dydt = cruisecontrol(t,y)                                                            
m=10;
y_D=1;
%% open loop
% if t<=10
%     F=2;
% else
%     F=0;
% end
% dydt = [y(2); F/m+rand-0.5];
%% P control
%  kp=10;
%  dydt=[y(2); kp*(y_D-y(2))/m];
%% PI control
kp=1;
ki=1;
dydt=[y(2); 1/m*(kp*(y_D-y(2))+ki*y(3)); y_D-y(2)];
end