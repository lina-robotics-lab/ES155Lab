function plot_history(history)
figure;

names = ["$y$","$v$","$\int{(y-y_{target}) dt}$"];
data = {history.y,history.v,history.Iy};

for i = 1:3
    ax = subplot(3,1,i);
    plot_single_var(ax,history.time,data{i},names(i));
    if names(i)=="$y$"
        hold(ax,'on');
        plot(ax,history.time([1,end]),[history.target_y,history.target_y],'DisplayName','$y_{target}$');
        legend(ax,'Interpreter','latex','FontSize',20);
    end
end

set(gcf,"Position",[500 500 800 800]);


% A helper function to plot individual variables.
    function plot_single_var(ax,t,y,yname)
        plot(ax,t,y,'DisplayName',yname);
        xlabel("time/s");
        title(yname,"Interpreter","latex","fontweight","bold","FontSize",20)
    end
end