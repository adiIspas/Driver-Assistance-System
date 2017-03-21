clear, clc, close all;

numeFolderVideo = 'videos';
numeVideo = 'traffic_video_2.mp4';

configuratie_video_2;

yInceputDecupare = configuratie.yInceputDecupare;
xInceputDecupare = configuratie.xInceputDecupare;
yLungimeDecupare = configuratie.yLungimeDecupare;
xLungimeDecupare = configuratie.xLungimeDecupare;

mod2Benzi = 1;

video = VideoReader([numeFolderVideo '/' numeVideo]);
while hasFrame(video)
    clc
    tic
    img = readFrame(video);

    imagineTest = img(yInceputDecupare:yInceputDecupare+yLungimeDecupare,...
        xInceputDecupare:xInceputDecupare+xLungimeDecupare,:);
    [imagineIPM, matriceInversa] = obtineIPM(rgb2gray(imagineTest), configuratie);

    imagineFiltrata = filtrareIPM(imagineIPM);

    [liniiImagine, incadrare] = detectieLinii(imagineFiltrata, mod2Benzi);
    [puncteInteres, scorLinie] = RANSAC(imagineFiltrata, incadrare);

    punctePlan = obtinePunctePlan(puncteInteres,matriceInversa);

    imagineTrasata = img;
    numarSplines = 0;
    textCompus = '';
    for u = 1:size(punctePlan,1)/4
        puncte = sortrows(punctePlan(u*4-4+1:u*4,:),2);
%             puncte = ccvEvalBezSpline(puncte);
        textCompus = strcat(textCompus, ['\tspline#', num2str(u), ' has ', ...
            num2str(size(puncte,1)), ' points and score ', num2str(10), '\n']);

        for idx = 2:size(puncte,1)
            i = round(puncte(idx-1,1));
            j = round(puncte(idx-1,2));
            ii = round(puncte(idx,1));
            jj = round(puncte(idx,2));

            imagineTrasata = cv.line(imagineTrasata, ...
                [i+xInceputDecupare j+yInceputDecupare],[ii+xInceputDecupare jj+yInceputDecupare], ...
                'Thickness',7,'Color',[0 255 0]);

            textCompus = strcat(textCompus, ['\t\t', num2str(i+xInceputDecupare),', ',num2str(j+yInceputDecupare),'\n']);
        end
        textCompus = strcat(textCompus, ['\t\t', num2str(ii+xInceputDecupare),', ',num2str(jj+yInceputDecupare),'\n']);

        numarSplines = numarSplines + 1;
    end
    toc
    
%     imshow(imagineIPM);
    image(imagineTrasata);
    pause(0.000001);
end
