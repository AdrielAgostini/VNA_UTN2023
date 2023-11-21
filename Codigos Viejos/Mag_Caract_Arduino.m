Port='COM3';
Board='Nano3';
V_ref=1.8;
Ard=arduino(Port,Board,'AnalogReferenceMode','external','AnalogReference',V_ref);




%% 
PROM=1;
pout=-60;
step=20;
val=0;
val_mat=zeros(60/step,2);
freq=1500;
v = visa('AGILENT', 'USB0::0x0957::0x2018::01152719::0::INSTR');
fopen(v);

fprintf(v, [freq ' ' num2str(freq) ' MHz']);
fprintf(v, [':AMPLitude:CW ' num2str(pout) ' dBm']);
fprintf(v, ':RFO:STAT ON');
fprintf(v, ':MOD:STAT OFF');    

for n=1:step
    pause(5);
    for i = 1:PROM
        val = val + readVoltage(Ard,'A0')
    end
    val_mat(n,1)=pout;
    val_mat(n,2)=val;
    val=0;
    pout=pout+60/step;
    fprintf(v, [':AMPLitude:CW ' num2str(pout) ' dBm']);
end
fclose(v);


direccion='.';
nombre='500 MHZ';

archivo=fopen([direccion '\' nombre '.csv'],'w+');
primeralinea = [num2str(freq) 'KHz'];
fprintf(archivo,'%-21s\n',primeralinea);
 for i=1:size(val_mat,1)
     fprintf(archivo,'%+10.6e\t',val_mat(i,1:end-1));
     fprintf(archivo,'%+10.6e\n',val_mat(i,end));
 end

fclose(archivo);


%%
clc
disp('inicio')

PROM=10;
val=0;
val_mat=zeros(10,1);
for n=1:10
    
    for i = 1:PROM
        pause(0.1)
        val = val + readVoltage(Ard,'A0');
    end
    val=val/PROM;
    disp(val);
    val_mat(n,1)=val;
    val=0;
end
disp('fin')    