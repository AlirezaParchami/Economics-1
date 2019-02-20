function Y = draw_plots(t, t2)
leverage_plot = t2(:,1);
P_loss_plot = t2(:,size(t2,2));
figure('Name','Leverage to P_loss')
plot(leverage_plot, P_loss_plot)

t_plot = 1:size(t,1);
volatility_plot = t.Pt;
figure('Name','Volatility')
plot(t_plot, volatility_plot)