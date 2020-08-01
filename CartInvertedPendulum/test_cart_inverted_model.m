g=9.81;
mp=.23;
l=.6413;
r=l/2;
J=1/3*mp*l^2;
gamma=.024;
mc=.38;
c=0.9;


x0 = [0;pi/4;0;0];

model = cart_inverted_model(x0,g,mp,l,r,J,gamma,mc,c);
t0 = 0 ;
dt = 0.1;
t_end = 20;

t = t0;

for i =1:floor((t_end-t0)/dt)
model.simulate(0,dt);
scatter(t,model.s(2));
hold on;
t=t+dt;
pause(dt);
end
hold off;