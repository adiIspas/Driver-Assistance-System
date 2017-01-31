function [ puncte, scor ] = obtinePuncteRandom( incadrare, imagineFiltrata )
    %obtinePuncteRandom Genereaza puncte ce se incadreaza in jurul liniei detectate
    % !!! Trebuie sa generez puncte random din bounding box
    % Initializam parametrii
    numarPuncte = 10;
    puncte = zeros(0,2);
    scor = zeros(0,1);
    dimensiuneLatime = size(imagineFiltrata,1);

    for idx = incadrare(1):incadrare(2)
        for idy = 1:dimensiuneLatime
            puncte = [puncte; idx, idy];
            scor = [scor; imagineFiltrata(idx,idy)];
        end
    end
    
    [scor, index] = sort(scor, 'descend');
    scor = scor(1:numarPuncte);
    
    puncteFinale = zeros(numarPuncte,2);
    for idx = 1:numarPuncte
       puncteFinale(idx,1) = puncte(index(idx),1);
       puncteFinale(idx,2) = puncte(index(idx),2);
    end
    
    puncte = puncteFinale;
end

