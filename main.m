% Read File
t = readtable('D:\University Cources\Term 8\Projects\Economics-1\Exchange Rate\test.xlsx');
t.EUR_USD = str2double(t.EUR_USD);

% Calculate Daily Volatility (Pt)
Pt = [];
abs_Pt = [];
for i = 1:size(t,1)-1
    tmp = (t.EUR_USD(i+1) - t.EUR_USD(i))/t.EUR_USD(i);
    Pt = [Pt , tmp ];
    abs_Pt = [abs_Pt , abs(tmp)];
end
%Pt = [Pt, t.EUR_USD(end)];
Pt = [Pt, 0];
abs_Pt = [abs_Pt, 0];

Pt = Pt';
abs_Pt = abs_Pt';

t.Pt = Pt;
t.abs_Pt = abs_Pt;

g = 0.0001;
L_array = [1 10 20 30 40 50 60 70 80 90 100];
%L_array = [100 1000];
t2 = table(L, g ,P, q, P_E, P_F, P_h, P_l, n0, q+n0, P_loss_E, P_loss_F, P_loss);
for L = L_array
    entry = [L g];
    eq17_values = L * (t.abs_Pt + g);
    q_h = eq17_values(find(eq17_values >= 1));
    q_l = setdiff(eq17_values , q_h);
    q = size( q_h , 1 );
    entry = [entry, q];
    
    
end
t2
