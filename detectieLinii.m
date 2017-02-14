function [ coloane, incadrareLinie ] = detectieLinii( imagineFiltrata )
    % FUNCTIE FINALIZATA
    % Trebuie verificata partea cu incadrareLinie, pare dubioasa acum
    % detectieLinii Foloseste o varianta simplificata a Hough pentru a detecta
    % care dintre coloane este o posibila linie.
    %   Detaliile despre implementare pot fi gasite in paper-ul 
    % Real time Detection of Lane Markers in Urban Streets, Mohamed Aly

    % Initializam parametrii
    numarLinii = 3; % Numarul de linii detectate
    limitaIncadrare = 2;
    filtruGaussian = [-1 1];
    
    sumaColoane = sum(imagineFiltrata,1);
    coloaneFiltrate = imfilter(sumaColoane, filtruGaussian);

    [~, locs] = findpeaks(coloaneFiltrate);
    [~, index] = sort(coloaneFiltrate(locs),'descend');
    
    coloane = locs(index(1:numarLinii));

    incadrareLinie = zeros(0,4);
    for idx = 1:size(coloane,2)
        if coloane(idx) > limitaIncadrare && coloane(idx) < size(imagineFiltrata,2) - limitaIncadrare
            incadrareLinie = [incadrareLinie; coloane(idx) - limitaIncadrare, coloane(idx) + limitaIncadrare];
        elseif coloana(idx) > limitaIncadrare
            incadrareLinie = [incadrareLinie; coloane(idx) - limitaIncadrare, size(imagineFiltrata,2)];
        elseif coloana(idx) < size(imagineFiltrata) - limitaIncadrare
            incadrareLinie = [incadrareLinie; 1, coloana(idx) + limitaIncadrare];
        else
            incadrareLinie = [incadrareLinie; 1, size(imagineFiltrata,2)];
        end
    end
end

