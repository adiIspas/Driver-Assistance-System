fprintf('Incarcam imaginile din director \n');

clear, clc, close all;

% numeFolderImagini = 'cordova1';
numeFolderImagini = 'washington1';
numeDirector = [pwd '\' numeFolderImagini '\'];
tipImagine = 'png';

filelist = dir([numeDirector '*.' tipImagine]);
for idxImg = 1:length(filelist)
        clc
        fprintf(['Imaginea ' num2str(idxImg) ' din ' num2str(length(filelist)) ' ... \n']);
        imgName = filelist(idxImg).name;
        image = imread([numeDirector imgName]);

        imagineTest = rgb2gray(image(190:190+150,60:60+500,:));
        imagineIPM = obtineIPM(imagineTest);

        imagineFiltrata = filtrareIPM(imagineIPM);

        [liniiImagine, incadrare] = detectieLinii(imagineFiltrata);
        [puncteInteres, scorLinie] = RANSAC(imagineFiltrata, incadrare);

        imagineRezultat = uint8(zeros(size(imagineTest,1),size(imagineTest,2),1));
        imagineRezultat(:,:,1) = imagineFiltrata(:,:);

        pos = zeros(0,2);
        for u = 1:size(puncteInteres,1)/4
            puncte = sortrows(puncteInteres(u*4-4+1:u*4,:),2);
            for idx = 1:4
                i = round(puncte(idx,1));
                j = round(puncte(idx,2));
                if j == 0
                    j = 1;
                end
                imagineRezultat(j,i,:) = 255;
                pos = [pos; i j];
            end
        end

        imageMarked = insertMarker(imagineIPM,pos,'o');
        imshow(imageMarked);
        for u = 1:size(puncteInteres,1)/4
            puncte = sortrows(puncteInteres(u*4-4+1:u*4,:),2);

            for idx = 2:4
                i = round(puncte(idx-1,1));
                j = round(puncte(idx-1,2));
                ii = round(puncte(idx,1));
                jj = round(puncte(idx,2));
                line([i ii],[j jj]);
            end
        end
        
        pause(0.001);        
end