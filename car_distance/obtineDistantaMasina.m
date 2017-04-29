function [ puncteDetectieIPM ] = obtineDistantaMasina( puncteDetectie, matriceIPM )
%obtinePunctePlan Pentru un set de puncte obtinute in imaginea IPM returneaza punctele in planul imaginii originale
%   puncteIPM     = punctele din imaginea IPM
%   maticeInversa = matricea inversa transformarii in imaginea IPM
%   punctePlan    = punctele finale in planul imaginii originale

    puncteDetectieIPM = zeros(size(puncteDetectie));
    
    for idx = 1:size(puncteDetectie,1)
        puncteDetectieIPM(idx,:) = cv.perspectiveTransform(puncteDetectie(idx,:),matriceIPM);
    end

end

