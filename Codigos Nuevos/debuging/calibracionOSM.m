%--Calibracion Puerto 1--%
vectorfase (:,1) = match(:,2);
vectorfase (:,2) = open(:,2);
vectorfase (:,3) = short(:,2);
vectorfase_prima = correcion_fase(vectorfase);
vectorfase_prima(:,1) = vectorfase(:,1);

fasedut = zeros (300,4);
fasedut (:,1) = dut(:,2);
fasedut_prima = correcion_fase(fasedut);


S11_match = db2mag(match(:,1)) .* exp(1i * vectorfase_prima(:,1) * pi/180);
S11_open = db2mag(open(:,1)) .* exp(1i * vectorfase_prima(:,2) * pi/180);
S11_short = db2mag(short(:,1)) .* exp(1i * vectorfase_prima(:,3) * pi/180);
S11_M = db2mag(dut(:,1)) .* exp(1i * fasedut_prima(:,1) * pi/180);

    e00 = S11_match; % directividad puerto 1
    e11 = (S11_open + S11_short -2*e00)./(S11_open - S11_short); %Source match puerto 1
    e10e01 = (-2*(S11_open - e00).*(S11_short - e00))./(S11_open - S11_short); %reflexion tracking puerto 1
    deltae = e00.*e11 - e10e01;

    
 S11_c = (S11_M - e00) ./ (S11_M .* e11 - (e00.*e11 - e10e01))  ;

mag = mag2db(abs(S11_c));
pha = angle(S11_c) * 180 / pi;


for i = 1:3
    figure();
    plot(vectorfase_prima(:,i));
    figure();
    plot(vectorfase(:,i));
end
figure();
plot(fasedut(:,1));
figure();
plot(fasedut_prima(:,1));