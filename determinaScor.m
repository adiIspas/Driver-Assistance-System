function [ scor ] = determinaScor( punctePotrivite, imagineFiltrata ) % FUNCTIE FINALIZATA
    % determinaScor Determina scorul pentru punctele potrivite determinate.

    % Initializam parametri
    P_01 = calculeazaDistanta(punctePotrivite(1,:),punctePotrivite(2,:));
    P_02 = calculeazaDistanta(punctePotrivite(1,:),punctePotrivite(3,:));
    P_12 = calculeazaDistanta(punctePotrivite(2,:),punctePotrivite(3,:));
    P_13 = calculeazaDistanta(punctePotrivite(2,:),punctePotrivite(4,:));
    P_23 = calculeazaDistanta(punctePotrivite(3,:),punctePotrivite(4,:));
    
    l = calculeazaDistanta(punctePotrivite(1,:),punctePotrivite(4,:));
    v = size(imagineFiltrata,1);

    k_1 = 0.75;
    k_2 = 0.25;

    temp_1 = cos((P_12^2 + P_01^2 - P_02^2)/(2*P_01*P_12));
    temp_2 = cos((P_23^2 + P_12^2 - P_13^2)/(2*P_12*P_23));

    theta_1 = 180 - acosd(temp_1);
    theta_2 = 180 - acosd(temp_2);

    theta = (cos(theta_1) + cos(theta_2))/2;
    theta_final = (theta - 1)/2;

    l_final = (l/v) - 1;
    
    % Determinam suma pixelilor pe linia detectata
    s = calculeazaScorLinie(punctePotrivite,imagineFiltrata);
    
    % Determinam scorul pentru linia detectata
    scor = double(s) * (1 + k_1 * l_final + k_2 * theta_final);
end

function distanta = calculeazaDistanta(punct_1, punct_2)
    distanta = sqrt((punct_1(1) - punct_2(1))^2 + (punct_1(2) - punct_2(2))^2);
end

function scor = calculeazaScorLinie(puncte,imagineFiltrata)
    % Initializam variabile
    scor = 0;
    distantaPuncte = 30;
    inaltime = size(imagineFiltrata,1);
    latime = size(imagineFiltrata,2);

    dim_11 = size(puncte,1) * 2;
    dim_21 = size(puncte(puncte>0),1);
    dim_22 = size(puncte(puncte(:,1)<=latime),1) * 2;
    dim_23 = size(puncte(puncte(:,2)<=inaltime),1) * 2;
    
    verifica = verificaPuncte(puncte,distantaPuncte);
    % Eliminam punctele de control cu valori negative sau in afara imaginii
    if dim_11 ~= dim_21 || dim_11 ~= dim_22 || dim_11 ~= dim_23 || verifica ~= 1
        scor = realmin('double');
    else
        % Sortam punctele, parcurgere de sus in jos
        puncte = sortrows(puncte,1);

        % Valoare pixeli prima portiune (P1 - P2) 
        
        % Determinam step, cu cat ne deplasam la stanga sau la dreapta de
        % la P1 la P2
        step = round(abs(puncte(1,2) - puncte(2,2))/abs(puncte(1,1) - puncte(2,1)));
        
        % Stabilim cum se afla al doilea punct fata de primul (st sau dr)
        if puncte(1,1) < puncte(2,1)
            cumul = 1;
        else
            cumul = -1;
        end
        
        % Punctul de plecare pe directia X
        idx = puncte(1,1);
        count = 0;
        for idy = puncte(1,2):puncte(2,2)
            x = round(idx);
            y = round(idy);
            
            % Verificam incadrarea in imagine 
            if x > latime
                x = latime;
            elseif x < 1
                 x = 1;
            end
            
            if y > inaltime
                y = inaltime;
            elseif y < 1
                y = 1;
            end
            
            scor = scor + double(imagineFiltrata(y,x));
            count = count + 1;

            if count == step
                idx = idx + cumul;
                count = 0;
            end
        end


        % Valoare pixeli a doua portiune (P2 - P3) 
        
        % Determinam step, cu cat ne deplasam la stanga sau la dreapta de
        % la P1 la P2
        step = round(abs(puncte(2,2) - puncte(3,2))/abs(puncte(2,1) - puncte(3,1)));
        
        % Stabilim cum se afla al doilea punct fata de primul (st sau dr)
        if puncte(2,1) < puncte(3,1)
            cumul = 1;
        else
            cumul = -1;
        end
        
        % Punctul de plecare pe directia X
        idx = puncte(2,1);
        count = 0;
        for idy = puncte(2,2):puncte(3,2)
            x = round(idx);
            y = round(idy);
            
            % Verificam incadrarea in imagine 
            if x > latime
                x = latime;
            elseif x < 1
                 x = 1;
            end
            
            if y > inaltime
                y = inaltime;
            elseif y < 1
                y = 1;
            end
            
            scor = scor + double(imagineFiltrata(y,x));
            count = count + 1;

            if count == step
                idx = idx + cumul;
                count = 0;
            end
        end

        % Valoare pixeli a treia portiune (P3 - P4) 
        
        % Determinam step, cu cat ne deplasam la stanga sau la dreapta de
        % la P1 la P2
        step = round(abs(puncte(3,2) - puncte(4,2))/abs(puncte(3,1) - puncte(4,1)));
        
        % Stabilim cum se afla al doilea punct fata de primul (st sau dr)
        if puncte(3,1) < puncte(4,1)
            cumul = 1;
        else
            cumul = -1;
        end
        
        % Punctul de plecare pe directia X
        idx = puncte(3,1);
        count = 0;
        for idy = puncte(3,2):puncte(4,2)
            x = round(idx);
            y = round(idy);
            
            % Verificam incadrarea in imagine 
            if x > latime
                x = latime;
            elseif x < 1
                 x = 1;
            end
            
            if y > inaltime
                y = inaltime;
            elseif y < 1
                y = 1;
            end
            
            scor = scor + double(imagineFiltrata(y,x));
            count = count + 1;

            if count == step
                idx = idx + cumul;
                count = 0;
            end
        end
    end
end

function verifica = verificaPuncte(puncte, distantaPuncte)
    
    verifica = 1;
    for idx = 1:size(puncte,1)
        for idy = 1:size(puncte,1)
            if (abs(puncte(idx,2) - puncte(idy,2)) <= distantaPuncte) && (idx ~= idy)
                verifica = 0;
            end
        end
    end
end