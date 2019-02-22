x = [1 10 20 30 40 50 60 70 80 90 100];
y1_EUR_Yen = [0.661465 0.720089 0.773314 0.820318 0.860693 0.92183 0.943485 0.967005 0.976479 0.988898 0.995296];
y2_USD_EUR = [0.661465 0.720089 0.773314 0.820318 0.860693 0.894424 0.92183 0.960121 0.967005 0.98082 0.990293];

figure('Name','Leverage to P_loss')
plot(x , y1_EUR_Yen);
hold on
plot(x , y2_USD_EUR);
hold off
xlabel('Leverage')
ylabel('P_L_o_s_s')
%hline = refline([0 0]);
%hline.Color = 'r';
dim = [.6 .1 .2 .2];
str = 'Blue Line = EUR/YEN';
str = [str newline 'Red Line = USD/EUR'];
annotation('textbox',dim,'String',str,'FitBoxToText','on');