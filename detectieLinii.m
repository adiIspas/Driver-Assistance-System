function [ coloane, incadrareLinie ] = detectieLinii( imagineFiltrata ) % FUNCTIE FINALIZATA
    % detectieLinii Foloseste o varianta simplificata a Hough pentru a detecta care dintre coloane este o posibila linie.
    %   Detaliile despre implementare pot fi gasite in paper-ul 
    % Real time Detection of Lane Markers in Urban Streets, Mohamed Aly

    % Initializam parametrii
    numarLinii = 3; % Numarul de linii detectate
    limitaIncadrare = 2; % Dimensiune boundy-box
    limitaIncadrareLinie = 10; % Diferentia minima dintre oricare 2 coloane
    filtruGaussian = [-1 1];
    incadrareLinie = zeros(numarLinii,2);
    idxIncadrare = 1;
    
    sumaColoane = sum(imagineFiltrata,1);
    coloaneFiltrate = imfilter(sumaColoane, filtruGaussian);
    
    [~, locs] = findpeaks(coloaneFiltrate);
    [~, index] = sort(coloaneFiltrate(locs),'descend');
    
    coloaneTemporale = locs(index(1:end));
    coloane = obtineColoane(coloaneTemporale,limitaIncadrareLinie,numarLinii);
    for idx = 1:size(coloane,2)
        % Verificam daca adunam sau scadem limitaIncadrare ramanem in
        % imagine. In caz negativ adaptam la inceputul sau sfarsitul
        % imaginii.
        if coloane(idx) > limitaIncadrare && coloane(idx) < size(imagineFiltrata,2) - limitaIncadrare
            incadrareLinie(idxIncadrare,:) = [coloane(idx) - limitaIncadrare, coloane(idx) + limitaIncadrare];
            idxIncadrare = idxIncadrare + 1;
        elseif coloana(idx) > limitaIncadrare
            incadrareLinie(idxIncadrare,:) = [coloane(idx) - limitaIncadrare, size(imagineFiltrata,2)];
            idxIncadrare = idxIncadrare + 1;
        elseif coloana(idx) < size(imagineFiltrata) - limitaIncadrare
            incadrareLinie(idxIncadrare,:) = [1, coloana(idx) + limitaIncadrare];
            idxIncadrare = idxIncadrare + 1;
        else
            incadrareLinie(idxIncadrare,:) = [1, size(imagineFiltrata,2)];
            idxIncadrare = idxIncadrare + 1;
        end
    end
end

function coloane = obtineColoane(coloaneSortate, limitaIncadrareLinie, numarLinii)
    coloaneSelectate = zeros(0,1);
    
    coloaneSelectate = [coloaneSelectate, coloaneSortate(1)];
    for idx = 2:size(coloaneSortate,2)
        
        % Verificam daca oricare 2 coloane selectate se afla la o distanta
        % de cel putin numarLinii una de cealalta
        verifica = 1;
        for idy = 1:size(coloaneSelectate,2)
            if abs(coloaneSelectate(idy) - coloaneSortate(idx)) <= limitaIncadrareLinie
                verifica = 0;
            end
        end
        
        if verifica == 1
            coloaneSelectate = [coloaneSelectate, coloaneSortate(idx)];
        end
    end
    
    coloane = coloaneSelectate(1:numarLinii);
end