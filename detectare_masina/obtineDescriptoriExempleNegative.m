function descriptoriExempleNegative = obtineDescriptoriExempleNegative(parametri)
    % DescriptoriExempleNegative = matrice MxD, unde:
    %   M = numarul de exemple negative de antrenare (NU sunt fete de oameni),
    %   M = parametri.numarExempleNegative
    %   D = numarul de dimensiuni al descriptorului
    %   in mod implicit D = (parametri.dimensiuneFereastra/parametri.dimensiuneCelula)^2*parametri.dimensiuneDescriptorCelula

    imgFiles = dir( fullfile( parametri.numeDirectorExempleNegative , '*.jpg' ));
    
    puternicNegative = parametri.antrenareCuExemplePuternicNegative;
    imgFilesPuternicNegative = [];
    if puternicNegative == 1
        imgFilesPuternicNegative = dir(fullfile(parametri.numeDirectorExemplePuternicNegative , '*.jpg' ));
    end
    
    numarImagini = length(imgFiles);
    numarImaginiPuternicNegative = length(imgFilesPuternicNegative);

    numarExempleNegative_pe_imagine = round(parametri.numarExempleNegative/numarImagini);
    descriptoriExempleNegative = zeros(parametri.numarExempleNegative+numarImaginiPuternicNegative,(parametri.dimensiuneFereastra/parametri.dimensiuneCelulaHOG)^2*parametri.dimensiuneDescriptorCelula);
    disp(['Exista un numar de imagini = ' num2str(numarImagini+numarImaginiPuternicNegative) ' ce contine numai exemple negative']);
    
    nrDescriptori = 1;
    for idx = 1:numarImagini
        disp(['Procesam imaginea numarul ' num2str(idx)]);
        img = imread([parametri.numeDirectorExempleNegative '/' imgFiles(idx).name]);
        if size(img,3) == 3
            img = rgb2gray(img);
        end 
        
        %completati codul functiei in continuare

        H = size(img,1);
        W = size(img,2);
        dimBloc = 64;
        
        y = randi(H-dimBloc+1,numarExempleNegative_pe_imagine,1);
        x = randi(W-dimBloc+1,numarExempleNegative_pe_imagine,1);

        for i = 1:numarExempleNegative_pe_imagine  
            imagineCurenta = img(y(i):y(i)+dimBloc-1,x(i):x(i)+dimBloc-1,:);
            descriptorHOG = vl_hog(single(imagineCurenta),parametri.dimensiuneCelulaHOG);
            descriptorHOG = descriptorHOG(:)';
            descriptoriExempleNegative(nrDescriptori,:) = descriptorHOG; 
            nrDescriptori = nrDescriptori + 1;
        end
    end
    
    if puternicNegative == 1
        descriptoriExemplePuternicNegative = obtineDescriptoriExemplePuternicNegative(parametri);
        descriptoriExempleNegative = [descriptoriExempleNegative; descriptoriExemplePuternicNegative];
    end
end