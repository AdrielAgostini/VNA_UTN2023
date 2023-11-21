path = "../Mediciones/9_11_23/calibracion/";
file = "phase_pretransformed.csv"; 

aux_path = string(strcat(path,file));
aux_struct = csvread(aux_path,1);


freqVector = aux_struct(:,1);


for n = 2:2:length(aux_struct(1,:))-1
    cal_par(:,n/2) = db2mag(aux_struct(:,n)).*exp(1i.*aux_struct(:,n+1).*pi./180);
end

S11_open  = cal_par(:,1);
S11_short = cal_par(:,2);
S11_match = cal_par(:,3);
S22_open  = cal_par(:,4);
S22_short = cal_par(:,5);
S22_match = cal_par(:,6);
S11_thru  = cal_par(:,7);
S21_thru  = cal_par(:,8);
S12_thru  = cal_par(:,9);
S22_thru  = cal_par(:,10);



    %--Calibracion Puerto 1--%
    e00 = S11_match; % directividad puerto 1
    e11 = (S11_open + S11_short -2*e00)./(S11_open - S11_short); %Source match puerto 1
    e10e01 = (-2*(S11_open - e00).*(S11_short - e00))./(S11_open - S11_short); %reflexion tracking puerto 1
    deltae = e00.*e11 - e10e01;
    e22 = (S11_thru - e00)./(S11_thru.*e11 - deltae);% Load Mtach puerto 1
    e30 = zeros(length(freqVector),1); %No calibramos Crosstalk
    e10e32 = (S21_thru-e30).*(1-e11.*e22);

    %--Calibracion Puerto 2--%
    e33_r = S22_match;% Directividad Puerto 2
    e22_r = (S22_open + S22_short -2*e33_r)./(S22_open - S22_short);
    e23e32_r = (-2*(S22_open - e33_r).*(S22_short - e33_r))./(S22_open - S22_short); 
    deltae_r = e33_r.*e22_r - e23e32_r;
    e11_r = (S22_thru - e33_r)./(S22_thru.*e22_r - deltae_r);
    e03_r = zeros(length(freqVector),1); %No calibramos Crosstalk
    e23e01_r = (S12_thru-e03_r).*(1-e22_r.*e11_r);

names = ["Freq","e00","e11","e10e01","deltae","e22","e30","e10e32",...
    "e33_r","e22_r","e23e32_r","deltae_r","e11_r","e03_r","e23e01_r"...
    ];

r= [ freqVector , e00 , e11 , e10e01 , deltae , e22 , e30 , e10e32 ,...
     e33_r , e22_r , e23e32_r , deltae_r , e11_r , e03_r , e23e01_r ...
    ]; 

output_file=string(strcat(path,'erros.csv'));

writematrix(names,output_file);
writematrix(r,output_file,'WriteMode','append');

%%

path = "../Mediciones/9_11_23";

list = dir(fullfile("../Mediciones/9_11_23", '**', '*_converted.csv'));
file = transpose ({list.name});
folder = transpose ({list.folder});



for k= 1:length(file)
    aux_path = string(strcat(folder(k),'/',file(k)));
    aux_struct = csvread(aux_path,1);

    freqVector = aux_struct(:,1);
    M_sC = aux_struct (:,2:5);
    F_sC = aux_struct (:,6:9);

    S11_M = db2mag(M_sC(:,1)).*exp(1i.*F_sC(:,1).*pi./180);
    S12_M = db2mag(M_sC(:,2)).*exp(1i.*F_sC(:,2).*pi./180);
    S21_M = db2mag(M_sC(:,3)).*exp(1i.*F_sC(:,3).*pi./180);
    S22_M = db2mag(M_sC(:,4)).*exp(1i.*F_sC(:,4).*pi./180);

    N11 = (S11_M - e00)./e10e01;
    N12 = (S12_M - e03_r)./e23e01_r;
    N21 = (S21_M - e30)./e10e32; 
    N22 = (S22_M - e33_r)./e23e32_r;
    
    D = (1+N11.*e11).*(1+N22.*e22_r)-N21.*N12.*e22.*e11_r;
    
    S11_C = ((N11.*(1+N22.*e22_r))-e22.*N21.*N12)./D;
    S21_C = (N21.*(1+N22.*(e22_r - e22)))./D;
    S22_C = (N22.*(1+N11.*e11)-e11_r.*N21.*N12)./D;
    S12_C = (N12.*(1+N11.*(e11 - e11_r)))./D;

    corrected_values (:,1)=mag2db(abs(S11_C));
    corrected_values (:,2)=mag2db(abs(S21_C));
    corrected_values (:,3)=mag2db(abs(S12_C));
    corrected_values (:,4)=mag2db(abs(S22_C));

    corrected_values (:,5)= angle(S11_C)*180/pi;
    corrected_values (:,6)= angle(S21_C)*180/pi;
    corrected_values (:,7)= angle(S12_C)*180/pi;
    corrected_values (:,8)= angle(S22_C)*180/pi;

    r= [freqVector,S11_C,S21_C,S12_C,S22_C];
    r2= [freqVector,corrected_values];

    names = ["Freq" "S11_C" "S21_C" "S12_C" "S22_C"];
    names2 = ["Freq" "S11_m" "S21_m" "S12_m" "S22_m" "S11_p" "S21_p" "S12_p" "S22_p"];

    output_file=string(strcat(folder(k),'/','Sparameters_Corrected_Complex.csv'));
    output_file2=string(strcat(folder(k),'/','Sparameters_Corrected_Mag&Pha.csv'));

    writematrix(names,output_file);
    writematrix(r,output_file,'WriteMode','append');    

    writematrix(names2,output_file2);
    writematrix(r2,output_file2,'WriteMode','append');    
end
display("Sparameter generados")