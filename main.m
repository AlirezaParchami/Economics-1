fprintf('Depend on your demand, Pay attention to n0 formula.')
% Read File
%t = readtable('D:\University Cources\Term 8\Projects\Economics-1\Exchange Rate\EUR_to_Yen_June1_to_January1.xlsx');
t =  readtable('C:\Users\Alireza\Desktop\DEXUSEU.xlsx');
t.Properties.VariableNames = {'date' 'exchange'};
if isequal(class(t.exchange(2)) , 'cell')
    t.exchange = str2double(t.exchange);
end
digits(6)
t = rmmissing(t);
% Calculate Daily Volatility (Pt)
Pt = [];
for i = 1:size(t,1)-1
    Pt = [Pt , vpa((t.exchange(i+1) - t.exchange(i))/t.exchange(i) ) ];
end
t( size(t,1) , : ) = [];  %Delete last row of t
t.Pt = Pt';
t.abs_Pt = abs(t.Pt);
g = vpa(0.0001);

% Operands on Pt
digits(6)
fprintf('Geomean of Pt: %g\n', geomean(t.abs_Pt))
fprintf('Mean of Pt: %g\n', mean(t.Pt))
fprintf('Standard Derivation of Pt: %g\n', std(t.Pt))
fprintf('Mode of Pt: %g\n', mode(t.Pt))
fprintf('Number of Positive Records of Pt: %g\n', size( find(t.Pt >= 0), 1))
fprintf('Number of Negative Records of Pt: %g\n', size( find(t.Pt < 0), 1))
fprintf('Skewness of Pt: %g\n', skewness(double(t.Pt)))
fprintf('Kurtosis of Pt: %g\n', kurtosis(double(t.Pt)))
edges = [-0.1 -0.01:0.002:0.01 0.1]
h = histogram(double(t.Pt),edges)

%L_array = [1 10 20 30 40 50 60 70 80 90 100];
L_array = [1 20 40 60 80];
inf_array = [0.024 0.03];
inf_lev_n0_table = [];
inf_lev_Ploss_table = [];
inf_lev_n0_table = [inf_lev_n0_table vpa(inf_array)];
inf_lev_Ploss_table = [inf_lev_Ploss_table vpa(inf_array)];
t2 = [];
for L = L_array
    inf_lev_n0_row = [];
    inf_lev_Ploss_row = [];
    fprintf('L= %d\n' ,L);
    entry = [L g];
    eq17_values = L * (t.abs_Pt + g);
    
    q_h = t.abs_Pt(find(eq17_values >= 1));
    fprintf('Number of high frequency days: %d\n', size(q_h,1))
    %q_l = setdiff(t.abs_Pt , q_h, 'stable');
    q_l = t.abs_Pt(~ismember(t.abs_Pt, q_h));
    fprintf('Number of low frequency days: %d\n', size(q_l,1))
    q = size( q_h , 1 );
    entry = [entry, q];
    
    P = mean(t.abs_Pt);
    P_h = mean(q_h);
    %if size(q_h) == 0, P_h goes to be NAN
    if isequal( size(q_h,1) , 0)
        P_h = 0;
    end
    P_l = mean(q_l);
    if isequal( size(q_l,1) , 0)
        P_l = 0;
    end
    P_E = 1 - power( vpa(0.5) , q );
    P_F = 1 - P_E;
    entry = [entry, P, P_E, P_F];
    
    for infl = inf_array
        fprintf('inflation = %g\n', infl)
        N = size(t, 1);
        if isequal( (1 + L * P_h - L*g) , 0 )
            fprintf('1-n0\n')
            n0 = (((q - N)*log(1 - L * P_l - L * g)) + 20* log(1 + infl)) / ( log(1 + L * P_l - L * g) - log(1 - L * P_l - L * g) );
            %n0 = ((q - N)*log(1 - L * P_l - L * g)) / ( log(1 + L * P_l - L * g) - log(1 - L * P_l - L * g) );
        elseif isequal( (1 - L * P_l - L * g) , 0 )
            fprintf('2-n0\n')
            n0 = ((-q * log(1 + L * P_h - L * g))+ 20* log(1 + infl)) / ( log(1 + L * P_l - L * g) - log(1 - L * P_l - L * g) );
        else
            fprintf('3-n0\n')
            n0 = (((q - N) * log(1 - L * P_l - L * g) - q * log(1 + L * P_h - L * g)) + 20* log(1 + infl)) / ( log(1 + L * P_l - L * g) - log(1 - L * P_l - L * g) );
        end
        fprintf('n0 = %g\n', n0)
        n0 = floor(n0);
        P_loss_E = 1;
        P_loss_F = 0;
        for i = 0:n0
            P_loss_F = vpa( P_loss_F + (nchoosek(N-q , i) * power(0.5 , N-q)) );
        end
        P_loss = (P_E * P_loss_E) + (P_F * P_loss_F);
        %why?
%         if isequal( size(q_h,1) , 0)
%             P_h = nan;
%         elseif (isequal( size(q_l, 1) , 0 ) )
%             P_l = nan;
%         end
    
        entry2 = [entry , P_h, P_l, vpa(infl), n0 , P_loss_E , P_loss_F , P_loss];
        t2 = [t2;entry2];
        inf_lev_n0_row = [inf_lev_n0_row n0];
        inf_lev_Ploss_row = [inf_lev_Ploss_row P_loss];
    end
disp('---------------------------------------------')
inf_lev_n0_table = [inf_lev_n0_table; inf_lev_n0_row];
inf_lev_Ploss_table = [inf_lev_Ploss_table; inf_lev_Ploss_row];
end
final_table_columns_name = {'Leverage' 'g' 'q' 'P' 'P_E' 'P_F' 'P_h' 'P_l' 'inf' 'n_0' 'P_loss_E' 'P_loss_F' 'P_loss'}
inf_lev_table_column = ["leverage/inflation"; L_array']

inf_lev_n0_table = [inf_lev_table_column inf_lev_n0_table]
inf_lev_Ploss_table = [inf_lev_table_column inf_lev_Ploss_table]
t2 = [final_table_columns_name;t2]
%xlswrite('D:\University Cources\Term 8\Projects\Economics-1\Results\EUR_to_Yen.xls', t5 )
%draw_plots(t, t2)
