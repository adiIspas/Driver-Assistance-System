clear, clc, close all;

% numeFolderImagini = 'cordova1';
numeFolderImagini = 'washington1';

numeDirector = [pwd '\videos_paper\' numeFolderImagini '\'];
tipImagine = 'png';

configuratie_video_paper;

yInceputDecupare = configuratie.yInceputDecupare;
xInceputDecupare = configuratie.xInceputDecupare;
yLungimeDecupare = configuratie.yLungimeDecupare;
xLungimeDecupare = configuratie.xLungimeDecupare;

salveazaDetectii = 1;
mod2Benzi = 1;

filelist = dir([numeDirector '*.' tipImagine]);

if salveazaDetectii == 1
    fileID = fopen(['Evaluare_2Benzi\',numeFolderImagini,'\list.txt_results.txt'],'w');
end

% The ground truth labels
truthFiles = {
  'videos_paper/washington1/labels.ccvl'
  };
truths = ccvLabel('read', truthFiles{1});

suprapunereAdnotari = 0;
for idxImg = 1:length(filelist)
    clc
    
    imgName = filelist(idxImg).name;
    image = imread([numeDirector imgName]);
    imagineTrasata = image;
    if(size(truths.frames(idxImg).labels,1) > 0 && suprapunereAdnotari == 1)
        imagineTrasata = image;
        for idy = 1:size(truths.frames(idxImg).labels,2)
            punctePlan = truths.frames(idxImg).labels(idy).points;
            
            for u = 1:size(punctePlan,1)/4
                puncte = sortrows(punctePlan(u*4-4+1:u*4,:),2);
                
                for idx = 2:size(puncte,1)
                    i = round(puncte(idx-1,1));
                    j = round(puncte(idx-1,2));
                    ii = round(puncte(idx,1));
                    jj = round(puncte(idx,2));
                    
                    if abs(320 - i) <= 40
                        if truths.frames(idxImg).labels(idy).subtype == 'dy'
                            imagineTrasata = cv.line(imagineTrasata, ...
                                [i j],[ii jj], ...
                                'Thickness',5,'Color',[0 255 0]);
                        elseif truths.frames(idxImg).labels(idy).subtype == 'sw'
                            imagineTrasata = cv.line(imagineTrasata, ...
                                [i j],[ii jj], ...
                                'Thickness',5,'Color',[255 0 0]);
                        elseif truths.frames(idxImg).labels(idy).subtype == 'bw'
                            imagineTrasata = cv.line(imagineTrasata, ...
                                [i j],[ii jj], ...
                                'Thickness',5,'Color',[0 0 255]);
                        end
                        imagineTrasata = cv.putText(imagineTrasata, num2str(idy), [i j]);
                    end
                end
            end
        end
    end

    imagineTest = image(yInceputDecupare:yInceputDecupare+yLungimeDecupare,...
        xInceputDecupare:xInceputDecupare+xLungimeDecupare,:);

    [imagineIPM, matriceInversa] = obtineIPM((imagineTest),configuratie);

    imagineIPM = rgb2gray(imagineIPM);
    imagineFiltrata = filtrareIPM(imagineIPM);

    [liniiImagine, incadrare] = detectieLinii(imagineFiltrata, mod2Benzi);
    [puncteInteres, scorLinie] = RANSAC(imagineFiltrata, incadrare);
    
    punctePlan = obtinePunctePlan(puncteInteres,matriceInversa);

    numarSplines = 0;
    textCompus = '';
    for u = 1:size(punctePlan,1)/4
        puncte = sortrows(punctePlan(u*4-4+1:u*4,:),2);
        textCompus = strcat(textCompus, ['\tspline#', num2str(u), ' has ', ...
            num2str(size(puncte,1)), ' points and score ', num2str(10), '\n']);

        for idx = 2:size(puncte,1)
            i = round(puncte(idx-1,1));
            j = round(puncte(idx-1,2));
            ii = round(puncte(idx,1));
            jj = round(puncte(idx,2));

            imagineTrasata = cv.line(imagineTrasata, ...
                [i+xInceputDecupare j+yInceputDecupare],[ii+xInceputDecupare jj+yInceputDecupare], ...
                'Thickness',5,'Color',[255 0 0]);

            textCompus = strcat(textCompus, ['\t\t', num2str(i+xInceputDecupare),', ',num2str(j+yInceputDecupare),'\n']);
        end
        textCompus = strcat(textCompus, ['\t\t', num2str(ii+xInceputDecupare),', ',num2str(jj+yInceputDecupare),'\n']);

        numarSplines = numarSplines + 1;
    end

%     imshow(imagineTrasata)

    if salveazaDetectii == 1
        fprintf(fileID,'frame#%u has %u splines\n',idxImg,numarSplines);
        fprintf(fileID,textCompus);
    end
end

if salveazaDetectii == 1
    fclose(fileID);
end