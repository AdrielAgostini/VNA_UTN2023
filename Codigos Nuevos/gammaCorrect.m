%{
    GAMMACORRECT Aplica algoritmo de correccion al Gamma
    Parametros: 
        gamma_Complex: Vector parametros S medidos del DUT (complejos)
        cal_par: Vector con parametros S de calibracion (complejos)
    Return:
        gamma_Complex_Corr: Vector de parametros S corregidos DUT (complejos)
        gamma_Corr: Vector de parametros S corregidos UDT (Modulo y Fase)
            8 columnas con orden: S11, S21, S12 y S22 
            Cada parametro esta ordenado en modulo y fase
%}
function [gamma_Complex_Corr, gamma_Corr] = gammaCorrect(gamma_Complex, cal_par)

    %--Parametros DUT--%
    S11_M = gamma_Complex(:,1);
    S21_M = gamma_Complex(:,2);
    S12_M = gamma_Complex(:,3);
    S22_M = gamma_Complex(:,4);

    %--Parametros Calibracion--%
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
    e30 = 0; %No calibramos Crosstalk
    e10e32 = (S21_thru-e30).*(1-e11.*e22);

    %--Calibracion Puerto 2--%
    e33_r = S22_match;% Directividad Puerto 2
    e22_r = (S22_open + S22_short -2*e33_r)./(S22_open - S22_short);
    e23e32_r = (-2*(S22_open - e33_r).*(S22_short - e33_r))./(S22_open - S22_short); 
    deltae_r = e33_r.*e22_r - e23e32_r;
    e11_r = (S22_thru - e33_r)./(S22_thru.*e22_r - deltae_r);
    e03_r = 0; %No calibramos Crosstalk
    e23e01_r = (S12_thru-e03_r).*(1-e22_r.*e11_r);
     
    N11 = (S11_M - e00)./e10e01;
    N12 = (S12_M - e03_r)./e23e01_r;
    N21 = (S21_M - e30)./e10e32; 
    N22 = (S22_M - e33_r)./e23e32_r;
    
    D = (1+N11.*e11).*(1+N22.*e22_r)-N21.*N12.*e22.*e11_r;
    
    S11_C = ((N11.*(1+N22.*e22_r))-e22.*N21.*N12)./D;
    S21_C = (N21.*(1+N22.*(e22_r - e22)))./D;
    S22_C = (N22.*(1+N11.*e11)-e11_r.*N21.*N12)./D;
    S12_C = (N12.*(1+N11.*(e11 - e11_r)))./D;


    %--Conversion a modulo y fase--%
    S11_C_mod = abs(S11_C);
    S21_C_mod = abs(S21_C);
    S12_C_mod = abs(S12_C);
    S22_C_mod = abs(S22_C);

    S11_C_ph = angle(S11_C);
    S21_C_ph = angle(S21_C);
    S12_C_ph = angle(S12_C);
    S22_C_ph = angle(S22_C);


    %--Retorno de resultados--%
    gamma_Complex_Corr(:,1) = S11_C;
    gamma_Complex_Corr(:,2) = S21_C;
    gamma_Complex_Corr(:,3) = S12_C;
    gamma_Complex_Corr(:,4) = S22_C;

    gamma_Corr(:,1) = S11_C_mod;
    gamma_Corr(:,2) = S11_C_ph;
    gamma_Corr(:,3) = S21_C_mod;
    gamma_Corr(:,4) = S21_C_ph;
    gamma_Corr(:,5) = S12_C_mod;
    gamma_Corr(:,6) = S12_C_ph;
    gamma_Corr(:,7) = S22_C_mod;
    gamma_Corr(:,8) = S22_C_ph;
    

    errors_mat(:,1) = e00;
    errors_mat(:,2) = e11;
    errors_mat(:,3) = e10e01;
    errors_mat(:,4) = deltae;
    errors_mat(:,5) = e22;
    errors_mat(:,6) = e30;
    errors_mat(:,7) = e10e32;
    errors_mat(:,8) = e33_r;
    errors_mat(:,9) = e22_r;
    errors_mat(:,10) = e23e32_r;
    errors_mat(:,11) = deltae_r;
    errors_mat(:,12) = e11_r;
    errors_mat(:,13) = e03_r;
    errors_mat(:,14) = e23e01_r;
    errors_mat(:,15) = N11;
    errors_mat(:,16) = N12;
    errors_mat(:,17) = N21;
    errors_mat(:,18) = N22;
    errors_mat(:,19) = D;
    column_name = ["e00","e11","e10e01","deltae","e22","e30","e10e32",...
        "e33_r","e22_r","e23e32_r","deltae_r","e11_r","e03_r","e23e01_r",...
        "N11","N12","N21","N22","D"];
    
    errors_mat_complete = [column_name(1,:) ; errors_mat(:,:)];

    writematrix(errors_mat_complete,'./temp/forDebug/errors.csv');
    save('./temp/forDebug/errors.mat',"errors_mat_complete");



% Algoritmo de Correccion
%     e00    = gammaMatch;                        %Directivity
%     e11 = (gammaS.*(gammaOpen - gammaMatch)- gammaO.*(gammaShort - gammaMatch))./(gammaS.*gammaO.*(gammaOpen - gammaShort));
%     e10 = ((gammaO-gammaS).*(gammaOpen-gammaMatch).*(gammaShort-gammaMatch))./(gammaS.*gammaO.*(gammaOpen - gammaShort));
%     gamma = (gamma_M - e00)./(e10+e11.*(gamma_M - e00));  %Vector final corregido
%TODO Revisar:    
%Smooth parte real e imaginaria
%   gamma = smooth(real(gamma),'sgolay',3) + 1i*smooth(imag(gamma),'sgolay',3);         %Vector de la parte real

%Correccion valores nulos

%         for(n = 1:length(gamma))
%         if(isnan(gamma(n)))
%             gamma(n)=gamma(n-1);
%         end
%     end
%end


