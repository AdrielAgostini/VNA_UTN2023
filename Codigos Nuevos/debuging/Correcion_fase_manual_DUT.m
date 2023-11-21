S(:,1) = mag2db(abs(S11_match));
S(:,2) = mag2db(abs(S11_open));
S(:,3) = mag2db(abs(S11_short));
S(:,4) = mag2db(abs(S22_match));
S(:,5) = mag2db(abs(S22_open));
S(:,6) = mag2db(abs(S22_short));
S(:,7) = mag2db(abs(S11_thru)); 
S(:,8) = mag2db(abs(S21_thru));
S(:,9) = mag2db(abs(S12_thru));
S(:,10) = mag2db(abs(S22_thru));
S_man(:,1) = angle(S11_match);
S_man(:,2) = angle(S11_open);
S_man(:,3) = angle(S11_short);
S_man(:,4) = angle(S22_match);
S_man(:,5) = angle(S22_open);
S_man(:,6) = angle(S22_short);
S_man(:,7) = angle(S11_thru); 
S_man(:,8) = angle(S21_thru);
S_man(:,9) = angle(S12_thru);
S_man(:,10) = angle(S22_thru);

S_man([48:50,69:78],1) = -1 * S_man([48:50,69:78],1);
S_man ([280:300],2) = -1* abs(S_man ([280:300],2));
%S3 no se toca
S_man ([12:17,35:40,57:61,95,110,132,152,168,188],4) = -1 * S_man ([12:17,35:40,57:61,95,110,132,152,168,188],4);
S_man ([8,26,44,60,77,95,113,147,165,182,199,217,235,267,285,17,34,51,70,87,104,121,139,156,173,191,209,225,243,261,279,295],5) = -1 * S_man([8,26,44,60,77,95,113,147,165,182,199,217,235,267,285,17,34,51,70,87,104,121,139,156,173,191,209,225,243,261,279,295],5);
S_man ([9,26,42,60,95,148 182 200 217 234 252 270 286 17 35 52 68 86 104 174 191 208 227 259 295 297 299  ],6) = -1 * S_man([9,26,42,60,95,148 182 200 217 234 252 270 286 17 35 52 68 86 104 174 191 208 227 259 295 297 299  ],6);
S_man ([1,7,12,29,26,34,35,40,49,50,55,82,87,98,112,118:123,130:135,144,150,158,165,172:178,186:190,198:203,214,230:234,244:247,279:283,293:295,297:299],7) = -1 * S_man([1,7,12,29,26,34,35,40,49,50,55,82,87,98,112,118:123,130:135,144,150,158,165,172:178,186:190,198:203,214,230:234,244:247,279:283,293:295,297:299],7) ;
S_man ([25,12,37,50,75,88 126 139 151 164 202 215 228 240 252 279 291 297 299],8) = -1 * S_man([25,12,37,50,75,88 126 139 151 164 202 215 228 240 252 279 291 297 299],8) ;
%S9 no se toca
S_man ([1 6 10 17 22 30 35 41 46 52 58 63 69 70 73 87 94 102 107 108 128 142 153 154 161 168 175 182 190 197 209 216 223 232 257 272 293:296 298 300],10) = -1 * S_man([1 6 10 17 22 30 35 41 46 52 58 63 69 70 73 87 94 102 107 108 128 142 153 154 161 168 175 182 190 197 209 216 223 232 257 272 293:296 298 300],10) ;
%%
names = ["S11 match", "S11 open","S11 short",...
    "S22 match", "S22 open","S22 short",...
    "S11 thru","S21 thru","S12 thru","S22 thru"];


for i = 1 : 10
    
    a=figure(i);
    plot(freqOSM,S(:,i),'-o','MarkerSize',3,'MarkerEdgeColor','red');
    grid on
    grid minor
    title(names(i));
    %saveas(a,strcat("plot",num2str(i),".pdf"));
    
end
for i = 1 : 10
    
    a=figure(i+10);
    plot(freqOSM,S_man(:,i),'-o','MarkerSize',3,'MarkerEdgeColor','red');
    grid on
    grid minor
    title(names(i));
    %saveas(a,strcat("plot",num2str(i+10),".pdf"));
    
end



%%
close all
anglemode = 2; %1 degree 2ran;
if (anglemode == 1)
S11_match = db2mag(S(:,1)) .* exp(1i * S_man(:,1) * pi/180);
S11_open = db2mag(S(:,2)) .* exp(1i * S_man(:,2) * pi/180);
S11_short = db2mag(S(:,3)) .* exp(1i * S_man(:,3) * pi/180);
S22_match = db2mag(S(:,4)) .* exp(1i * S_man(:,4) * pi/180);
S22_open = db2mag(S(:,5)) .* exp(1i * S_man(:,5) * pi/180);
S22_short = db2mag(S(:,6)) .* exp(1i * S_man(:,6) * pi/180);
S11_thru = db2mag(S(:,7)) .* exp(1i * S_man(:,7) * pi/180);
S21_thru = db2mag(S(:,8)) .* exp(1i * S_man(:,8) * pi/180);
S12_thru = db2mag(S(:,9)) .* exp(1i * S_man(:,9) * pi/180);
S22_thru = db2mag(S(:,10)) .* exp(1i * S_man(:,10) * pi/180);

else
S11_match = db2mag(S(:,1)) .* exp(1i * S_man(:,1));
S11_open = db2mag(S(:,2)) .* exp(1i * S_man(:,2));
S11_short = db2mag(S(:,3)) .* exp(1i * S_man(:,3) );
S22_match = db2mag(S(:,4)) .* exp(1i * S_man(:,4));
S22_open = db2mag(S(:,5)) .* exp(1i * S_man(:,5) );
S22_short = db2mag(S(:,6)) .* exp(1i * S_man(:,6) );
S11_thru = db2mag(S(:,7)) .* exp(1i * S_man(:,7) );
S21_thru = db2mag(S(:,8)) .* exp(1i * S_man(:,8) );
S12_thru = db2mag(S(:,9)) .* exp(1i * S_man(:,9) );
S22_thru = db2mag(S(:,10)) .* exp(1i * S_man(:,10));
end