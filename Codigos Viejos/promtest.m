PROM100=60;
PROM50=30;
PROM10=6;
PROM1=1;

muestras=10;

val=0;
val_mat=zeros(51,5);

direccion='.';
nombre='promedio_test'

primeralinea='# P100 P50 P10 P1';

Port='COM11';
Board='Nano3';
V_ref=1.8;
Ard=arduino(Port,Board,'AnalogReferenceMode','external','AnalogReference',V_ref);


for n = 1:muestras
    
    for i = 1:PROM100
        val = val + readVoltage(Ard,'A0');
    end
    val=val/PROM100;
    val_mat(n,1)=n;
    val_mat(n,2)=val;
    disp(val);

    val=0;
    
end

for n = 1:muestras
    
    for i = 1:PROM50
        val = val + readVoltage(Ard,'A0');
    end
    
    val=val/PROM50;
    val_mat(n, 3)=val;
    val=0;
    pause(1);
end

for n = 1:muestras
    
   
    for i = 1:PROM10
        val = val + readVoltage(Ard,'A0');
    end

    val=val/PROM10;
    val_mat(n, 4)=val;
    val=0;
   pause(1.8);
end

for n = 1:muestras
   

    for i = 1:PROM1
        val = val + readVoltage(Ard,'A0');
    end

    val=val/PROM1;
    val_mat(n, 5)=val;
    disp(val);
    val=0;
    
    pause(2);
end


archivo=fopen([direccion '\' nombre '.csv'],'w+');
fprintf(archivo,'%-21s\n',primeralinea);

 for i=1:size(val_mat,1)
     fprintf(archivo,'%+10.6e\t',val_mat(i,1:end-1));
     fprintf(archivo,'%+10.6e\n',val_mat(i,end));
 end

fclose(archivo);
