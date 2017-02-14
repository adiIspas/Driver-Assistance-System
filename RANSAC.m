function [ puncte ] = RANSAC(imagineFiltrata, incadrare)
    % RANSAC O varianta adaptata a algoritmului RANSAC pentru detectarea
    % punctelor de interes in imagine
    %   Detaliile despre implementare pot fi gasite in paper-ul 
    % Real time Detection of Lane Markers in Urban Streets, Mohamed Aly
    
    % Initializam parametrii
    numarIteratii = 40;
    
    
    puncteBuneFinale = zeros(0,4);
    for idy = 1:size(incadrare,1)
        scorBun = realmin('double');
        for idx = 1:numarIteratii
            [puncte, ~] = obtinePuncteRandom(incadrare(idy,:), imagineFiltrata);
            punctePotrivite = potrivestePuncte(puncte);
            scor = determinaScor(punctePotrivite, imagineFiltrata);

            if scor < scorBun
                scorBun = scor;
                puncteBune = punctePotrivite;
            end
        end
        puncteBuneFinale = [puncteBuneFinale; puncteBune];
    end
    
    puncte = puncteBuneFinale;
end

