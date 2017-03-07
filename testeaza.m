fprintf('Incarcam imaginile din director \n');

clear, clc, close all;

numeFolderImagini = 'cordova2';
% numeFolderImagini = 'washington1';
numeDirector = [pwd '\' numeFolderImagini '\'];
tipImagine = 'png';
yInceputDecupare = 190;
xInceputDecupare = 60;
yLungimeDecupare = 150;
xLungimeDecupare = 500;

filelist = dir([numeDirector '*.' tipImagine]);
for idxImg = 1:length(filelist)
        clc
        fprintf(['Imaginea ' num2str(idxImg) ' din ' num2str(length(filelist)) ' ... \n']);
        imgName = filelist(idxImg).name;
        
        tic
        image = imread([numeDirector imgName]);

        imagineTest = rgb2gray(image(yInceputDecupare:yInceputDecupare+yLungimeDecupare,...
            xInceputDecupare:xInceputDecupare+xLungimeDecupare,:));
        [imagineIPM, matriceInversa] = obtineIPM(imagineTest);

        imagineFiltrata = filtrareIPM(imagineIPM);

        [liniiImagine, incadrare] = detectieLinii(imagineFiltrata);
        [puncteInteres, scorLinie] = RANSAC(imagineFiltrata, incadrare);
        
        punctePlan = obtinePunctePlan(puncteInteres,matriceInversa);
        
        imagineTrasata = image;
        for u = 1:size(punctePlan,1)/4
            puncte = sortrows(punctePlan(u*4-4+1:u*4,:),2);

            for idx = 2:4
                i = round(puncte(idx-1,1));
                j = round(puncte(idx-1,2));
                ii = round(puncte(idx,1));
                jj = round(puncte(idx,2));
                
                 if i < 0 || j < 0 || ii < 0 || jj < 0
                    continue;
                 end
                
                imagineTrasata = cv.line(imagineTrasata, ...
                    [i+xInceputDecupare j+yInceputDecupare],[ii+xInceputDecupare jj+yInceputDecupare], ...
                    'Thickness',5,'Color',[0 255 0]);
                
            end
        end
        toc
        imshow(imagineTrasata);
end