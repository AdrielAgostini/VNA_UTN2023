path = "../Mediciones/9_11_23";
%aux = csvread(file,1);

list = dir(fullfile("../Mediciones/9_11_23", '**', '*_voltage.csv'));
file = transpose ({list.name});
folder = transpose ({list.folder});
%%


ecu_vio_mod=csvread('./Codigos Nuevos/Mag_values_violeta.csv',1,0); %Modulo Violeta
ecu_neg_mod=csvread('./Codigos Nuevos/Mag_values_negro.csv',1,0); %Modulo Negro
freq_ecu_mod=ecu_vio_mod(:,1);
% --Ecuaciones de Fase-- %
ecu_vio_ph=csvread('./Codigos Nuevos/Ph_values_violeta.csv',1,0); %Modulo Violeta
ecu_neg_ph=csvread('./Codigos Nuevos/Ph_values_negro.csv',1,0); %Modulo Negro
freq_ecu_ph=ecu_vio_ph(:,1);

for k= 1:length(file)
aux_path = string(strcat(folder(k),'/',file(k)));
aux_struct = csvread(aux_path,1);

freqVector = aux_struct(:,1);
M_v = aux_struct (:,2:5);
F_v = aux_struct (:,6:9);


%Magnitud y Fase s/Corregir
i_m=1;
i_p=1;
for n = 1:length(freqVector)
    while freqVector(n) > freq_ecu_mod(i_m)
        i_m = i_m + 1;
    end
    while freqVector(n) > freq_ecu_ph(i_p)
        i_p = i_p + 1;
    end
    % - Modulo Violeta - %
    M_sC(n,1) = M_v(n,1) .*ecu_vio_mod(i_m,2)  + ecu_vio_mod(i_m,3); % X * m + b
    M_sC(n,3) = M_v(n,3) .*ecu_vio_mod(i_m,2)  + ecu_vio_mod(i_m,3); % X * m + b
    F_sC(n,1) = F_v(n,1) .*ecu_vio_ph(i_p,2)  + ecu_vio_ph(i_p,3); % X * m + b
    F_sC(n,3) = F_v(n,3) .*ecu_vio_ph(i_p,2)  + ecu_vio_ph(i_p,3); % X * m + b

    % - Modulo Negro - %
    M_sC(n,2) = M_v(n,2) .*ecu_neg_mod(i_m,2)  + ecu_neg_mod(i_m,3); % X * m + b
    M_sC(n,4) = M_v(n,4) .*ecu_neg_mod(i_m,2) + ecu_neg_mod(i_m,3); % X * m + b
    F_sC(n,2) = F_v(n,2) .*ecu_neg_ph(i_p,2)  + ecu_vio_ph(i_p,3); % X * m + b
    F_sC(n,4) = F_v(n,4) .*ecu_neg_ph(i_p,2)  + ecu_vio_ph(i_p,3); % X * m + b
end
F_sC_transformed = correcion_fase(F_sC);

mkdir (char(strcat(folder(k),'/DatosProcesados')) );

%Archivo .mat con modulo y fase sin corregir
output_file=string(strcat(folder(k),'/DatosProcesados/','measured_converted.mat'));
freqOSM=freqVector;
save(output_file,'freqOSM','M_sC','F_sC');

%Archivo .mat con modulo y fase sin corregir pero con fase transformada
aux = F_sC;
F_sC = F_sC_transformed;
output_file=string(strcat(folder(k),'/DatosProcesados/','measured_converted_transformed.mat'));
freqOSM=freqVector;
save(output_file,'freqOSM','M_sC','F_sC');
aux = F_sC;





names = ["Freq" "S11_m" "S21_m" "S12_m" "S22_m" "S11_p" "S21_p" "S12_p" "S22_p"];names2 = ["Freq" "S11_m" "S21_m" "S12_m" "S22_m" "S11_p" "S21_p" "S12_p" "S22_p"];

r= [freqVector,M_sC,F_sC_transformed];
r2=[freqVector,M_sC,F_sC];

output_file=string(strcat(folder(k),'/DatosProcesados/','measured_converted.csv'));
output_file2=string(strcat(folder(k),'/DatosProcesados/','measured_converted_notresolve.csv'));

writematrix(names,output_file);
writematrix(r,output_file,'WriteMode','append');

writematrix(names,output_file2);
writematrix(r2,output_file2,'WriteMode','append');

end
display("All files converted");