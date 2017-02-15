function [ puncte ] = obtinePuncteRandom(incadrare,dimensiuneInaltime) % FUNCTIE FINALIZATA
    % obtinePuncteRandom Genereaza puncte ce se incadreaza in jurul liniei detectate.
    
    % Initializam parametrii
    numarPuncte = 10;
    puncte = zeros(numarPuncte,2);
    idxPuncte = 1;
    
    % Limitele intre care se genereaza puncte
    ax = incadrare(1);
    bx = incadrare(2);
    ay = 1;
    by = dimensiuneInaltime;
    
    for idx = 1:numarPuncte
        rx = floor((bx-ax).*rand() + ax);
        ry = floor((by-ay).*rand() + ay);
        
        puncte(idxPuncte,:) = [rx, ry];
        idxPuncte = idxPuncte + 1;
    end
end

