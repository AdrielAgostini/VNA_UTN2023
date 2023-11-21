function [ RefP, PCountsR, MCountsR, TransP, PCountsT, MCountsT ] = acquireData( handles, mode)
%ACQUIREDATA Se encarga de barrer el generador en frecuencia y guardar
% las mediciones.
%
    qFreq       = ':FREQ:CW';
    qAmpl       = ':AMPL:CW';
    forw        = 'FORDWARD' ;
    delay       = 0.008;
    delayADC    = 0.001;
    freqVector  = handles.freqVector;
    v           = handles.v;
    Ard         = handles.Ard;
    Nbits       = 10;                 %N� de bits del ADC
    VRef        = 1800;               %Tension de referencia[mv]
    phasePend   = 10;                 %[mv/�] pendiente de la respuesta de fase
    maxCount    = (2^Nbits -1);
    miniSamples = 1;
    PROM = 0; % activada la promediacion
    
    ModVectorT   = zeros(length(freqVector), 1);   %Vector de los modulos medidos
    PhaseVectorT = zeros(length(freqVector), 1);   %Vector de las fases medidas
    ModVectorR   = zeros(length(freqVector), 1);   %Vector de los modulos medidos
    PhaseVectorR = zeros(length(freqVector), 1);   %Vector de las fases medidas
    fprintf(v, ':AMPLitude:CW 10 dBm');% si no anda cambiar a 9db
    fprintf(v, ':RFO:STAT ON');
    fprintf(v, ':MOD:STAT OFF');
    hbar = waitbar(0,'Progreso de Medici�n');
    writeDigitalPin(Ard,'D11',1)% conecta a RF1
    writeDigitalPin(Ard,'D12',0)%fijarse bien que �pines y en que valor
    writeDigitalPin(Ard,'D13',0)
    for n = 1:length(freqVector)
        tic
        fprintf(v, [qFreq ' ' num2str(freqVector(n)/1000) ' kHz']); %Seteo la frecuencia del Generador
        
        waitbar((n/length(freqVector)),hbar);
        ok = 0;
        
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

           
    if(strcmp(mode,forw)==1)
        

%{
         writeDigitalPin(Ard,'D11',1)% conecta a RF1
        writeDigitalPin(Ard,'D12',0)%fijarse bien que �pines y en que valor
        writeDigitalPin(Ard,'D13',0) 
%}

        %pause(delay);
        
        if (PROM == 1)

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        modAux = 0;
        phaseAux = 0;
        for i = 1:miniSamples
            modAux = modAux + readVoltage(Ard,'A0');
            pause(delayADC);
            phaseAux = phaseAux + readVoltage(Ard,'A1');
            pause(delayADC);
        end
        ModVectorR(n)   = modAux/miniSamples;
        PhaseVectorR(n) = phaseAux/miniSamples;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        else
        pause(delayADC);
        ModVectorR(n)   = readVoltage(Ard, 'A0'); %Lectura del valor de tension modulo (en cuentas)
        pause(delayADC);
        PhaseVectorR(n) = readVoltage(Ard, 'A1'); %Lectura del valor de tension de la fase (en cuentas)
        
        end
        if (PROM == 1)

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        modAux = 0;
        phaseAux = 0;
        for i = 1:miniSamples
            modAux = modAux + readVoltage(Ard,'A2');
            pause(delayADC);
            phaseAux = phaseAux + readVoltage(Ard,'A3');
            pause(delayADC);
        end
        ModVectorT(n)   = modAux/miniSamples;
        PhaseVectorT(n) = phaseAux/miniSamples;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        else
        pause(delayADC);
        ModVectorT(n)   = readVoltage(Ard, 'A2'); %Lectura del valor de tension modulo (en cuentas)
        pause(delayADC);
        PhaseVectorT(n) = readVoltage(Ard, 'A3'); %Lectura del valor de tension de la fase (en cuentas)
            
        end
        
        
        
        
        
     else
     writeDigitalPin(Ard,'D12',1)%conecta a RF2
     writeDigitalPin(Ard,'D11',0)%fijarse bien que �pines y en que valor
     writeDigitalPin(Ard,'D13',1)
     pause(delay);
     
        if (PROM == 1)

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        modAux = 0;
        phaseAux = 0;
        for i = 1:miniSamples
            modAux = modAux + readVoltage(Ard,'A2');
            pause(delayADC);
            phaseAux = phaseAux + readVoltage(Ard,'A3');
            pause(delayADC);
        end
        ModVectorR(n)   = modAux/miniSamples;
        PhaseVectorR(n) = phaseAux/miniSamples;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        else
        pause(delayADC);
        ModVectorR(n)   = readVoltage(Ard, 'A2'); %Lectura del valor de tension modulo (en cuentas)
        pause(delayADC);
        PhaseVectorR(n) = readVoltage(Ard, 'A3'); %Lectura del valor de tension de la fase (en cuentas)
        end         
     
        if (PROM == 1)

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        modAux = 0;
        phaseAux = 0;
        for i = 1:miniSamples
            modAux = modAux + readVoltage(Ard,'A0');
            pause(delayADC);
            phaseAux = phaseAux + readVoltage(Ard,'A1');
            pause(delayADC);
        end
        ModVectorT(n)   = modAux/miniSamples;
        PhaseVectorT(n) = phaseAux/miniSamples;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        else
        pause(delayADC);
        ModVectorT(n)   = readVoltage(Ard, 'A0'); %Lectura del valor de tension modulo (en cuentas)
        pause(delayADC);
        PhaseVectorT(n) = readVoltage(Ard, 'A1'); %Lectura del valor de tension de la fase (en cuentas)
        end
        
    end
    pause(delay);
    toc
    end
    
    fprintf(v, ':RFO:STAT OFF');
    close(hbar);
     writeDigitalPin(Ard,'D12',0)
     writeDigitalPin(Ard,'D11',0)%fijarse bien que �pines y en que valor
     writeDigitalPin(Ard,'D13',0)%fijarse bien que �pines y en que valor

    %Correccion de Fase
   % PCountsR = PhaseVectorR;
    %MCountsR = ModVectorR;
    %PCountsT = PhaseVectorT;
    %MCountsT = ModVectorT;
    RefP    = PhaseVectorR; %ModVectorR.*exp(1i.*PhaseVectorR .*pi./180);%ReVector + (1i*ImVector);              %%Vector del gamma en complejos para el smith
    TransP    = PhaseVectorT; %ModVectorT.*exp(1i.*PhaseVectorT .*pi./180);%ReVector + (1i*ImVector);              %%Vector del gamma en complejos para el smith
    PhaseVectorR = phaseCorrection(PhaseVectorR);
    PhaseVectorT = phaseCorrection(PhaseVectorT);
%     %################################################
    % ModVectorT  = 10.^((0.0599.*ModVectorT -29.9027)./20);%10.^((0.0596.*ModVector -31.014)./20);  %REVISAR % No se que es
    % PhaseVectorT = PhaseVectorT.*(0.176)-180;
    % ModVectorR  = 10.^((0.0599.*ModVectorR -29.9027)./20);%10.^((0.0596.*ModVector -31.014)./20);  %REVISAR % No se que es
    % PhaseVectorR = PhaseVectorR.*(0.176)-180;
     PCountsR = PhaseVectorR;
     PCountsT = PhaseVectorT;
     MCountsT = ModVectorT;
     MCountsR = ModVectorR;
     
end


