%%
names = ["S11 pha", "S21 pha","S12 pha","S22 pha"]
for i = 1 : 4
    a=figure(i);
    plot(pha(:,i),'-o','MarkerSize',3,'MarkerEdgeColor','red');
    grid on
    grid minor
    title(names(i));
    saveas(a,strcat("plot",num2str(i),".pdf"));
end
%%
S_man = F_sC;

S_man ([11,26,42,57,72,73,104,151,135,166,197,213,244,228,260,276,291,297:300],2) = -S_man([11,26,42,57,72,73,104,151,135,166,197,213,244,228,260,276,291,297:300],2);
%%

for i = 1 : 4
    a=figure(i);
    plot(S_man(:,i),'-o','MarkerSize',3,'MarkerEdgeColor','red');
    grid on
    grid minor
    %title(names(i));
    %saveas(a,strcat("plot",num2str(i),".pdf"));
end

%%

%S = S_man;
F_sC = S_man;
%%
S11_open = db2mag(S(:,1)) .* exp(1i * S(:,11) * pi/180);
S11_short = db2mag(S(:,2)) .* exp(1i * S(:,12) * pi/180);
S11_match = db2mag(S(:,3)) .* exp(1i * S(:,13) * pi/180);
S22_open = db2mag(S(:,4)) .* exp(1i * S(:,14) * pi/180);
S22_short = db2mag(S(:,5)) .* exp(1i * S(:,15) * pi/180);
S22_match = db2mag(S(:,6)) .* exp(1i * S(:,16) * pi/180);
S11_thru = db2mag(S(:,7)) .* exp(1i * S(:,17) * pi/180);
S21_thru = db2mag(S(:,8)) .* exp(1i * S(:,18) * pi/180);
S12_thru = db2mag(S(:,9)) .* exp(1i * S(:,19) * pi/180);
S22_thru = db2mag(S(:,10)) .* exp(1i * S(:,20) * pi/180);