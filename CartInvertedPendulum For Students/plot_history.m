function plot_history(history)
figure;

names = ["$x$","$\theta$","$v$","$\omega$","$\int{x dt}$","$\int{x dt}$","$\int{\theta dt}$"];
data = {history.x,history.theta,history.v,history.omega,history.Ix,history.Itheta};

for i = 1:6
    ax = subplot(3,2,i);
    plot_single_var(ax,history.time,data{i},names(i));
end

set(gcf,"Position",[500 500 1000 1000]);


% A helper function to plot individual variables.
    function plot_single_var(ax,t,y,yname)
        plot(ax,t,y);
        xlabel("time/s");
        title(yname,"Interpreter","latex","fontweight","bold","FontSize",20)
    end
end