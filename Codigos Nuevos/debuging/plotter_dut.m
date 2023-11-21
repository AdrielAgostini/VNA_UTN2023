%{
S(:,1) = mag2db(abs(S11_match));
S(:,2) = mag2db(abs(S11_open));
S(:,3) = mag2db(abs(S11_short));
S(:,4) = mag2db(abs(S22_match));
S(:,5) = mag2db(abs(S22_open));
S(:,6) = mag2db(abs(S22_short));
S(:,7) = mag2db(abs(S11_thru)); 
S(:,8) = mag2db(abs(S21_thru));
S(:,9) = mag2db(abs(S12_thru));
S(:,10) = mag2db(abs(S22_thru));
S(:,11) = angle(S11_match);
S(:,12) = angle(S11_open);
S(:,13) = angle(S11_short);
S(:,14) = angle(S22_match);
S(:,15) = angle(S22_open);
S(:,16) = angle(S22_short);
S(:,17) = angle(S11_thru); 
S(:,18) = angle(S21_thru);
S(:,19) = angle(S12_thru);
S(:,20) = angle(S22_thru);
%}

model = 2;

names = ["S11 mod", "S21 mod","S12 mod","S22 mod",...
 "S11 pha", "S21 pha","S12 pha","S22 pha"]
if model == 1
S = [M_sC , F_sC];
end

if model == 2
%%S = corrected_values ;
end
ylim([-182 182])
for i = 1 : 8
    a=figure(i);
    plot(freqOSM,S(:,i),'-o','MarkerSize',3,'MarkerEdgeColor','red');
    if (i>4)
    ylim([-182 182]);
    end
    grid on
    grid minor
    title(names(i));
    saveas(a,strcat("plot_dut",num2str(i),".pdf"));
end
close all



