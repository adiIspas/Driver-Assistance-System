function [ zonaInteresImagine, deplasareY, deplasareX ] = obtinePozitieAproximativaMasina( zonaInteresImagineInitiala )
% obtinePozitieAproximativaMasina Obtina zona cu cel mai mare potential de
% a contine masina
%
%   zonaInteresImagineInitiala = zona pe care se face verificarea
%
%   zonaInteresImagine         = zona rezultata cu potential de a contine masina
%   deplasareY                 = deplasarea pe axa OY
%   deplasareX                 = deplasarea pe axa OX
    
    tempImage = rgb2gray(zonaInteresImagineInitiala);
    BW1 = edge(tempImage,'sobel','vertical',0.1);
    BW2 = edge(tempImage,'sobel','horizontal',0.1);

    result = BW1 + BW2;

    value1 = sum(result,1);
    value2 = sum(result,2);

    [~, col] = find(value1);
    [row, ~] = find(value2);
    
    if isempty(col) == 0 && isempty(row) == 0
        zonaInteresImagine = zonaInteresImagineInitiala(row(1):row(end),col(1):col(end),:);
        deplasareY = row(1);
        deplasareX = col(1);
    else
        zonaInteresImagine = 0;
        deplasareY = 0;
        deplasareX = 0;
    end
end

