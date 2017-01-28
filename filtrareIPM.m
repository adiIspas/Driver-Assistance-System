function [ imagineFiltrata ] = filtrareIPM( imagineIPM )
%filtrareIPM Filtreaza imaginea IPM cu filtrul gaussian/sobel si aplica un prag
%   Detaliile despre implementare pot fi gasite in paper-ul 
% Real time Detection of Lane Markers in Urban Streets, Mohamed Aly

% Initializam parametri
imagineIPM = double(imagineIPM);

% Initializam filtrul
sobel_x = fspecial('sobel')';

% Aplicam filtrul
% zi = ndgauss([3 3],1*sqrt(2)*[1 1],'der',[0 1]);

gradient_x = imfilter(imagineIPM, sobel_x);
imagineFiltrata = uint8(gradient_x);

% Setam un prag dupa care filtram continutul imaginii
for idx = 1:size(imagineFiltrata,1)
    for idy = 1:size(imagineFiltrata,2)
        if imagineFiltrata(idx,idy) < 200
            imagineFiltrata(idx,idy) = 0;
        else
            imagineFiltrata(idx,idy) = 255;
        end
    end
end

end

