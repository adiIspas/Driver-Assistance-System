function [ coloane, incadrareLinie ] = detectieLinii( imagineFiltrata ) % FUNCTIE FINALIZATA
    % detectieLinii Foloseste o varianta simplificata a Hough pentru a detecta care dintre coloane este o posibila linie.
    %   Detaliile despre implementare pot fi gasite in paper-ul 
    % Real time Detection of Lane Markers in Urban Streets, Mohamed Aly

    % Initializam parametrii
    limitaIncadrare = 2; % Dimensiune boundy-box
    limitaIncadrareLinie = 40; % Diferentia minima dintre oricare 2 coloane
    filtruGaussian = [-1 1];
    incadrareLinie = zeros(0,2);
    valoareMinimaColoana = 250; % Valoarea minima a unei coloane pentru a fi luata in calcul
    
    sumaColoane = sum(imagineFiltrata,1);
    coloaneFiltrate = imfilter(sumaColoane, filtruGaussian);
    
    [initialValues, locs] = findpeaks(coloaneFiltrate);
    [~, index] = sort(coloaneFiltrate(locs),'descend');
    
    coloaneTemporale = locs(index(1:end));
    valoriTemporale = initialValues(index(1:end));
    
    coloane = obtineColoane(coloaneTemporale,limitaIncadrareLinie);
    for idx = 1:size(coloane,2)
        % Verificam daca adunam sau scadem limitaIncadrare ramanem in
        % imagine. In caz negativ adaptam la inceputul sau sfarsitul
        % imaginii.
        if coloane(idx) > limitaIncadrare && coloane(idx) < size(imagineFiltrata,2) - limitaIncadrare ...
                && valoriTemporale(idx) >= valoareMinimaColoana
            incadrareLinie = [incadrareLinie; coloane(idx) - limitaIncadrare, coloane(idx) + limitaIncadrare];
        elseif coloane(idx) > limitaIncadrare && valoriTemporale(idx) >= valoareMinimaColoana
            incadrareLinie = [incadrareLinie; coloane(idx) - limitaIncadrare, size(imagineFiltrata,2)];
        elseif isequal(coloane(idx) < size(imagineFiltrata) - limitaIncadrare, valoriTemporale(idx) >= valoareMinimaColoana)
            incadrareLinie = [incadrareLinie; 1, coloane(idx) + limitaIncadrare];
        elseif valoriTemporale(idx) >= valoareMinimaColoana
            incadrareLinie = [incadrareLinie; 1, size(imagineFiltrata,2)];
        end
    end
end

function coloane = obtineColoane(coloaneSortate, limitaIncadrareLinie)
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
    
    coloane = coloaneSelectate(1:end);
end