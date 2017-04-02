clear, clc, close all;

numeFolderVideo = 'videos';
numeVideo = 'traffic_video_2.mp4';

configuratie_video_2;
configuratie_decupaj_asfalt_video_2;
configuratie_detector_masina;

yInceputDecupare = configuratie.yInceputDecupare;
xInceputDecupare = configuratie.xInceputDecupare;
yLungimeDecupare = configuratie.yLungimeDecupare;
xLungimeDecupare = configuratie.xLungimeDecupare;

start_x = pozitie_start_x;
end_x = pozitie_sfarsit_x;
start_y = pozitie_start_y;
end_y = pozitie_sfarsit_y;

mod2Benzi = 1;

idxx = 1;
video = VideoReader([numeFolderVideo '/' numeVideo]);
while hasFrame(video)
    clc
%     tic
    img = readFrame(video);

    imagineCurenta = img(yInceputDecupare:yInceputDecupare+yLungimeDecupare,...
        xInceputDecupare:xInceputDecupare+xLungimeDecupare,:);
    [imagineIPM, matriceInversa] = obtineIPM(rgb2gray(imagineCurenta), configuratie);
    
    imagineFiltrata = filtrareIPM(imagineIPM);
    [liniiImagine, incadrare] = detectieLinii(imagineFiltrata, mod2Benzi);

    zonaInteresImagine = imagineCurenta(y_zona_interes:end,min(liniiImagine):max(liniiImagine),:);
    
    [puncteInteres, scorLinie] = RANSAC(imagineFiltrata, incadrare);
    punctePlan = obtinePunctePlan(puncteInteres,matriceInversa);
    
    imagineTrasata = img;
    numarSplines = 0;
    textCompus = '';
    
    p = punctePlan;
    x = xInceputDecupare;
    y = yInceputDecupare;
    p(:,1) = p(:,1) + x;
    p(:,2) = p(:,2) + y;
    
    p = sortrows(p,1);
    if size(p,1) >= 8
    shape = [p(1,1) p(1,2) p(2,1) p(2,2) p(3,1) p(3,2) p(4,1) p(4,2) ...
             p(5,1) p(5,2) p(6,1) p(6,2) p(7,1) p(7,2) p(8,1) p(8,2) p(1,1) p(1,2)];
    end
 
    for u = 1:size(punctePlan,1)/4
        puncte = sortrows(punctePlan(u*4-4+1:u*4,:),2);
            puncte = ccvEvalBezSpline(puncte);
        textCompus = strcat(textCompus, ['\tspline#', num2str(u), ' has ', ...
            num2str(size(puncte,1)), ' points and score ', num2str(10), '\n']);
        
        for idx = 2:size(puncte,1)
            i = round(puncte(idx-1,1));
            j = round(puncte(idx-1,2));
            ii = round(puncte(idx,1));
            jj = round(puncte(idx,2));
            
            imagineTrasata = cv.line(imagineTrasata, ...
                [i+xInceputDecupare j+yInceputDecupare],[ii+xInceputDecupare jj+yInceputDecupare], ...
                'Thickness',5,'Color',[0 255 0]);
        
            textCompus = strcat(textCompus, ['\t\t', num2str(i+xInceputDecupare),', ',num2str(j+yInceputDecupare),'\n']);
        end
        textCompus = strcat(textCompus, ['\t\t', num2str(ii+xInceputDecupare),', ',num2str(jj+yInceputDecupare),'\n']);
        
        numarSplines = numarSplines + 1;
    end
%     toc
  
    if size(p,1) >= 8
        imagineTrasata = insertShape(imagineTrasata,'FilledPolygon',{shape},'Color', {'green'},'Opacity',0.5);
    end
    
    tic
    [detectii, scoruriDetectii, imageIdx] = ruleazaDetectorFacial(parametri, zonaInteresImagine);
    toc
    
    if size(detectii) > 0
    imagineTrasata = cv.rectangle(imagineTrasata,[detectii(1)+min(liniiImagine)+xInceputDecupare detectii(2)+y_zona_interes+yInceputDecupare],...
            [detectii(3)+min(liniiImagine)+xInceputDecupare detectii(4)+y_zona_interes+yInceputDecupare],'Thickness',2,'Color',[0 255 0]);
    end
    
    image(imagineTrasata);
    pause(0.001);
end