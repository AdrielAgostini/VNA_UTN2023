%ejemplo de uso:
% matriz=[f,variable_modulo,variable_fase]; 
%creaSxP(matriz,'Medicion','.');

function creaSxP(Matriz,nombre,direccion)

primeraLinea='# Hz S RI R 50.000000';

if size(Matriz,2)==3
    archivo=fopen([direccion '\' nombre '.s1p'],'w+');
elseif size(Matriz,2)==9
    archivo=fopen([direccion '\' nombre '.s2p'],'w+');% estaba con w, pero me parece mejor w+
end

fprintf(archivo,'%-21s\n',primeraLinea);
 for i=1:size(Matriz,1)
     fprintf(archivo,'%+10.6e\t',Matriz(i,1:end-1));
     fprintf(archivo,'%+10.6e\n',Matriz(i,end));
 end
 
 fclose(archivo);
