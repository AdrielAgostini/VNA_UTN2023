%{
    S11 = 1
    S21 = 2
    S12 = 3
    S22 = 4
%}

p_origen = 4
p_destino = 1

mag_aux = M_sC;
pha_aux = F_sC;


M_sC (:,p_destino) = mag_aux (:,p_origen);
F_sC (:,p_destino) = pha_aux (:,p_origen);

M_sC (:,p_origen) = mag_aux (:,p_destino);
F_sC (:,p_origen) = pha_aux (:,p_destino);