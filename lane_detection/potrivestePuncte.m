function [ punctePotrivite ] = potrivestePuncte(puncte, dimensiune)
% potrivestePuncte Pentru un set de puncte dat incearca sa determine cele mai bune puncte.
%
%   puncte          = set de puncte pentru spline
%   dimensiune      = dimensiunea
%
%   punctePotrivite = cel mai bune puncte plecat de la cele date

    % Initializam parametrii
    numarPuncte = size(puncte,1);
    t = zeros(1,size(puncte,1));
    T = zeros(0,4);
    M = [-1  3 -3  1;
          3 -6  3  0;
         -3  3  0  0;
          1  0  0  0]; 
    sizeY = dimensiune(1,1);
    sizeX = dimensiune(1,2);
      
    for idx = 1:numarPuncte
        t_1 = 0;
        t_2 = 0;
        
        for idy = 2:idx
            t_1 = t_1 + calculeazaDistanta(puncte(idy,:),puncte(idy-1,:)); 
        end
        
        for idy = 2:numarPuncte
            t_2 = t_2 + calculeazaDistanta(puncte(idy,:),puncte(idy-1,:)); 
        end
        
        t(idx) = t_1/t_2;
    end
    
    for idx = 1:numarPuncte
        T = [T; t(idx)^3, t(idx)^2, t(idx), 1];
    end
    
    p_invers = pinv(T*M);
    punctePotrivite = p_invers*puncte;
    
    for i = 1:size(punctePotrivite,1)
        % Valori negative
        if punctePotrivite(i,1) < 0
            punctePotrivite(i,1) = -1 * punctePotrivite(i,1);
        end
        
        if punctePotrivite(i,2) < 0
            punctePotrivite(i,2) = -1 * punctePotrivite(i,2);
        end
        
        % In afara imaginii
        if punctePotrivite(i,2) > sizeY
            punctePotrivite(i,2) = sizeY;
        end
        
        if punctePotrivite(i,1) > sizeX
            punctePotrivite(i,1) = sizeX;
        end
    end
end

function distanta = calculeazaDistanta(punct_1, punct_2)
    distanta = sqrt((punct_1(1) - punct_2(1))^2 + (punct_1(2) - punct_2(2))^2);
end
