%% Adrian ISPAS, Facultate de Matematică si Informatică, UNIBUC
clear, clc, close all;

% Presetari
detalii = 1;
salvareVideo = 0;

if salvareVideo == 1
    %% Initializăm video-ul.
    writerObj = VideoWriter('../video_detalii.avi'); % Numele final pentru salvare.
    writerObj.FrameRate = 20; % Numarul de frame-uri dorite.
    open(writerObj);
end

for i = 1:6
    %% Initializam parametrii de lucru
    tip_video = 'sd';
    numeFolderVideo = ['videos_' tip_video];
    numarVideo = i;
    numeVideo = ['traffic_video_' num2str(numarVideo) '.mp4'];

    eval(['configuratie_video_' tip_video '_' num2str(numarVideo)]);
    eval(['configuratie_decupaj_asfalt_video_' tip_video '_' num2str(numarVideo)]);
    eval(['configuratie_banda_video_' tip_video '_' num2str(numarVideo)]);
    eval(['configuratie_detectie_masina_video_' tip_video '_' num2str(numarVideo)]);
    eval(['configuratie_distanta_viteza_video_' tip_video '_' num2str(numarVideo)]);
    configuratie_detector_masina;

    yInceputDecupare = configuratie.yInceputDecupare;
    xInceputDecupare = configuratie.xInceputDecupare;
    yLungimeDecupare = configuratie.yLungimeDecupare;
    xLungimeDecupare = configuratie.xLungimeDecupare;

    puncteTrasareTemporare = [];
    trasareTemporara = numarTrasariTemporare;
    detectieTemporara = numarDetectiiTemporare;
    deplasareXAnterior = 0;
    deplasareYAnterior = 0;
    zonaInteresImagineAnterior = 0;
    pozitieDetectieTemporare = [];
    mod2Benzi = 1;
    distantaAnterioara = 0;
    centruAnterior = [0 0];

    detectiiTemporare = numarDetectiiTemporare;
    detectiiT = [];
    x_sTemporar = 0;
    xInceputDecupareTemporar = 0;
    deplasareXTemporar = 0;
    y_zona_interesTemporar = 0;
    yInceputDecupareTemporar = 0;
    deplasareYTemporar = 0;

    %% Rulam aplicatia
    video = VideoReader([numeFolderVideo '/' numeVideo]);
    figure('units','normalized','outerposition',[0 0 1 1])
    while hasFrame(video)
        clc    
        tic %% Inceput rulare
        img = readFrame(video);
        
        if strcmp(tip_video,'sd')
            img = imresize(img,[360 640]);
        end
        
        detectii = [];
        colorBanda = {'green'};
        colorDetectie = [0 255 0];

        imagineCurenta = img(yInceputDecupare:yInceputDecupare+yLungimeDecupare,...
            xInceputDecupare:xInceputDecupare+xLungimeDecupare,:);
        [imagineIPM, matriceInversa] = obtineIPM(imagineCurenta, configuratie);
        
        imagineIPMAfisare = imagineIPM;

        imagineFiltrata = filtrareIPM(rgb2gray(imagineIPM));
        [liniiImagine, incadrare, coloaneFiltrate] = detectieLinii(imagineFiltrata, mod2Benzi);

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

        if isempty(detectii) == 1
            if detectiiTemporare > 0 && isempty(detectiiT) == 0
                detectii = detectiiT;
                x_s = x_sTemporar;
                xInceputDecupare = xInceputDecupareTemporar;
                deplasareX = deplasareXTemporar;
                y_zona_interes = y_zona_interesTemporar;
                yInceputDecupare = yInceputDecupareTemporar;
                deplasareY = deplasareYTemporar;

                detectiiTemporare = detectiiTemporare - 1;
            else
                detectiiT = [];
                centruAnterior = [0 0];
            end
        else
            corner_1 = [detectii(1)+x_s+xInceputDecupare+deplasareX detectii(2)+y_zona_interes+yInceputDecupare+deplasareY];
            corner_2 = [detectii(3)+x_s+xInceputDecupare+deplasareX detectii(4)+y_zona_interes+yInceputDecupare+deplasareY];
            midPointCar = [(corner_1(1,1) + corner_2(1,1))/2 (corner_1(1,2) + corner_2(1,2))/2];

            if pdist([midPointCar; centruAnterior],'euclidean') > distantaMaximaCentre
                detectiiT = detectii;
                x_sTemporar = x_s;
                xInceputDecupareTemporar = xInceputDecupare;
                deplasareXTemporar = deplasareX;
                y_zona_interesTemporar = y_zona_interes;
                yInceputDecupareTemporar = yInceputDecupare;
                deplasareYTemporar = deplasareY;
                centruAnterior = midPointCar;

                detectiiTemporare = numarDetectiiTemporare;
            else
                detectii = detectiiT;
                x_s = x_sTemporar;
                xInceputDecupare = xInceputDecupareTemporar;
                deplasareX = deplasareXTemporar;
                y_zona_interes = y_zona_interesTemporar;
                yInceputDecupare = yInceputDecupareTemporar;
                deplasareY = deplasareYTemporar;

                detectiiTemporare = detectiiTemporare - 1;
            end
        end

        imagineTrasata = insertShape(imagineTrasata,'FilledPolygon',{[10 5 10 70 250 70 250 5]},'Color', {'black'},'Opacity',0.4);
        details = 0;
        if size(detectii) > 0
            [imagineIPM, ~, matriceIPM] = obtineIPM(imagineTrasata(1:yMin, ...
                y_start:y_end,:), configuratie_detectie);

            corner_1 = [detectii(1)+x_s+xInceputDecupare+deplasareX detectii(2)+y_zona_interes+yInceputDecupare+deplasareY];
            corner_2 = [detectii(3)+x_s+xInceputDecupare+deplasareX detectii(4)+y_zona_interes+yInceputDecupare+deplasareY];
            midPointCar = [(corner_1(1,1) + corner_2(1,1))/2 (corner_1(1,2) + corner_2(1,2))/2];

            x = midPointCar(1,1);
            y = midPointCar(1,2);
            distanta = obtineDistantaMasina([x y], matriceIPM, size(imagineIPM,1), pixeliPerMetru);

            vitezaRelativa = (distanta - distantaAnterioara) * 3.6;
            distantaAnterioara = distanta;

            if vitezaRelativa < 0
                colorBanda = {'red'};
                colorDetectie = [255 0 0];
            elseif vitezaRelativa <= 10
                colorBanda = {'yellow'};
                colorDetectie = [255 255 0];
            end

            cornerDetectie1 = [detectii(1)+x_s+xInceputDecupare+deplasareX detectii(2)+y_zona_interes+yInceputDecupare+deplasareY];
            cornerDetectie2 = [detectii(3)+x_s+xInceputDecupare+deplasareX detectii(4)+y_zona_interes+yInceputDecupare+deplasareY];

            imagineTrasata = cv.rectangle(imagineTrasata,cornerDetectie1,...
                    cornerDetectie2,'Thickness',2,'Color', colorDetectie);

            imagineTrasata = cv.putText(imagineTrasata, [num2str(distanta) ' m'], ...
                [10, 30], 'FontScale', 0.9, 'Color', colorDetectie);
            imagineTrasata = cv.putText(imagineTrasata, [num2str(vitezaRelativa) ' km/h'], ...
                [10, 60], 'FontScale', 0.9, 'Color', colorDetectie);
            details = 1;
        end

        if details == 0
            imagineTrasata = cv.putText(imagineTrasata, [num2str(0) ' m'], ...
                [10, 30], 'FontScale', 0.9, 'Color', colorDetectie);
            imagineTrasata = cv.putText(imagineTrasata, [num2str(0) ' km/h'], ...
                [10, 60], 'FontScale', 0.9, 'Color', colorDetectie);
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

                imagineTrasata = insertShape(imagineTrasata,'FilledPolygon',{shapeFinal},'Color', colorBanda,'Opacity',0.5);
            elseif size(pp,1) == 7
                shapeFinal = [pp(1,1) pp(1,2) pp(2,1) pp(2,2) pp(3,1) pp(3,2) pp(4,1) pp(4,2) ...
                     pp(5,1) pp(5,2) pp(6,1) pp(6,2) pp(7,1) pp(7,2) pp(1,1) pp(1,2)];

                imagineTrasata = insertShape(imagineTrasata,'FilledPolygon',{shapeFinal},'Color', colorBanda,'Opacity',0.5);
            elseif size(pp,1) == 8
                shapeFinal = [pp(1,1) pp(1,2) pp(2,1) pp(2,2) pp(3,1) pp(3,2) pp(4,1) pp(4,2) ...
                     pp(5,1) pp(5,2) pp(6,1) pp(6,2) pp(7,1) pp(7,2) pp(8,1) pp(8,2) pp(1,1) pp(1,2)];

                imagineTrasata = insertShape(imagineTrasata,'FilledPolygon',{shapeFinal},'Color', colorBanda,'Opacity',0.5);
            end
        end

        toc %% Sfarsit rulare

        if detalii == 1
            subplot(3,3,1), image(img), title('Original image. Step 0');
            subplot(3,3,2), image(imagineIPMAfisare), title('IPM Image. Step 1');
            subplot(3,3,3), image(imagineFiltrata), title('Image filtering. Step 2');
            subplot(3,3,4), findpeaks(coloaneFiltrate), title('Lane signal. Step 3');
            subplot(3,3,7), image(zonaInteresImagine), title('Region of interest. Step 4');
            subplot(3,3,[5, 6, 8, 9]), image(imagineTrasata), title('Final result. Step 5');
            
            if salvareVideo == 1
                frame = getframe(gcf);
                writeVideo(writerObj, frame);
            end
        else
            image(imagineTrasata)
            if salvareVideo == 1
                writeVideo(writerObj, imagineTrasata);
            end
        end
        pause(0.00001);
    end
    
    close all;
end

if salvareVideo == 1
    close(writerObj);
end

%% Curatam spatiul de lucru
clear, clc, close all