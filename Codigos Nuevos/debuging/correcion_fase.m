
%phaseCorrection Se encarga de procesar las mediciones de fase y trata
%de corregir el problema de la doble pendiente.
% TODO: Realizar más pruebas y probar diferentes métodos.

function [phase] = correcion_fase (PhaseVector)
phase = PhaseVector;
for k = 1:4
for n = 1:length(PhaseVector) - 4
        if(PhaseVector(n,k) < (PhaseVector(n+1,k)+PhaseVector(n+2,k)+PhaseVector(n+3,k)+PhaseVector(n+4,k))/4)
            phase(n,k) = -PhaseVector(n,k);
        end
end
end
%{
phase2 = PhaseVector;
m=0
sum = 0
for n = 2:length(PhaseVector) 
    aux=phase2(n) * phase2 (n-1);
    if (phase2(n-1)<0 && phase2 (n)>0)
        delta(n) = 360 - abs(phase2(n)) - abs(phase2 (n-1));
    else
        delta(n) = abs(phase2(n) - phase2 (n-1));
    end
    delta_prom = mean (delta(2:end));  
    if (delta (n) < (delta_prom*0.8) )
        phase2 (n) = -phase2(n);
        aux=phase2(n) * phase2 (n-1);
        %{
        if (aux < 0)
            delta(n) = 360 - abs(phase2(n)) - abs(phase2 (n-1));
        else
            delta(n) = abs(phase2(n) - phase2 (n-1));
        end
        if (delta (n) > (delta_prom*1.2))
            phase2 (n) = -phase2(n);
        end
        %}
    end
end
%}