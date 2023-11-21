function [gamma_refplane] = reference_plane (gamma_C,freqOSM,offset)

    names = ["S11", "S21","S12" "S22"];
    parameter = 1;
    C = 29.9792;

    aux_pha = (unwrap(angle (gamma_C))) * 180/pi;
    aux_mag = abs(gamma_C);

    pha_refplane = aux_pha - 2*offset*freqOSM*360/(C*1e9) ;

    pha_refplane = wrapTo180(pha_refplane);
    aux_pha = wrapTo180(aux_pha);

    figure
    title(names(parameter));
    plot(freqOSM,aux_pha(:,parameter),'-o','MarkerSize',3,'MarkerEdgeColor','red');
    hold
    grid on
    grid minor
    plot(freqOSM,pha_refplane(:,parameter),'-o','MarkerSize',3,'MarkerEdgeColor','blue');

    gamma_refplane = aux_mag .* exp(1i .* pha_refplane * pi/180);