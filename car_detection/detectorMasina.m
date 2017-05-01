function [detectii, scoruriDetectii, imageIdx] = detectorMasina(parametri, frameCurent)
% detectorMasina Cauta posibile masini in imagine
% 
%   parametri       = parametri de rulare
%   frameCurent     = frame-ul curent din imagine
%
%   detectii        = detectiile gasite
%   scoruriDetectii = scorurile aferente detectiilor
%   imageIdx        = index-ul imaginii

    detectii = zeros(0,4);
    scoruriDetectii = zeros(0,1);
    imageIdx = cell(0,1);

    svms = parametri.svms;
    
    img = frameCurent;    
    if(size(img,3) > 1)
        img = rgb2gray(img);
    end

    imgOriginala = img;
    marimeInitiala = size(img);

    detectiiTemporareMarire = zeros(0,4);
    scoruriDetectiiTemporareMarire = zeros(0,1);

    img = imgOriginala;
    scale = 1.2;
    for pas = 1:3
        img = imresize(img,scale);
        descriptorHOGImagine = vl_hog(single(img),parametri.dimensiuneCelulaHOG);
        step = round(parametri.dimensiuneFereastra/parametri.dimensiuneCelulaHOG);
        dimCelula = parametri.dimensiuneCelulaHOG;
        detectiiCurente = zeros(0,4);
        scoruriDetectiiCurente = zeros(0,1);
        dim = parametri.dimensiuneFereastra;

        for j = 1:size(descriptorHOGImagine,1)-step
            for k = 1:size(descriptorHOGImagine,2)-step
                descriptorHOGCurent = descriptorHOGImagine(j:j-1+step,k:k-1+step,:);
                
                values = zeros(1,size(svms,1));
                for idx = 1:size(svms,1)
                    values(idx) = descriptorHOGCurent(:)'*svms(idx).w+svms(idx).b;
                end

                result = max(values);
                
                if result > parametri.threshold
                    rezultat_clasificare = result;
                    marimeActuala = size(img);
                    raport_x = (marimeInitiala(2)/marimeActuala(2));
                    raport_y = (marimeInitiala(1)/marimeActuala(1));

                    detectiiCurente = [detectiiCurente; ceil(((k-1)*dimCelula+1)*raport_x) ceil(((j-1)*dimCelula+1)*raport_y) ceil(((k-1)*dimCelula+dim)*raport_x) ceil(((j-1)*dimCelula+dim)*raport_y)];
                    scoruriDetectiiCurente = [scoruriDetectiiCurente rezultat_clasificare];
                end
            end
        end

        rezultate = [];
        if(size(detectiiCurente,1) > 0)
            rezultate = eliminaNonMaximele(detectiiCurente,scoruriDetectiiCurente,size(imgOriginala));
        end

        detectiiTemporareMarire = [detectiiTemporareMarire; detectiiCurente(rezultate,:)];
        scoruriDetectiiTemporareMarire = [scoruriDetectiiTemporareMarire scoruriDetectiiCurente(rezultate)];
    end

    detectiiTemporareMicsorare = zeros(0,4);
    scoruriDetectiiTemporareMicsorare = zeros(0,1);

        img = imgOriginala;
        scale = 0.9;
        while size(img,1) >= 31 && size(img,2) >= 31
            img = imresize(img,scale);
            descriptorHOGImagine = vl_hog(single(img),parametri.dimensiuneCelulaHOG);
            step = round(parametri.dimensiuneFereastra/parametri.dimensiuneCelulaHOG);
            dimCelula = parametri.dimensiuneCelulaHOG;
            detectiiCurente = zeros(0,4);
            scoruriDetectiiCurente = zeros(0,1);
            imageIdxCurente = cell(0,1);
            dim = parametri.dimensiuneFereastra;

            for j = 1:size(descriptorHOGImagine,1)-step
                for k = 1:size(descriptorHOGImagine,2)-step
                    descriptorHOGCurent = descriptorHOGImagine(j:j-1+step,k:k-1+step,:);
                    
                    values = zeros(1,size(svms,1));
                    for idx = 1:size(svms,1)
                        values(idx) = descriptorHOGCurent(:)'*svms(idx).w+svms(idx).b;
                    end

                    result = max(values);
                
                    
                    if result > parametri.threshold
                        rezultat_clasificare = result;
                        marimeActuala = size(img);
                        raport_x = (marimeInitiala(2)/marimeActuala(2));
                        raport_y = (marimeInitiala(1)/marimeActuala(1));

                        detectiiCurente = [detectiiCurente; ceil(((k-1)*dimCelula+1)*raport_x) ceil(((j-1)*dimCelula+1)*raport_y) ceil(((k-1)*dimCelula+dim)*raport_x) ceil(((j-1)*dimCelula+dim)*raport_y)];
                        scoruriDetectiiCurente = [scoruriDetectiiCurente rezultat_clasificare];
                    end
                end
            end

            rezultate = [];
            if(size(detectiiCurente,1) > 0)
                rezultate = eliminaNonMaximele(detectiiCurente,scoruriDetectiiCurente,size(imgOriginala));
            end

            detectiiTemporareMicsorare = [detectiiTemporareMicsorare; detectiiCurente(rezultate,:)];
            scoruriDetectiiTemporareMicsorare = [scoruriDetectiiTemporareMicsorare scoruriDetectiiCurente(rezultate)];
            
            img = imresize(img,scale);
        end

    detectiiTemporare = zeros(0,4);
    scoruriDetectiiTemporare = zeros(0,1);

    detectiiTemporare = [detectiiTemporare; detectiiTemporareMicsorare; detectiiTemporareMarire];
    scoruriDetectiiTemporare = [scoruriDetectiiTemporare scoruriDetectiiTemporareMicsorare scoruriDetectiiTemporareMarire];

    rezultate = [];
    if(size(detectiiTemporare,1) > 0)
        rezultate = eliminaNonMaximele(detectiiTemporare,scoruriDetectiiTemporare,size(imgOriginala));
    end

    detectii = [detectii; detectiiTemporare(rezultate,:)];
    scoruriDetectii = [scoruriDetectii scoruriDetectiiTemporare(rezultate)];
end