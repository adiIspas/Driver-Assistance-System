clear, clc, close all;

numeFolderVideo = 'videos';
numeVideo = 'travel_video_3_cut.mp4';

yInceputDecupare = 250;
xInceputDecupare = 1;
yLungimeDecupare = 100;
xLungimeDecupare = 620;

mod2Benzi = 1;

video = VideoReader([numeFolderVideo '/' numeVideo]);
while hasFrame(video)
        clc
        tic
        image = readFrame(video);

        imagineTest = image(yInceputDecupare:yInceputDecupare+yLungimeDecupare,...
            xInceputDecupare:xInceputDecupare+xLungimeDecupare,:);
        [imagineIPM, matriceInversa] = obtineIPM(imagineTest);
        
        imagineFiltrata = filtrareIPM(imagineIPM);

        [liniiImagine, incadrare] = detectieLinii(imagineFiltrata, mod2Benzi);
        [puncteInteres, scorLinie] = RANSAC(imagineFiltrata, incadrare);
        toc
        
        tic
        punctePlan = obtinePunctePlan(puncteInteres,matriceInversa);
        
        imagineTrasata = image;
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
                    'Thickness',5,'Color',[0 255 0]);

                textCompus = strcat(textCompus, ['\t\t', num2str(i+xInceputDecupare),', ',num2str(j+yInceputDecupare),'\n']);
            end
            textCompus = strcat(textCompus, ['\t\t', num2str(ii+xInceputDecupare),', ',num2str(jj+yInceputDecupare),'\n']);
            
            numarSplines = numarSplines + 1;
        end
        toc
%         imshow(imagineIPM);
        imshow(imagineTrasata);
end