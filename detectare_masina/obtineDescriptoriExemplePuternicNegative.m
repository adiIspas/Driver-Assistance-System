function obtineDescriptoriExemplePuternicNegative = obtineDescriptoriExemplePuternicNegative(parametri)
    % DescriptoriExemplePozitive = matrice NxD, unde:
    %   N = numarul de exemple pozitive de antrenare (fete de oameni) 
    %   D = numarul de dimensiuni al descriptorului
    %   in mod implicit D = (parametri.dimensiuneFereastra/parametri.dimensiuneCelula)^2*parametri.dimensiuneDescriptorCelula

    imgFiles = dir( fullfile( parametri.numeDirectorExemplePuternicNegative, '*.jpg') ); %exemplele pozitive sunt stocate ca .jpg
    numarImagini = length(imgFiles);

    obtineDescriptoriExemplePuternicNegative = zeros(numarImagini,(parametri.dimensiuneFereastra/parametri.dimensiuneCelulaHOG)^2*parametri.dimensiuneDescriptorCelula);
    disp(['Exista un numar de exemple puternic negative = ' num2str(numarImagini)]);pause(2);
    
    for idx = 1:numarImagini
        disp(['Procesam exemplul puternic negativ numarul ' num2str(idx)]);
        img = imread([parametri.numeDirectorExemplePuternicNegative '/' imgFiles(idx).name]);
        if size(img,3) > 1
            img = rgb2gray(img);
        end   

        %completati codul functiei in continuare
        
        descriptorHOG = vl_hog(single(img),parametri.dimensiuneCelulaHOG);
        descriptorHOG = descriptorHOG(:)';
        obtineDescriptoriExemplePuternicNegative(idx,:) = descriptorHOG; 
    end
end