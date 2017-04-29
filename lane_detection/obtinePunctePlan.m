function [ punctePlan ] = obtinePunctePlan( puncteIPM, matriceInversa )
%obtinePunctePlan Pentru un set de puncte obtinute in imaginea IPM returneaza punctele in planul imaginii originale
%   puncteIPM     = punctele din imaginea IPM
%   maticeInversa = matricea inversa transformarii in imaginea IPM
%   punctePlan    = punctele finale in planul imaginii originale

    punctePlan = zeros(size(puncteIPM));
    
    for idx = 1:size(puncteIPM,1)
        punctePlan(idx,:) = cv.perspectiveTransform(puncteIPM(idx,:),matriceInversa);
    end

end

