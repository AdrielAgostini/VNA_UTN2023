path = "../Mediciones/9_11_23/calibracion/";
file = "cal_conKIT_voltage.csv"; 

ecu_vio_mod=csvread('./Codigos Nuevos/Mag_values_violeta.csv',1,0); %Modulo Violeta
ecu_neg_mod=csvread('./Codigos Nuevos/Mag_values_negro.csv',1,0); %Modulo Negro
freq_ecu_mod=ecu_vio_mod(:,1);
% --Ecuaciones de Fase-- %
ecu_vio_ph=csvread('./Codigos Nuevos/Ph_values_violeta.csv',1,0); %Modulo Violeta
ecu_neg_ph=csvread('./Codigos Nuevos/Ph_values_negro.csv',1,0); %Modulo Negro
freq_ecu_ph=ecu_vio_ph(:,1);

names = ["Freq","S11_o_mod_v","S11_o_pha_v","S11_s_mod_v","S11_s_pha_v","S11_m_mod_v","S11_m_pha_v",...
    "S22_o_mod_v","S22_o_pha_v","S22_s_mod_v","S22_s_pha_v","S22_m_mod_v","S22_m_pha_v",...
    "S11_thru_mod_v","S11_thru_pha_v","S21_thru_mod_v","S21_thru_pha_v",...
    "S12_thru_mod_v","S12_thru_pha_v","S22_thru_mod_v","S22_thru_pha_v"...
    ];

aux_path = string(strcat(path,file));
aux_struct = csvread(aux_path,1);


freqVector = aux_struct(:,1);
measured_v(:,2:21) = aux_struct (:,2:21);
converted_v=zeros(length(freqVector),21);

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
    
    % - S11_Open/Short/Match S11_Thru S12_Thru - %
    converted_v(n,2) = measured_v(n,2) .*ecu_vio_mod(i_m,2)  + ecu_vio_mod(i_m,3);
    converted_v(n,4) = measured_v(n,4) .*ecu_vio_mod(i_m,2)  + ecu_vio_mod(i_m,3);
    converted_v(n,6) = measured_v(n,6) .*ecu_vio_mod(i_m,2)  + ecu_vio_mod(i_m,3);
    converted_v(n,14) = measured_v(n,14) .*ecu_vio_mod(i_m,2)  + ecu_vio_mod(i_m,3);
    converted_v(n,18) = measured_v(n,18) .*ecu_vio_mod(i_m,2)  + ecu_vio_mod(i_m,3); % X * m + b

    converted_v(n,3) = measured_v(n,3) .*ecu_vio_ph(i_p,2)  + ecu_vio_ph(i_p,3);
    converted_v(n,5) = measured_v(n,5) .*ecu_vio_ph(i_p,2)  + ecu_vio_ph(i_p,3);
    converted_v(n,7) = measured_v(n,7) .*ecu_vio_ph(i_p,2)  + ecu_vio_ph(i_p,3);
    converted_v(n,15) = measured_v(n,15) .*ecu_vio_ph(i_p,2)  + ecu_vio_ph(i_p,3);
    converted_v(n,19) = measured_v(n,19) .*ecu_vio_ph(i_p,2)  + ecu_vio_ph(i_p,3);

    % - S22_Open/Short/Match S21_Thru S22_Thru - %
    converted_v(n,8) = measured_v(n,2) .*ecu_neg_mod(i_m,2)  + ecu_neg_mod(i_m,3);
    converted_v(n,10) = measured_v(n,10) .*ecu_neg_mod(i_m,2)  + ecu_neg_mod(i_m,3);
    converted_v(n,12) = measured_v(n,12) .*ecu_neg_mod(i_m,2)  + ecu_neg_mod(i_m,3);
    converted_v(n,16) = measured_v(n,16) .*ecu_neg_mod(i_m,2)  + ecu_neg_mod(i_m,3);
    converted_v(n,20) = measured_v(n,20) .*ecu_neg_mod(i_m,2)  + ecu_neg_mod(i_m,3);

    converted_v(n,9) = measured_v(n,9) .*ecu_neg_ph(i_p,2)  + ecu_vio_ph(i_p,3);
    converted_v(n,11) = measured_v(n,11) .*ecu_neg_ph(i_p,2)  + ecu_vio_ph(i_p,3);
    converted_v(n,13) = measured_v(n,13) .*ecu_neg_ph(i_p,2)  + ecu_vio_ph(i_p,3);
    converted_v(n,17) = measured_v(n,17) .*ecu_neg_ph(i_p,2)  + ecu_vio_ph(i_p,3);
    converted_v(n,21) = measured_v(n,21) .*ecu_neg_ph(i_p,2)  + ecu_vio_ph(i_p,3);

end
%{ 
    Complex Transformation
%}
freqOSM = freqVector;
S11_open= db2mag(converted_v(:,2)) .* exp(1i * converted_v(:,3) * pi/180);
S11_short= db2mag(converted_v(:,4)) .* exp(1i * converted_v(:,5) * pi/180);
S11_match= db2mag(converted_v(:,6)) .* exp(1i * converted_v(:,7) * pi/180);
S22_open= db2mag(converted_v(:,8)) .* exp(1i * converted_v(:,9) * pi/180);
S22_short= db2mag(converted_v(:,10)) .* exp(1i * converted_v(:,11) * pi/180);
S22_match= db2mag(converted_v(:,12)) .* exp(1i * converted_v(:,13) * pi/180);
S11_thru= db2mag(converted_v(:,14)) .* exp(1i * converted_v(:,15) * pi/180);
S21_thru= db2mag(converted_v(:,16)) .* exp(1i * converted_v(:,17) * pi/180);
S12_thru= db2mag(converted_v(:,18)) .* exp(1i * converted_v(:,19) * pi/180);
S22_thru= db2mag(converted_v(:,20)) .* exp(1i * converted_v(:,21) * pi/180);

output_file=string(strcat(path,'/calibration_complex_value1.mat'));
freqOSM=freqVector;
save(output_file,'freqOSM','S11_open','S11_short','S11_match',...
    'S22_open','S22_short','S22_match',...
    'S11_thru','S21_thru','S12_thru','S22_thru');

r= [freqVector,converted_v(:,2:21)];
output_file=string(strcat(path,'measured_converted2.csv'));
writematrix(names,output_file);
writematrix(r,output_file,'WriteMode','append');

%%
%{
    Lo anterior imprime los valores sin determinar la fase. Todos los
    valores de fase son negativos
    A continuacion se intentar determinal el valor de la fase
%}

for m = 3:2:21
   phasevector(:,(m-1)/2)=converted_v(:,m);
end

phasevector_t = phaseCorrection (phasevector);

for m = 3:2:21
   transformed_f (:,m) = phasevector_t(:,(m-1)/2);
end

%{ 
    Complex Transformation
%}
freqOSM = freqVector;
S11_open = db2mag(converted_v(:,2)) .* exp(1i * transformed_f(:,3) * pi/180);
S11_short = db2mag(converted_v(:,4)) .* exp(1i * transformed_f(:,5) * pi/180);
S11_match = db2mag(converted_v(:,6)) .* exp(1i * transformed_f(:,7) * pi/180);
S22_open = db2mag(converted_v(:,8)) .* exp(1i * transformed_f(:,9) * pi/180);
S22_short = db2mag(converted_v(:,10)) .* exp(1i * transformed_f(:,11) * pi/180);
S22_match = db2mag(converted_v(:,12)) .* exp(1i * transformed_f(:,13) * pi/180);
S11_thru = db2mag(converted_v(:,14)) .* exp(1i * transformed_f(:,15) * pi/180);
S21_thru = db2mag(converted_v(:,16)) .* exp(1i * transformed_f(:,17) * pi/180);
S12_thru = db2mag(converted_v(:,18)) .* exp(1i * transformed_f(:,19) * pi/180);
S22_thru = db2mag(converted_v(:,20)) .* exp(1i * transformed_f(:,21) * pi/180);
%---OutputFile With Complex Values---%
 
output_file=string(strcat(path,'/calibration_complex_value2.mat'));

% ----Save Workspace Calibration Values in Complex----- %
%{
    La fase esta precorregida porlo que el error en la fase sigue estando en ciertos puntos
%}
freqOSM=freqVector;
save(output_file,'freqOSM','S11_open','S11_short','S11_match',...
    'S22_open','S22_short','S22_match',...
    'S11_thru','S21_thru','S12_thru','S22_thru');
%%


