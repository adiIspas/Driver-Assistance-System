function [ puncte, scor ] = RANSAC(imagineFiltrata, incadrare) % FUNCTIE FINALIZATA
    % RANSAC O varianta adaptata a algoritmului RANSAC pentru detectarea punctelor de interes in imagine.
    %   Detaliile despre implementare pot fi gasite in paper-ul 
    % Real time Detection of Lane Markers in Urban Streets, Mohamed Aly
    
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

