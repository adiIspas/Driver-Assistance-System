function [ svms ] = antreneazaClasificatorMulticlasa()
%antreneazaClasificatorMulticlasa
    parametri.dimensiuneFereastra = 64;              
    parametri.dimensiuneCelulaHOG = 8;            
    parametri.dimensiuneDescriptorCelula = 31;
    parametri.extensie = 'png';
    
    dateAntrenarePozitive = zeros(1,0);
    dateAntrenareNegative = zeros(1,0);
    
    fisiereExemplePozitive = {
        'data/vehicles/Far'
        'data/vehicles/Left'
        'data/vehicles/MiddleClose'
        'data/vehicles/Right'
        };
    
    fisiereExempleNegative = {
        'data/non-vehicles/Far'
        'data/non-vehicles/Left'
        'data/non-vehicles/MiddleClose'
        'data/non-vehicles/Right'
        };
    
    try
        disp('Incarcam modelul de antrenare');
        load('data/salveazaFisiere/model_antrenare');
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
        save('data/salveazaFisiere/model_antrenare','svms');
    end 
end
