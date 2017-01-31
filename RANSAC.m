function [ puncte ] = RANSAC(imagineFiltrata, liniiImagine, incadrare )
    %RANSAC O varianta adaptata a algoritmului RANSAC pentru detectarea
    %punctelor de interes in imagine
    %   Detaliile despre implementare pot fi gasite in paper-ul 
    % Real time Detection of Lane Markers in Urban Streets, Mohamed Aly
    
    % Initializam parametrii
    numarIteratii = 1;
    numarPuncteFinale = 4;
    
    scorBun = -999;
    for idx = 1:numarIteratii
        [puncte, scor] = obtinePuncteRandom(incadrare(1,:), imagineFiltrata);
        punctePotrivite = potrivestePuncte(puncte);
        scor = determinaScor(punctePotrivite, imagineFiltrata);
    end

end

