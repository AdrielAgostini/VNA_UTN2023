C:\Users\adrie\Documents\00_Adriel\00_Facultad\medidas 2\VNA_Scripts\Codigos Nuevos\debuging\para comprobar la calibracion\medicion_calibracion.mv = 0;
Ard = 0;

% ConexiÃ³n Arduino
Port  = 'COM11'; %Poner el COM a donde se conecta el Arduino NANO
Board = 'Nano3';
V_ref = 1.8;

disp('Conectando con Dispositivo Arduino...');
%borro posibles conexiones que estuvieran en el puerto

delete(instrfind({'Port'},{Port}));
Ard=arduino(Port,Board,'AnalogReferenceMode','external','AnalogReference',V_ref);
configurePin(Ard,'D11','DigitalOutput');
configurePin(Ard,'D12','DigitalOutput');
configurePin(Ard,'A0','AnalogInput');
configurePin(Ard,'A1','AnalogInput');
configurePin(Ard,'A2','AnalogInput');
configurePin(Ard,'A3','AnalogInput');
disp('Arduino conectado correctamente.');
%%
disp('Conectando con Generador Agilent...');
v = instrfind('Type', 'visa-usb', 'RsrcName', 'USB0::0x0957::0x2018::01152719::INSTR', 'Tag', '');

if isempty(v)
    v = visa('AGILENT', 'USB0::0x0957::0x2018::01152719::0::INSTR');
else
    fclose(v);
    v = v(1);
end
fopen(v);
disp('Generador Conectado');
%%

mode = 'FORDWARD';
qFreq       = ':FREQ:CW';
qAmpl       = ':AMPL:CW';
forw        = 'FORDWARD' ;         
rev         = 'REVERSE';
ful         = 'FULL';
delay       = 0.05;                  %revisar
delayADC    = 0.01;                %revisar
minFreq     = 30e6;
maxFreq     = 2e9;
sampleNum   = 300;
freqVector  =  linspace(minFreq,maxFreq,sampleNum);
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
msg = msgbox(sprintf(' Modo: %s \n Fmin: %d \n Fmax: %d \n Samples: %d delay: %.4f delayADC: %.4f',...
        mode,minFreq,maxFreq,sampleNum,delay,delayADC));


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
        time(n)=toc;
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
close(hbar);
close(msg);

fprintf(v, ':RFO:STAT OFF');

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

%Conversion a Complejo
gamma_Complex(:,1) = db2mag(M_sC(:,1)) .* exp(1i * F_sC(:,1) * pi/180);
gamma_Complex(:,2) = db2mag(M_sC(:,2)).* exp(1i * F_sC(:,2) * pi/180);
gamma_Complex(:,3) = db2mag(M_sC(:,3)) .* exp(1i * F_sC(:,3) * pi/180);
gamma_Complex(:,4) = db2mag(M_sC(:,4)) .* exp(1i * F_sC(:,4) * pi/180);
%%
[file, path] = uiputfile('./.mat','Exportar Medicion'); %Prompt para guardar archivo

matfile1 = ['voltage_values_',file];
matfile2 = ['converted_values_',file];
matfile3 = ['complex_values_',file];

save([path matfile1],'freqVector','M_v','F_v');
save([path matfile2],'freqVector','M_sC','F_sC');
save([path matfile3],'freqVector','gamma_Complex');


csvfile1 = ['voltage_values_',file(1:end-4),'.csv'];
csvfile2 = ['converted_values_',file(1:end-4),'.csv'];
csvfile3 = ['complex_values_',file(1:end-4),'.csv'];

names1 = ["Freq", "S11_m_v", "S21_m_v", "S12_m_v", "S22_m_v", ...
    "S11_p_v", "S21_p_v", "S12_p_v", "S22_p_v"];
names2 = ["Freq", "S11_m", "S21_m", "S12_m", "S22_m", ...
    "S11_p", "S21_p", "S12_p", "S22_p"];
names3 = ["Freq", "S11", "S21", "S12", "S22"];

r1=[transpose(freqVector),M_v,F_v];
r2=[transpose(freqVector),M_sC,F_sC];
r3=[transpose(freqVector),gamma_Complex];

writematrix(names1, csvfile1 );
writematrix(r1, csvfile1,'WriteMode','append');
writematrix(names2, csvfile2 );
writematrix(r2, csvfile2,'WriteMode','append');
writematrix(names3, csvfile3 );
writematrix(r3, csvfile3,'WriteMode','append');

%%
for i = 1:4
    magplot=figure(i);
    plot(freqVector,M_sC(:,i),'-o','MarkerSize',3,'MarkerEdgeColor','red');
    grid on
    grid minor
    title(names2(i+1));
    saveas(magplot,strcat(file(1:end-4),"_mag_plot",num2str(i),".pdf"));
end

for i = 1:4
    phaplot=figure(i+4);
    plot(freqVector,F_sC(:,i),'-o','MarkerSize',3,'MarkerEdgeColor','red');
    grid on
    grid minor
    title(names2(i+5));
    saveas(phaplot,strcat(file(1:end-4),"_pha_plot",num2str(i),".pdf"));
end

%%
for i = 1:4
    magplot=figure(i);
    plot(freqVector,M_sC(:,i),'-o','MarkerSize',3,'MarkerEdgeColor','red');
    grid on
    grid minor
    title(names2(i+1));
    %saveas(magplot,strcat(file(1:end-4),"_mag_plot",num2str(i),".pdf"));
end

for i = 1:4
    phaplot=figure(i+4);
    plot(freqVector,F_sC(:,i),'-o','MarkerSize',3,'MarkerEdgeColor','red');
    grid on
    grid minor
    title(names2(i+5));
    %saveas(phaplot,strcat(file(1:end-4),"_pha_plot",num2str(i),".pdf"));
end



