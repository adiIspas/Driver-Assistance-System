function [ coloane ] = detectieLinii( imagineFiltrata )
    %detectieLinii Foloseste o varianta simplificata a Hough pentru a detecta
    %care dintre coloane este o posibila linie.
    %   Detaliile despre implementare pot fi gasite in paper-ul 
    % Real time Detection of Lane Markers in Urban Streets, Mohamed Aly

    % Initializam parametrii
    numarColoane = 3; % Numarul de linii detectate
    pragApropiere = 20; % Numarul maxim de pixeli dintre doua linii
    numarMaximAlegeri = 15; % Numarul maxim de coloane luate in considerare

    [scor, index] = sort(sum(imagineFiltrata,1),'descend');

    scorColoana = zeros(0,1);
    indiceMediuColoana = zeros(0,1);

    indiceMediuColoana = [indiceMediuColoana, index(1)];
    scorColoana = [scorColoana, scor(1)];
    for idx = 2:numarMaximAlegeri
        valoareIndiceApropiat = abs(indiceMediuColoana - index(idx));
        [valoare, celMaiApropiatIndice] = min(valoareIndiceApropiat);

        if valoare >= pragApropiere
            indiceMediuColoana = [indiceMediuColoana, index(idx)];
            scorColoana = [scorColoana, scor(idx)];
        else
            indiceMediuColoana(celMaiApropiatIndice) = floor((indiceMediuColoana(celMaiApropiatIndice) + index(idx))/2);
            scorColoana(celMaiApropiatIndice) = scorColoana(celMaiApropiatIndice) + valoare;
        end
    end

    if size(indiceMediuColoana,2) >= numarColoane
        coloane = indiceMediuColoana(1:numarColoane);
    else
        coloane = indiceMediuColoana(1:end);
    end
end

