function [ puncte, scor ] = obtinePuncteRandom( incadrare, imagineFiltrata )
    % FUNCTIE FINALIZATA
    % obtinePuncteRandom Genereaza puncte ce se incadreaza in jurul liniei detectate
    
    % Initializam parametrii
    numarPuncte = 15;
    puncte = zeros(0,2);
    scor = zeros(0,1);
    dimensiuneInaltime = size(imagineFiltrata,1);
    
    ax = incadrare(1);
    bx = incadrare(2);
    
    ay = 1;
    by = dimensiuneInaltime;

    for idx = 1:numarPuncte
        rx = floor((bx-ax).*rand() + ax);
        ry = floor((by-ay).*rand() + ay);
        puncte = [puncte; rx, ry];
        scor = [scor; imagineFiltrata(rx,ry)];
    end
end

