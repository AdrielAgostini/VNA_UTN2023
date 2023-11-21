%phaseCorrection Se encarga de procesar las mediciones de fase y trata
%de corregir el problema de la doble pendiente.
% TODO: Realizar más pruebas y probar diferentes métodos.

function [phase] = correcion_fase_test (PhaseVector)
    phase = PhaseVector;
    for k = 1:10
    for n = 9:length(PhaseVector) - 8
            for i = -8:-2
                m_prev(i+9) = PhaseVector(n+1+i,k) - PhaseVector(n+i,k);
            end
            for i = 1:7
                m_later(i+5) = PhaseVector(n+i+1,k) - PhaseVector(n+i,k);
            end
            m = PhaseVector(n,k) - PhaseVector(n-1,k);
            mean_prev = abs ((m_prev))
            mean_later = abs (mean (m_later))
            if (m > 0 & mean_later > 0 & mean_prev > 0)
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