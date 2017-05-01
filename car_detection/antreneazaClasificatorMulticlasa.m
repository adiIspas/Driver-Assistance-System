function [ svms ] = antreneazaClasificatorMulticlasa(parametri)
% antreneazaClasificatorMulticlasa Antreneaza un clasificator pentru toate
% tipurile de clase date prin parametri
% 
%   parametri = parametri de rulare
%
%   svms      = clasificatori obtinuti pentru fiecare clasa

    dateAntrenarePozitive = zeros(1,0);
    dateAntrenareNegative = zeros(1,0);
    
    fisiereExemplePozitive = parametri.fisiereExemplePozitive;
    fisiereExempleNegative = parametri.fisiereExempleNegative;
    
    path = parametri.path;
    
    try
        disp('Incarcam modelul de antrenare');
        load([path '/model_antrenare' '_' num2str(parametri.dimensiuneCelulaHOG)]);
    catch
        % Procesam exemple
        for idx = 1:size(fisiereExempleNegative,1)

            % Exemple negative
            parametri.numeDirector = fisiereExempleNegative{idx};
            descriptori = obtineDescriptori(parametri);

            dateAntrenareNegative = [dateAntrenareNegative; descriptori];
        end
        eticheteNegative = -1*ones(size(dateAntrenareNegative,1),1);
        
        svms = zeros(1,0);
        for idx = 1:size(fisiereExemplePozitive,1)

            % Exemple pozitive
            parametri.numeDirector = fisiereExemplePozitive{idx};
            descriptori = obtineDescriptori(parametri);

            dateAntrenarePozitive = [dateAntrenarePozitive; descriptori];
            etichetePozitive = ones(size(dateAntrenarePozitive,1),1);
            
            svmCurent = antreneazaSVM([dateAntrenarePozitive; dateAntrenareNegative]',[etichetePozitive; eticheteNegative]);
            
            svms = [svms; svmCurent];
        end

        % Antrenam clasificatorul 
        disp('Salvam modelul de antrenare');
        
        % Salvam modelul de antrenare
        save([path '/model_antrenare' '_' num2str(parametri.dimensiuneCelulaHOG)],'svms');
    end 
end
