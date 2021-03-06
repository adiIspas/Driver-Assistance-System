function [ puncte, scor ] = RANSAC(imagineFiltrata, incadrare) % FUNCTIE FINALIZATA
% RANSAC O varianta adaptata a algoritmului RANSAC pentru detectarea punctelor de interes in imagine.
%  
%   imagineFiltrata = imaginea filtrata
%   incadrarea      = incadrarea pentru posibile linii
%
%   puncte          = puncte pentru spline
%   scor            = scor asociat punctelor de spline
    
    % Initializam parametrii
    numarIteratii = 30;
    dimensiuneInaltime = size(imagineFiltrata,1);
    puncteBuneFinale = zeros(0,4);
    scorBunFinal = zeros(0,1);
    puncteBune = [];
    for idy = 1:size(incadrare,1)
        scorBun = 0.1;
        for idx = 1:numarIteratii
            puncte = obtinePuncteRandom(incadrare(idy,:),dimensiuneInaltime);
            punctePotrivite = potrivestePuncte(puncte, size(imagineFiltrata));
            scor = determinaScor(punctePotrivite, imagineFiltrata);

            if scor > scorBun                
                scorBun = scor;
                puncteBune = punctePotrivite;
            end
        end

        puncteBuneFinale = [puncteBuneFinale; puncteBune];
        scorBunFinal = [scorBunFinal; scorBun];
    end

    puncte = puncteBuneFinale;
    scor = scorBunFinal;
end

