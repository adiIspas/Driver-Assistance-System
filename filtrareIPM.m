function [ imagineFiltrata ] = filtrareIPM( imagineIPM )
    % FUNCTIE FINALIZATA
    % filtrareIPM Filtreaza imaginea IPM cu filtrul gaussian/sobel si aplica un prag
    %   Detaliile despre implementare pot fi gasite in paper-ul 
    % Real time Detection of Lane Markers in Urban Streets, Mohamed Aly

    % Initializam parametri
    imagineIPM = double(imagineIPM);
    q = 0.975;

    % Initializam filtrul
    filtruGaussianOrizontal = [0 0 0; % Directia X
                              0 1 -1;
                              0 0 0];

    % Aplicam filtrul
    imagineFiltrata = imfilter(imagineIPM, filtruGaussianOrizontal);
    prag = quantile(imagineFiltrata(:),q);
    
    % Setam un prag dupa care filtram continutul imaginii
    for idx = 1:size(imagineFiltrata,1)
        for idy = 1:size(imagineFiltrata,2)
            if imagineFiltrata(idx,idy) <= prag
                imagineFiltrata(idx,idy) = 0;
            end
        end
    end

    % Ultima linie a imaginii ramane mereu neschimbata.
    % O aducem la 0 deoarece genereaza detectie falsa.
    imagineFiltrata(:,end) = 0;

    % Convertim la uint8 imaginea
    imagineFiltrata = uint8(imagineFiltrata);
end

