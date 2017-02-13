function [ punctePotrivite ] = potrivestePuncte( puncte )
    % FUNCTIE FINALIZATA
    % potrivestePuncte Pentru un set de puncte dat incearca sa determine cele mai bune puncte.

    % Initializam parametrii
    numarPuncte = size(puncte,1);
    t = zeros(1,size(puncte,1));
    T = zeros(0,4);
    M = [-1  3 -3  1;
          3 -6  3  0;
         -3  3  0  0;
          1  0  0  0];
    
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
end

function distanta = calculeazaDistanta(punct_1, punct_2)
    distanta = sqrt((punct_1(1) - punct_2(1))^2 + (punct_1(2) - punct_2(2))^2);
end
