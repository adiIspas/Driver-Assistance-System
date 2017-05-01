function [ puncte ] = obtinePuncteRandom(incadrare,dimensiuneInaltime)
% obtinePuncteRandom Genereaza puncte ce se incadreaza in jurul liniei detectate.
%
%   incadrare          = incadrarea asociata coloanei cu potential de linie
%   dimensiuneInaltime = inaltimeaImaginii
%
%   puncte             = punctele generate in limita incadrarii
    
    % Initializam parametrii
    numarPuncte = 10;
    puncte = zeros(numarPuncte,2);
    idxPuncte = 1;
    distantaPuncte = 5;
    
    % Limitele intre care se genereaza puncte
    ax = incadrare(1);
    bx = incadrare(2);
    ay = 1;
    by = dimensiuneInaltime;
    
    for idx = 1:numarPuncte

        verifica = 0;
        rx = floor((bx-ax).*rand() + ax);
        while verifica == 0
            ry = floor((by-ay).*rand() + ay);
            verifica = verificaPuncte(puncte,idxPuncte,ry,distantaPuncte);
        end
        puncte(idxPuncte,:) = [rx, ry];
        idxPuncte = idxPuncte + 1;
    end
end

function verifica = verificaPuncte(puncte, idxPuncte, ry, distantaPuncte)
    
    verifica = 1;
    for idx = 1:idxPuncte
        if abs(puncte(idx,2) - ry) <= distantaPuncte
            verifica = 0;
        end
    end
end

