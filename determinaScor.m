function [ scor ] = determinaScor( punctePotrivite, imagineFiltrata )
    %determinaScor Determina scorul pentru punctele potrivite determinate

    % Initializam parametri
    P_01 = calculeazaDistanta(punctePotrivite(1,:),punctePotrivite(2,:));
    P_02 = calculeazaDistanta(punctePotrivite(1,:),punctePotrivite(3,:));
    P_12 = calculeazaDistanta(punctePotrivite(2,:),punctePotrivite(3,:));
    P_13 = calculeazaDistanta(punctePotrivite(2,:),punctePotrivite(4,:));
    P_23 = calculeazaDistanta(punctePotrivite(3,:),punctePotrivite(4,:));

    l = calculeazaDistanta(punctePotrivite(1,:),punctePotrivite(4,:));
    v = size(imagineFiltrata,1);

    k_1 = 1;
    k_2 = 1;

    temp_1 = cos((P_12^2 + P_01^2 - P_02^2)/(2*P_01*P_12));
    temp_2 = cos((P_23^2 + P_12^2 - P_13^2)/(2*P_12*P_23));

    theta_1 = 180 - acosd(temp_1);
    theta_2 = 180 - acosd(temp_2);

    theta = (cos(theta_1) + cos(theta_2))/2;
    theta_final = (theta - 1)/2;

    l_final = (l/v) - 1;
    
    s = calculeazaScorLinie(punctePotrivite,imagineFiltrata);
    scor = double(s) * (1 + k_1 * l_final + k_2 * theta_final);
end

function distanta = calculeazaDistanta(punct_1, punct_2)
    distanta = sqrt((punct_1(1) - punct_2(1))^2 + (punct_1(2) - punct_2(2))^2);
end

function scor = calculeazaScorLinie(puncte,imagineFiltrata)
    scor = 0;
    inaltime = size(imagineFiltrata,1);
    latime = size(imagineFiltrata,2);
    
    % Prima portiune
    step = round(abs(puncte(1,2) - puncte(2,2))/abs(puncte(1,1) - puncte(2,1)));
    idx = min(puncte(1,1),puncte(2,1)) - 1;
    if puncte(1,2) < inaltime - 1 && puncte(2,2) < inaltime - 1 ...
        && puncte(1,2) > 0 && puncte(2,2) > 0
    
        count = 0;
        for idy = min(puncte(1,2),puncte(2,2)):max(puncte(1,2),puncte(2,2))
            scor = scor + imagineFiltrata(ceil(idy),ceil(idx));
            count = count + 1;
            
            if count == step && idx + 1 <= latime
                idx = idx + 1;
                count = 0;
            end
        end
    else
        scor = realmin('double');
    end

    % A doua portiune
    step = round(abs(puncte(2,2) - puncte(3,2))/abs(puncte(2,1) - puncte(3,1)));
    idx = min(puncte(2,1),puncte(3,1)) - 1;
    if puncte(2,2) < inaltime - 1 && puncte(3,2) < inaltime - 1 ...
        && puncte(2,2) > 0 && puncte(3,2) > 0
    
        count = 0;
        for idy = min(puncte(2,2),puncte(3,2)):max(puncte(2,2),puncte(3,2))
            scor = scor + imagineFiltrata(ceil(idy),ceil(idx));
            count = count + 1;
            
            if count == step && idx + 1 <= latime
                idx = idx + 1;
                count = 0;
            end
        end
    else
        scor = realmin('double');
    end
    
    % A treia portiune
    step = round(abs(puncte(3,2) - puncte(4,2))/abs(puncte(3,1) - puncte(4,1)));
    idx = min(puncte(2,1),puncte(3,1)) - 1;
    if puncte(2,2) < inaltime - 1 && puncte(3,2) < inaltime - 1 ...
        && puncte(2,2) > 0 && puncte(3,2) > 0
    
        count = 0;
        for idy = min(puncte(2,2),puncte(3,2)):max(puncte(2,2),puncte(3,2))
            scor = scor + imagineFiltrata(ceil(idy),ceil(idx));
            count = count + 1;
            
            if count == step && idx + 1 <= latime
                idx = idx + 1;
                count = 0;
            end
        end
    else
        scor = realmin('double');
    end
end

