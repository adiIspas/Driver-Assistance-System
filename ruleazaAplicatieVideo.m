clear, clc, close all;

numeFolderVideo = 'videos';
numeVideo = 'traffic_video_2.mp4';

configuratie_video_2;
configuratie_decupaj_asfalt_video_2;
configuratie_detector_masina;
configuratie_detectie_masina;

yInceputDecupare = configuratie.yInceputDecupare;
xInceputDecupare = configuratie.xInceputDecupare;
yLungimeDecupare = configuratie.yLungimeDecupare;
xLungimeDecupare = configuratie.xLungimeDecupare;

start_x = pozitie_start_x;
end_x = pozitie_sfarsit_x;
start_y = pozitie_start_y;
end_y = pozitie_sfarsit_y;

mod2Benzi = 1;

video = VideoReader([numeFolderVideo '/' numeVideo]);
while hasFrame(video)
    clc
    tic
    img = readFrame(video);

    imagineCurenta = img(yInceputDecupare:yInceputDecupare+yLungimeDecupare,...
        xInceputDecupare:xInceputDecupare+xLungimeDecupare,:);
    [imagineIPM, matriceInversa] = obtineIPM(rgb2gray(imagineCurenta), configuratie);
    
    imagineFiltrata = filtrareIPM(imagineIPM);
    [liniiImagine, incadrare] = detectieLinii(imagineFiltrata, mod2Benzi);

    x_s = min(liniiImagine);
    x_e = max(liniiImagine);
    zonaInteresImagine = imagineCurenta(y_zona_interes:end,x_s:x_e,:);
    [zonaInteresImagine, deplasareY, deplasareX] = obtinePozitieAproximativaMasina(zonaInteresImagine);
    
%     imshow(zonaInteresImagine)
    
    [puncteInteres, scorLinie] = RANSAC(imagineFiltrata, incadrare);
    punctePlan = obtinePunctePlan(puncteInteres,matriceInversa);

    imagineTrasata = img;
    
    puncteFinale = [];
    puncteInceput = [];
    for u = 1:size(punctePlan,1)/4
        puncte = sortrows(punctePlan(u*4-4+1:u*4,:),2);
        
        puncteTemporareInceput = [];
        for idx = 2:size(puncte,1)
            i = round(puncte(idx-1,1));
            j = round(puncte(idx-1,2));
            
            if isempty(puncteTemporareInceput)
                puncteTemporareInceput = [puncteTemporareInceput; i j];
            end
            
            ii = round(puncte(idx,1));
            jj = round(puncte(idx,2));
            
            imagineTrasata = cv.line(imagineTrasata, ...
                [i+xInceputDecupare j+yInceputDecupare],[ii+xInceputDecupare jj+yInceputDecupare], ...
                'Thickness',1,'Color',[0 255 0]);
        end
        puncteFinale = [puncteFinale; ii jj];
        puncteInceput = [puncteInceput; puncteTemporareInceput];
    end
%     toc
    
%     tic
    if length(zonaInteresImagine) >= 45
        [detectii, scoruriDetectii, imageIdx] = detectorMasina(parametri, zonaInteresImagine);
    end
%     toc
    
    yMax = 0;
    if isempty(detectii) == 0
        yMax = detectii(1,end) + y_zona_interes + deplasareY;
    end
    
    p = punctePlan;
    if size(puncteFinale,1) == 2
        puncteFinale = sortrows(puncteFinale,1);
        
        for idx = 1:size(puncteFinale,1)
            i = puncteFinale(idx,1);
            j = puncteFinale(idx,2);
            
            if mod(idx,2) == 1
                ii = i - 70;
            else
                ii = i + 20;
            end
            jj = j + 30;
            p = [p; ii jj];
            imagineTrasata = cv.line(imagineTrasata, ...
                    [i+xInceputDecupare j+yInceputDecupare],[ii+xInceputDecupare jj+yInceputDecupare], ...
                    'Thickness',1,'Color',[0 255 0]);
        end
    end
    
    if size(puncteInceput,1) == 2 && yMax ~= 0
        puncteInceput = sortrows(puncteInceput,1);
        
        for idx = 1:size(puncteInceput,1)
            i = puncteInceput(idx,1);
            j = puncteInceput(idx,2);
            
            if mod(idx,2) == 1
                ii = i + 30;
            else
                ii = i - 20;
            end
            jj = yMax;
            p = [p; ii jj];
            imagineTrasata = cv.line(imagineTrasata, ...
                    [i+xInceputDecupare j+yInceputDecupare],[ii+xInceputDecupare jj+yInceputDecupare], ...
                    'Thickness',1,'Color',[0 255 0]);
        end
    end
    
    x = xInceputDecupare;
    y = yInceputDecupare;
    p(:,1) = p(:,1) + x;
    p(:,2) = p(:,2) + y;
    
    p = sortrows(p,1);
    if size(p,1) >= 12
        shape = [p(1,1) p(1,2) p(2,1) p(2,2) p(3,1) p(3,2) p(4,1) p(4,2) ...
             p(5,1) p(5,2) p(6,1) p(6,2) p(7,1) p(7,2) p(8,1) p(8,2) ...
             p(9,1) p(9,2) p(10,1) p(10,2) p(11,1) p(11,2) p(12,1) p(12,2)...
             p(1,1) p(1,2)];
    elseif size(p,1) >= 10
        shape = [p(1,1) p(1,2) p(2,1) p(2,2) p(3,1) p(3,2) p(4,1) p(4,2) ...
             p(5,1) p(5,2) p(6,1) p(6,2) p(7,1) p(7,2) p(8,1) p(8,2) ...
             p(9,1) p(9,2) p(10,1) p(10,2) ...
             p(1,1) p(1,2)];
    end
  
    if size(p,1) >= 8
        imagineTrasata = insertShape(imagineTrasata,'FilledPolygon',{shape},'Color', {'green'},'Opacity',0.5);
    end
    
    if size(detectii) > 0
    imagineTrasata = cv.rectangle(imagineTrasata,[detectii(1)+x_s+xInceputDecupare+deplasareX detectii(2)+y_zona_interes+yInceputDecupare+deplasareY],...
            [detectii(3)+x_s+xInceputDecupare+deplasareX detectii(4)+y_zona_interes+yInceputDecupare+deplasareY],'Thickness',2,'Color',[0 255 0]);
    end

    [imagineIPM, matriceInversa] = obtineIPM(imagineTrasata,configuratie_detectie);
%     imshow(imagineTrasata),impixelinfo;
%     imshow(imagineIPM),impixelinfo;

    if isempty(detectii) == 0
        d1 = (detectii(1)+x_s+xInceputDecupare+detectii(3)+x_s+xInceputDecupare)/2;
        d2 = detectii(4)+y_zona_interes+yInceputDecupare;
        obtineDistantaMasina([d1 d2],inv(matriceInversa));
    end
    
    toc
    
    image(imagineTrasata);
    pause(0.00001);
end