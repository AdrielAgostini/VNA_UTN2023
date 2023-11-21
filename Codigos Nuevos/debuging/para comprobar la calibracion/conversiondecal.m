load('C:\Users\adrie\Documents\00_Adriel\00_Facultad\medidas 2\Mediciones\13-11\mats\converted_values_open_p1.mat')
S_mag (:,1) = M_sC(:,1); %Open
S_pha (:,1) = F_sC(:,1);
load('C:\Users\adrie\Documents\00_Adriel\00_Facultad\medidas 2\Mediciones\13-11\mats\converted_values_short_p1.mat')
S_mag (:,2) = M_sC(:,1); %Short
S_pha (:,2) = F_sC(:,1);
load('C:\Users\adrie\Documents\00_Adriel\00_Facultad\medidas 2\Mediciones\13-11\mats\converted_values_load_p1.mat')
S_mag (:,3) = M_sC(:,1); %Match
S_pha (:,3) = F_sC(:,1);


load('C:\Users\adrie\Documents\00_Adriel\00_Facultad\medidas 2\Mediciones\13-11\mats\converted_values_open_p2.mat')
S_mag (:,4) = M_sC(:,4); %Open
S_pha (:,4) = F_sC(:,4);
load('C:\Users\adrie\Documents\00_Adriel\00_Facultad\medidas 2\Mediciones\13-11\mats\converted_values_short_p2.mat')
S_mag (:,5) = M_sC(:,4); %Short
S_pha (:,5) = F_sC(:,4);
load('C:\Users\adrie\Documents\00_Adriel\00_Facultad\medidas 2\Mediciones\13-11\mats\converted_values_load_p2.mat')
S_mag (:,6) = M_sC(:,4); %Match
S_pha (:,6) = F_sC(:,4);

load('C:\Users\adrie\Documents\00_Adriel\00_Facultad\medidas 2\Mediciones\13-11\mats\converted_values_thru.mat')
S_mag (:,7) = M_sC(:,1); %Thru S11
S_mag (:,8) = M_sC(:,2); %Thru S21
S_mag (:,9) = M_sC(:,3); %Thru S12
S_mag (:,10) = M_sC(:,4); %Thru S22
S_pha (:,7) = F_sC(:,1); %Thru S11
S_pha (:,8) = F_sC(:,2); %Thru S21
S_pha (:,9) = F_sC(:,3); %Thru S12
S_pha (:,10) = F_sC(:,4); %Thru S22

freqOSM = transpose(freqVector);

S_pha_corr = correcion_fase(S_pha);

names = ["S11 match", "S11 open","S11 short",...
    "S22 match ", "S22 open ","S22 short",...
    "S11 thru","S21 thru","S12 thru","S22 thru"];

for i = 1 : 10
    a=figure(i);
    plot(freqOSM,S_mag(:,i),'-o','MarkerSize',3,'MarkerEdgeColor','red');
    grid on
    grid minor
    title([names(i), ' mag']);
    saveas(a,strcat("plot",num2str(i),".pdf"));
end
for i = 1 : 10
    a=figure(i);
    plot(freqOSM,S_pha_corr(:,i),'-o','MarkerSize',3,'MarkerEdgeColor','red');
    ylim([-182 182]);
    grid on
    grid minor
    title([names(i), ' pha']);
    saveas(a,strcat("plot",num2str(i+10),".pdf"));
end

S11_open = db2mag(S_mag(:,1)) .* exp(1i * S_pha_corr(:,1) * pi/180);
S11_short = db2mag(S_mag(:,2)) .* exp(1i * S_pha_corr(:,2) * pi/180);
S11_match = db2mag(S_mag(:,3)) .* exp(1i * S_pha_corr(:,3) * pi/180);
S22_open = db2mag(S_mag(:,4)) .* exp(1i * S_pha_corr(:,4) * pi/180);
S22_short = db2mag(S_mag(:,5)) .* exp(1i * S_pha_corr(:,5) * pi/180);
S22_match = db2mag(S_mag(:,6)) .* exp(1i * S_pha_corr(:,6) * pi/180);
S11_thru = db2mag(S_mag(:,7)) .* exp(1i * S_pha_corr(:,7) * pi/180);
S21_thru = db2mag(S_mag(:,8)) .* exp(1i * S_pha_corr(:,8) * pi/180);
S12_thru = db2mag(S_mag(:,9)) .* exp(1i * S_pha_corr(:,9) * pi/180);
S22_thru = db2mag(S_mag(:,10)) .* exp(1i * S_pha_corr(:,10) * pi/180);
