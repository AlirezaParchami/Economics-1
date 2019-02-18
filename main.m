% Read File
t = readtable('C:\Users\eng-site04\Downloads\Economics-1-master\Exchange Rate\USD_to_EUR_June1_to_January1.xlsx')
t.EUR_USD = str2double(t.EUR_USD)

% Calculate Daily Volatility (Pt)
Pt = [];
for i = 1:size(t,1)-1
    Pt = [Pt , (t.EUR_USD(i+1) - t.EUR_USD(i))/t.EUR_USD(i) ];
end
Pt = [Pt, t.EUR_USD(end)];
Pt = Pt';
t.Pt = Pt;
