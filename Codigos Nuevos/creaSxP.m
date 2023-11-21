%ejemplo de uso:
% matriz=[f,variable_modulo,variable_fase]; 
%creaSxP(matriz,'Medicion','.');

function creaSxP(Matriz,nombre,direccion)

primeraLinea='# Hz S RI R 50.000000';

if size(Matriz,2)==3 || size(Matriz,2)==2
    archivo=fopen([direccion convertStringsToChars(nombre) '.s1p'],'w+');
elseif size(Matriz,2)==9 || size(Matriz,2)==5 
    archivo=fopen([direccion '\' nombre '.s2p'],'w+');% estaba con w, pero me parece mejor w+
end

if size(Matriz,2)==2
    mag_matriz = mag2db(abs(Matriz(:,2)));
    angle_matriz = angle(Matriz(:,2)) * 180/pi;
    Matriz (:,2) = mag_matriz;
    Matriz (:,3) = angle_matriz;
    primeraLinea='# Hz S DB R 50.000000';
end

if size(Matriz,2)==5
    mag_matriz = mag2db(abs(Matriz(:,2:5)));
    angle_matriz = angle(Matriz(:,2:5)) * 180/pi;
    Matriz (:,2) = mag_matriz (:,1);
    Matriz (:,3) = angle_matriz (:,1);
    Matriz (:,4) = mag_matriz (:,2);
    Matriz (:,5) = angle_matriz (:,2);
    Matriz (:,6) = mag_matriz (:,3);
    Matriz (:,7) = angle_matriz (:,3);
    Matriz (:,8) = mag_matriz (:,4);
    Matriz (:,9) = angle_matriz (:,4);
    primeraLinea='# Hz S DB R 50.000000';
end

fprintf(archivo,'%-21s\n',primeraLinea);
 for i=1:size(Matriz,1)
     fprintf(archivo,'%+10.6e\t',Matriz(i,1:end-1));
     fprintf(archivo,'%+10.6e\n',Matriz(i,end));
 end
 
 fclose(archivo);
