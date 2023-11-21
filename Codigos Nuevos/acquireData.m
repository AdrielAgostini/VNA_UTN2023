%{
    Cada matriz contiene los 4 parametros S

  M_sC  Matriz Magnitud  s/Corregir
  M_v   Matriz Magnitud voltage

  F_sC  Matriz Fase  s/Corregir
  F_v   Matriz Fase voltage

  gamma_Complex  Matriz de parametros S en forma compleja
            Columna 1: S11
            Columna 2: S21
            Columna 3: S12
            Columna 4: S22

%}


function [gamma_Complex, M_sC, M_v, F_sC , F_v] = acquireData( handles, mode)
%ACQUIREDATA Se encarga de barrer el generador en frecuencia y guardar
% las mediciones.
%
    qFreq       = ':FREQ:CW';
    qAmpl       = ':AMPL:CW';
    forw        = 'FORDWARD' ;         
    rev         = 'REVERSE';
    ful         = 'FULL';
    delay       = 0.02;                  %revisar
    delayADC    = 0.01;                %revisar
    freqVector  = handles.freqVector;
    v           = handles.v;
    Ard         = handles.Ard;

    PS_Att      =10;                    %[db] Atenuacion del Power Splitter


    % --Ecuaciones de Magnitud-- %

    ecu_vio_mod=csvread('./Codigos Nuevos/Mag_values_violeta.csv',1,0); %Modulo Violeta
    ecu_neg_mod=csvread('./Codigos Nuevos/Mag_values_negro.csv',1,0); %Modulo Negro
    freq_ecu_mod=ecu_vio_mod(:,1);
    % --Ecuaciones de Fase-- %
    ecu_vio_ph=csvread('./Codigos Nuevos/Ph_values_violeta.csv',1,0); %Modulo Violeta
    ecu_neg_ph=csvread('./Codigos Nuevos/Ph_values_negro.csv',1,0); %Modulo Negro
    freq_ecu_ph=ecu_vio_ph(:,1);




    M_sC    = zeros(length(freqVector), 4);  
    M_v     = zeros(length(freqVector), 4);   
   
    F_sC    = zeros(length(freqVector), 4);  
    F_v     = zeros(length(freqVector), 4);   

    gamma_Complex = zeros(length(freqVector), 4);


    fprintf(v, [':AMPLitude:CW ' num2str(PS_Att) ' dBm']);
    pause(delay);
    fprintf(v, ':RFO:STAT ON');
    pause(delay);
    fprintf(v, ':MOD:STAT OFF');
    pause(delay);
    hbar = waitbar(0,'Progreso de Medicion');

    if(strcmp(mode,forw)==1 || strcmp(mode,ful)==1)
        writeDigitalPin(Ard,'D11',1) %Foward ON
        writeDigitalPin(Ard,'D12',0) %Reverse OFF    
        for n = 1:length(freqVector)
            tic;
            fprintf(v, [qFreq ' ' num2str(freqVector(n)/1000) ' kHz']); %Seteo la frecuencia del Generador
            waitbar((n/length(freqVector)),hbar);
            pause(delay);
    %{
    while(ok == 0)%% fijarse si comentando el while anda
                fprintf(v,':FREQuency:CW?');
            answer = str2num(fscanf(v));

            if((answer - freqVector(n))<10)
                    ok = 1;
            else
                    fprintf(v, [qFreq ' ' num2str(freqVector(n)/1000) ' kHz']);
                    pause(0.01);
                    %TODO: Time out y finalizacion incompleta de medicion..
                end
            end 
    %}
            M_v(n,1)    = readVoltage(Ard, 'A0'); %Lectura Magnitud S11 
            pause(delayADC);
            F_v(n,1)    = readVoltage(Ard, 'A1'); %Lectura Fase S11
            pause(delayADC);
            M_v(n,2)    = readVoltage(Ard, 'A2'); %Lectura Magnitud S21
            pause(delayADC);
            F_v(n,2)    = readVoltage(Ard, 'A3'); %Lectura Fase S21
            pause(delayADC);  
            a(n)=toc;
        end  
    end    
        
        
        
    if(strcmp(mode,rev)==1 || strcmp(mode,ful)==1)
        writeDigitalPin(Ard,'D11',0) %Foward OFF
        writeDigitalPin(Ard,'D12',1) %Reverse ON    
        for n = 1:length(freqVector)
            tic;
            fprintf(v, [qFreq ' ' num2str(freqVector(n)/1000) ' kHz']); %Seteo la frecuencia del Generador
            waitbar((n/length(freqVector)),hbar);
            pause(delay);
    %{
    while(ok == 0)%% fijarse si comentando el while anda
                fprintf(v,':FREQuency:CW?');
            answer = str2num(fscanf(v));

            if((answer - freqVector(n))<10)
                    ok = 1;
            else
                    fprintf(v, [qFreq ' ' num2str(freqVector(n)/1000) ' kHz']);
                    pause(0.01);
                    %TODO: Time out y finalizacion incompleta de medicion..
                end
            end 
    %}
            M_v(n,3)    = readVoltage(Ard, 'A0'); %Lectura Magnitud S12 
            pause(delayADC);
            F_v(n,3)    = readVoltage(Ard, 'A1'); %Lectura Fase S12
            pause(delayADC);
            M_v(n,4)    = readVoltage(Ard, 'A2'); %Lectura Magnitud S22
            pause(delayADC);
            F_v(n,4)    = readVoltage(Ard, 'A3'); %Lectura Fase S22
            pause(delayADC);  
            b(n)=toc;
        end  
    end    
    
    fprintf(v, ':RFO:STAT OFF');
    close(hbar);
    writeDigitalPin(Ard,'D11',0)    %Forward OFF
    writeDigitalPin(Ard,'D12',0)    %Reverse OFF

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
        M_sC(n,4) = M_v(n,4) .*ecu_neg_mod(i_m,2)  + ecu_neg_mod(i_m,3); % X * m + b
        F_sC(n,2) = F_v(n,2) .*ecu_neg_ph(i_p,2)  + ecu_vio_ph(i_p,3); % X * m + b
        F_sC(n,4) = F_v(n,4) .*ecu_neg_ph(i_p,2)  + ecu_vio_ph(i_p,3); % X * m + b
    end

    F_sC_transformed = correcion_fase(F_sC);

    %Conversion a Complejo
    gamma_Complex(:,1) = db2mag(M_sC(:,1)) .* exp(1i * F_sC_transformed(:,1) * pi/180);
    gamma_Complex(:,2) = db2mag(M_sC(:,2)).* exp(1i * F_sC_transformed(:,2) * pi/180);
    gamma_Complex(:,3) = db2mag(M_sC(:,3)) .* exp(1i * F_sC_transformed(:,3) * pi/180);
    gamma_Complex(:,4) = db2mag(M_sC(:,4)) .* exp(1i * F_sC_transformed(:,4) * pi/180);
end


