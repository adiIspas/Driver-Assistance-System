load 'banda.mat';

configuratie_detectie_masina;

imagineBanda1 = imagineBanda(1:240,:);
ipm = obtineIPM(imagineBanda1,configuratie);

imshow(ipm)