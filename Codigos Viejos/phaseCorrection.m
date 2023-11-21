function phase =  phaseCorrection(PhaseVector)
%phaseCorrection Se encarga de procesar las mediciones de fase y trata
%de corregir el problema de la doble pendiente.
% TODO: Realizar más pruebas y probar diferentes métodos.
phase = PhaseVector;
for (n=1:length(PhaseVector) - 4)
        if(PhaseVector(n) < (PhaseVector(n+1)+PhaseVector(n+2)+PhaseVector(n+3)+PhaseVector(n+4))/4)
            phase(n) = -PhaseVector(n);
        end
end
for (n=n:length(PhaseVector))
    if(PhaseVector(n) > phase(n-1))
        phase(n) = -PhaseVector(n-1);
    end
end

PhaseVector = phase;
for (n=2:length(PhaseVector) - 6)
   if(abs(PhaseVector(n) - (phase(n-1))) > 400)
     if (abs(PhaseVector(n) - (phase(n+6)))>400)
        phase(n) = -PhaseVector(n);
     end
   end
end    
PhaseVector = phase;
for (n=2:length(PhaseVector) - 2)
   if(abs(PhaseVector(n) - (phase(n-1))) > 400)
     if (abs(PhaseVector(n) - (phase(n+2)))>400)
        phase(n) = -PhaseVector(n);
     end
   end
end    

PhaseVector = phase;
for (n=2:length(PhaseVector) - 2)
   if(abs(PhaseVector(n) - (phase(n-1))) > 400)
     if (abs(PhaseVector(n) - (phase(n+1)))>400)
        phase(n) = -PhaseVector(n);
     end
   end
end 
end
