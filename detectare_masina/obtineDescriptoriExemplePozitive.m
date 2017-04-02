function descriptoriExemplePozitive = obtineDescriptoriExemplePozitive(parametri)
    % DescriptoriExemplePozitive = matrice NxD, unde:
    %   N = numarul de exemple pozitive de antrenare (fete de oameni) 
    %   D = numarul de dimensiuni al descriptorului
    %   in mod implicit D = (parametri.dimensiuneFereastra/parametri.dimensiuneCelula)^2*parametri.dimensiuneDescriptorCelula

    imgFiles = dir( fullfile( parametri.numeDirectorExemplePozitive, '*.png') ); %exemplele pozitive sunt stocate ca .jpg
    multiplicare = 2;
    numarImagini = length(imgFiles);

    descriptoriExemplePozitive = zeros(numarImagini * multiplicare,(parametri.dimensiuneFereastra/parametri.dimensiuneCelulaHOG)^2*parametri.dimensiuneDescriptorCelula);
    disp(['Exista un numar de exemple pozitive = ' num2str(numarImagini * multiplicare)]);pause(2);
    
    idx2 = numarImagini+1;
    for idx = 1:numarImagini
        disp(['Procesam exemplul pozitiv numarul ' num2str(idx) ' si numarul ' num2str(idx2)]);
        img = imread([parametri.numeDirectorExemplePozitive '/' imgFiles(idx).name]);
        if size(img,3) > 1
            img = rgb2gray(img);
        end   

        %completati codul functiei in continuare
        
        descriptorHOG = vl_hog(single(img),parametri.dimensiuneCelulaHOG);
        descriptorHOG = descriptorHOG(:)';
        descriptoriExemplePozitive(idx,:) = descriptorHOG; 
        
        imgFlip = flip(img,180);
        descriptorHOG = vl_hog(single(imgFlip),parametri.dimensiuneCelulaHOG);
        descriptorHOG = descriptorHOG(:)';
        descriptoriExemplePozitive(idx2,:) = descriptorHOG; 
        idx2 = idx2 + 1;
    end
end