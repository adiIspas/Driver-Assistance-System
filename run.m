%% Adrian ISPAS, Facultate de Matematicã si Informaticã, UNIBUC
clear, clc, close all;

%% Initializam parametrii de lucru
numeFolderVideo = 'videos';
numarVideo = 6;
numeVideo = ['traffic_video_' num2str(numarVideo) '.mp4'];

eval(['configuratie_video_' num2str(numarVideo)]);
eval(['configuratie_decupaj_asfalt_video_' num2str(numarVideo)]);
eval(['configuratie_banda_video_' num2str(numarVideo)]);
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

puncteTrasareTemporare = [];
trasareTemporara = numarTrasariTemporare;
mod2Benzi = 1;

%% Rulam aplicatia
video = VideoReader([numeFolderVideo '/' numeVideo]);
while hasFrame(video)
    clc    
    tic %% Inceput rulare
    img = readFrame(video);
    
    detectii = [];
    imagineCurenta = img(yInceputDecupare:yInceputDecupare+yLungimeDecupare,...
        xInceputDecupare:xInceputDecupare+xLungimeDecupare,:);
    [imagineIPM, matriceInversa] = obtineIPM(rgb2gray(imagineCurenta), configuratie);

    imagineFiltrata = filtrareIPM(imagineIPM);
    [liniiImagine, incadrare] = detectieLinii(imagineFiltrata, mod2Benzi);

    x_s = min(liniiImagine);
    x_e = max(liniiImagine);
    
    zonaInteresImagine = imagineCurenta(y_zona_interes:end,x_s:x_e,:);
    [zonaInteresImagine, deplasareY, deplasareX] = obtinePozitieAproximativaMasina(zonaInteresImagine);
    
    
    [puncteInteres, scorLinie] = RANSAC(imagineFiltrata, incadrare);
    punctePlan = obtinePunctePlan(puncteInteres,matriceInversa);
    
    imagineTrasata = img;
    puncteTrasare = [];
    for u = 1:size(punctePlan,1)/4
        puncte = sortrows(punctePlan(u*4-4+1:u*4,:),2);
        puncteTrasare = [puncteTrasare; puncte(1,:); puncte(end,:)];
    end

    if length(puncteTrasare) == 4
        distantaBenzi = ...
        DistBetween2Segment([puncteTrasare(1,1) puncteTrasare(1,2) 0], ...
                            [puncteTrasare(2,1) puncteTrasare(2,2) 0], ...
                            [puncteTrasare(3,1) puncteTrasare(3,2) 0], ...
                            [puncteTrasare(4,1) puncteTrasare(4,2) 0]);
    else
        distantaBenzi = 0;
    end

    if distantaBenzi < minDistance || distantaBenzi > maxDistance
        if trasareTemporara > 0
            puncteTrasare = puncteTrasareTemporare;
            trasareTemporara = trasareTemporara - 1;
        else
            puncteTrasare = [];
        end
    else
        trasareTemporara = numarTrasariTemporare;
        puncteTrasareTemporare = puncteTrasare;
    end

    if size(zonaInteresImagine,1) >= parametri.dimensiuneCelulaHOG && ...
            size(zonaInteresImagine,2) >= parametri.dimensiuneCelulaHOG
        [detectii, scoruriDetectii, imageIdx] = detectorMasina(parametri, zonaInteresImagine);
    end
    
    yMax = 0;
    puncteTrasareFinale = puncteTrasare;
    if isempty(detectii) == 0 && length(puncteTrasare) == 4
        yMax = detectii(1,end) + y_zona_interes + deplasareY;

        x1 = 1;
        x2 = 2;
        for i = 0:length(puncteTrasare)/4
            xa = puncteTrasare(x1+i,1);
            ya = puncteTrasare(x1+i,2);
            xb = puncteTrasare(x2+i,1);
            yb = puncteTrasare(x2+i,2);
            yc = yMax;
            
            xc = (xa*yc - xa*yb - xb*yc + xb*ya)/(ya - yb);
            x1 = x1 + 1;
            x2 = x2 + 1;
            puncteTrasareFinale = [puncteTrasareFinale; xc yc];
        end
    end
    
    if length(puncteTrasareFinale) >= 4
        x = xInceputDecupare;
        y = yInceputDecupare;
        
        puncteTrasareFinale(:,1) = puncteTrasareFinale(:,1) + x;
        puncteTrasareFinale(:,2) = puncteTrasareFinale(:,2) + y;
        puncteTrasare(:,1) = puncteTrasare(:,1) + x;
        puncteTrasare(:,2) = puncteTrasare(:,2) + y;
        
        x1 = 1;
        x2 = 2;
        for i = 0:length(puncteTrasare)/4
            xa = puncteTrasare(x1+i,1);
            ya = puncteTrasare(x1+i,2);
            xb = puncteTrasare(x2+i,1);
            yb = puncteTrasare(x2+i,2);
            yc = yMin;

            xc = (xa*yc - xa*yb - xb*yc + xb*ya)/(ya - yb);
            x1 = x1 + 1;
            x2 = x2 + 1;
            puncteTrasareFinale = [puncteTrasareFinale; xc yc];
        end
        
        pp = sortrows(puncteTrasareFinale,1);
        
        X = pp(:,1);
        Y = pp(:,2);
        
        cx = mean(X);
        cy = mean(Y);
        
        a = atan2(Y - cy, X - cx);
        
        [~, order] = sort(a);
        
        pp(:,1) = X(order);
        pp(:,2) = Y(order);
        
        if size(pp,1) == 6
            shapeFinal = [pp(1,1) pp(1,2) pp(2,1) pp(2,2) pp(3,1) pp(3,2) pp(4,1) pp(4,2) ...
                 pp(5,1) pp(5,2) pp(6,1) pp(6,2) pp(1,1) pp(1,2)];
            
            imagineTrasata = insertShape(imagineTrasata,'FilledPolygon',{shapeFinal},'Color', {'green'},'Opacity',0.5);
        elseif size(pp,1) == 7
            shapeFinal = [pp(1,1) pp(1,2) pp(2,1) pp(2,2) pp(3,1) pp(3,2) pp(4,1) pp(4,2) ...
                 pp(5,1) pp(5,2) pp(6,1) pp(6,2) pp(7,1) pp(7,2) pp(1,1) pp(1,2)];
             
            imagineTrasata = insertShape(imagineTrasata,'FilledPolygon',{shapeFinal},'Color', {'green'},'Opacity',0.5);
        elseif size(pp,1) == 8
            shapeFinal = [pp(1,1) pp(1,2) pp(2,1) pp(2,2) pp(3,1) pp(3,2) pp(4,1) pp(4,2) ...
                 pp(5,1) pp(5,2) pp(6,1) pp(6,2) pp(7,1) pp(7,2) pp(8,1) pp(8,2) pp(1,1) pp(1,2)];
             
            imagineTrasata = insertShape(imagineTrasata,'FilledPolygon',{shapeFinal},'Color', {'green'},'Opacity',0.5);
        end
    end
    
    if size(detectii) > 0
    imagineTrasata = cv.rectangle(imagineTrasata,[detectii(1)+x_s+xInceputDecupare+deplasareX detectii(2)+y_zona_interes+yInceputDecupare+deplasareY],...
            [detectii(3)+x_s+xInceputDecupare+deplasareX detectii(4)+y_zona_interes+yInceputDecupare+deplasareY],'Thickness',2,'Color',[0 255 0]);
    end

    [imagineIPM, matriceInversa] = obtineIPM(imagineTrasata,configuratie_detectie);

    if isempty(detectii) == 0
        x = (detectii(1)+x_s+xInceputDecupare+detectii(3)+x_s+xInceputDecupare)/2;
        y = detectii(4)+y_zona_interes+yInceputDecupare;
        obtineDistantaMasina([x y],inv(matriceInversa));
    end
    
    toc %% Sfarsit rulare
     
    image(imagineTrasata);
    pause(0.00001);
end

%% Curatam spatiul de lucru
clear, clc