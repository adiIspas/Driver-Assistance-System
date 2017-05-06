function [ distanta ] = obtineDistantaMasina( puncteDetectie, matriceIPM, maxY, pixeliPerMetru )
%obtineDistantaMasina Determina distanta de la centrul detectiei masinii
%pana la baza imaginii
%   puncteDetectie = punctele ce definesc centru detectiei
%   matriceIPM     = matricea transformarii in imaginea IPM
%   maxY           = inaltimea imaginii
%
%   distanta       = distanta pana la masina in pixeli

    puncteDetectieIPM = zeros(size(puncteDetectie));
    
    for idx = 1:size(puncteDetectie,1)
        puncteDetectieIPM(idx,:) = cv.perspectiveTransform(puncteDetectie(idx,:),matriceIPM);
    end

    X = [puncteDetectieIPM(1,1), puncteDetectieIPM(1,2); ...
         puncteDetectieIPM(1,1), maxY];
     
    distantaPixeli = pdist(X,'euclidean');
    
    distanta = distantaPixeli/pixeliPerMetru;
end

