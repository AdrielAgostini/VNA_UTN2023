function [ S11_C, S12_C, S21_C, S22_C ] = gammaCorrect(S11_M, S12_M, S21_M, S22_M, gammaOpenP1, gammaShortP1, gammaMatchP1,gammaOpenP2, gammaShortP2,gammaMatchP2, gammaTP1, gammaTP2, forwardT, reverseT, frec,)
%GAMMACORRECT Aplica algoritmo de correccion al Gamma
%   
   % gamma  = zeros(length(gamma_M), 1);
  %  c = 3*10^8;
   % vf = 1;
   % v = c*vf;
    %lambda = (v./frec)';
    %gammaO = 1.*exp(-1i*(4.*pi.*offsetOpen./lambda));
    %gammaS = -1.*exp(-1i*(4.*pi.*offsetShort./lambda));
        
    
    e00 = gammaMatchP1; % directividad puerto 1
    e11 = (gammaOpenP1 + gammaShortP1 -2*e00)./(gammaOpenP1 - gammaShortP1); %Source match puerto 1
    e1001 = (-2*(gammaOpenP1 - e00).*(gammaShortP1 - e00))./(gammaOpenP1 - gammaShortP1); %reflexion tracking puerto 1
    deltae = e00.*e11 - e1001;
    e22 = (gammaTP1 - e00)./(gammaTP1.*e11 - deltae);% Load Mtach puerto 1
    e1032 = (forwardT).*(1-e11.*e22);% ojo es forwardT -e30 pero habria que calibrar crosstalk % Transmision tracking puerto 1
    e33 = gammaMatchP2;% Directividad Puerto 2
    e_22 = (gammaOpenP2 + gammaShortP2 -2*e33)./(gammaOpenP2 - gammaShortP2);% el guion bajo es el prima % Source Match puerto 2
    e2332 = (-2*(gammaOpenP2 - e33).*(gammaShortP2 - e33))./(gammaOpenP2 - gammaShortP2); %Reflexion Tracking puerto 2
    deltaeprima = e33.*e_22 - e2332;
    e_11 = (gammaTP2 - e33)./(gammaTP2.*e_22 - deltaeprima);% es por e22prima? Load Match puerto 2
    e2301 = (reverseT).*(1-e33.*e_11);% ojo es fordwardT - e03 pero habria que calibrar crosstalk %transmision tracking puerto 2
     
    N11 = (S11_M - e00)./e1001;
    N12 = (S12_M)./e2301; % es S12_M - e03 pero hay q calibrar crosstalk
    N21 = (S21_M)./e1032; % es S21_M - e30 pero hay q calibrar crosstalk
    N22 = (S22_M - e33)./e2332;
    
    D = (1+N11.*e11).*(1+N22.*e_22)-N21.*N12.*e22.*e_11;
    
    S11_C = ((N11.*(1+N22.*e_22))-e22.*N21.*N12)/D;
    S21_C = (N21.*(1+N22.*(e_22 - e22)))/D;
    S22_C = (N22.*(1+N11.*e11)-e_11.*N21.*N12)/D;
    S12_C = (N12.*(1+N11.*(e11 - e_11)))/D;
% Algoritmo de Correccion
%     e00    = gammaMatch;                        %Directivity
%     e11 = (gammaS.*(gammaOpen - gammaMatch)- gammaO.*(gammaShort - gammaMatch))./(gammaS.*gammaO.*(gammaOpen - gammaShort));
%     e10 = ((gammaO-gammaS).*(gammaOpen-gammaMatch).*(gammaShort-gammaMatch))./(gammaS.*gammaO.*(gammaOpen - gammaShort));
%     gamma = (gamma_M - e00)./(e10+e11.*(gamma_M - e00));  %Vector final corregido
%TODO Revisar:    
%Smooth parte real e imaginaria
%   gamma = smooth(real(gamma),'sgolay',3) + 1i*smooth(imag(gamma),'sgolay',3);         %Vector de la parte real

%Correccion valores nulos

%         for(n = 1:length(gamma))
%         if(isnan(gamma(n)))
%             gamma(n)=gamma(n-1);
%         end
%     end
%end


