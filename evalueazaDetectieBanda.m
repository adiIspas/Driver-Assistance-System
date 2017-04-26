fprintf('Incarcam imaginile din director \n');

clear, clc, close all;

numeFolderImagini = 'cordova1';
% numeFolderImagini = 'washington1';
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
  'videos_paper/cordova1/labels.ccvl'
  };
truths = ccvLabel('read', truthFiles{1});

ddd = [];
for idxImg = 1:length(filelist)
%     clc
    splines = {};
        %%%%% detectii paper
    imgName = filelist(idxImg).name;
    image = imread([numeDirector imgName]);
    imagineTrasata = image;
%     if(size(truths.frames(idxImg).labels,1) > 0)
%         imagineTrasata = image;
%         for idy = 1:size(truths.frames(idxImg).labels,2)
%             punctePlan = truths.frames(idxImg).labels(idy).points;
%             
% %             punctePlan
%             for u = 1:size(punctePlan,1)/4
%                 puncte = sortrows(punctePlan(u*4-4+1:u*4,:),2);
%                 
%                 for idx = 2:size(puncte,1)
%                     i = round(puncte(idx-1,1));
%                     j = round(puncte(idx-1,2));
%                     ii = round(puncte(idx,1));
%                     jj = round(puncte(idx,2));
%                     
%                     if abs(320 - i) <= 40
%                         if truths.frames(idxImg).labels(idy).subtype == 'dy'
%                             imagineTrasata = cv.line(imagineTrasata, ...
%                                 [i j],[ii jj], ...
%                                 'Thickness',5,'Color',[0 255 0]);
%                         elseif truths.frames(idxImg).labels(idy).subtype == 'sw'
%                             imagineTrasata = cv.line(imagineTrasata, ...
%                                 [i j],[ii jj], ...
%                                 'Thickness',5,'Color',[255 0 0]);
%                         elseif truths.frames(idxImg).labels(idy).subtype == 'bw'
%                             imagineTrasata = cv.line(imagineTrasata, ...
%                                 [i j],[ii jj], ...
%                                 'Thickness',5,'Color',[0 0 255]);
%                         end
%                         imagineTrasata = cv.putText(imagineTrasata, num2str(idy), [i j]);
%                     end
%                 end
%             end
%         end
%     end
        %%%%% detectii paper

%         fprintf(['Imaginea ' num2str(idxImg) ' din ' num2str(length(filelist)) ' ... \n']);
%         imgName = filelist(idxImg).name;
%         
% %         tic
%         image = imread([numeDirector imgName]);

        imagineTest = image(yInceputDecupare:yInceputDecupare+yLungimeDecupare,...
            xInceputDecupare:xInceputDecupare+xLungimeDecupare,:);
        
        [imagineIPM, matriceInversa] = obtineIPM(rgb2gray(imagineTest),configuratie);
        
%         imshow(imagineIPM)
%         imshowpair(imagineTest,imagineIPM,'montage');
%         pause
        
        imagineFiltrata = filtrareIPM(imagineIPM);

        [liniiImagine, incadrare] = detectieLinii(imagineFiltrata, mod2Benzi);
        [puncteInteres, scorLinie] = RANSAC(imagineFiltrata, incadrare);

        punctePlan = obtinePunctePlan(puncteInteres,matriceInversa);
        
%         imagineTrasata = image;
        numarSplines = 0;
        textCompus = '';
        for u = 1:size(punctePlan,1)/4
            puncte = sortrows(punctePlan(u*4-4+1:u*4,:),2);
%             puncte = ccvEvalBezSpline(puncte,.01);
            textCompus = strcat(textCompus, ['\tspline#', num2str(u), ' has ', ...
                num2str(size(puncte,1)), ' points and score ', num2str(10), '\n']);
            splines = [splines; puncte];
            for idx = 2:size(puncte,1)
                i = round(puncte(idx-1,1));
                j = round(puncte(idx-1,2));
                ii = round(puncte(idx,1));
                jj = round(puncte(idx,2));
                
                imagineTrasata = cv.line(imagineTrasata, ...
                    [i+xInceputDecupare j+yInceputDecupare],[ii+xInceputDecupare jj+yInceputDecupare], ...
                    'Thickness',5,'Color',[0 0 0]);

                textCompus = strcat(textCompus, ['\t\t', num2str(i+xInceputDecupare),', ',num2str(j+yInceputDecupare),'\n']);
            end
            textCompus = strcat(textCompus, ['\t\t', num2str(ii+xInceputDecupare),', ',num2str(jj+yInceputDecupare),'\n']);
            
            numarSplines = numarSplines + 1;
        end

%         '---'
        if(size(truths.frames(idxImg).labels,1) > 0)
        %         imagineTrasata = image;
        splines2 = {};
        for idy = 1:size(truths.frames(idxImg).labels,2)
            punctePlan = truths.frames(idxImg).labels(idy).points;

        %             punctePlan
            for u = 1:size(punctePlan,1)/4
                puncte = sortrows(punctePlan(u*4-4+1:u*4,:),2);
                
                for idx = 2:size(puncte,1)
                    i = round(puncte(idx-1,1));
                    j = round(puncte(idx-1,2));
                    ii = round(puncte(idx,1));
                    jj = round(puncte(idx,2));

                    if abs(320 - i) <= 40
                        splines2 = [splines2; puncte];
%                         puncte
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
%         '---'
%         splines{1}
%         splines{2}
%         '---'
%         splines2{1}
%         splines2{2}
%         
%         pause

        for j=1:length(splines)
            %flag
            detection = 0;
            %loop on truth and get which one
            k = 1;
            while detection==0 && k<=length(splines2)
%                 ddd = [ddd ccvCheckMergeSplines(splines{j}, ...
%                                         splines2{k}, meanDistThreshold, ...
%                                         medianDistThreshold)];

                x = ccvCheckMergeSplines(splines{j}, ...
                                        splines2{k}, 100, ...
                                        100);
                               
%                     '----'
%                     splines{j}
%                     splines2{k}
%                     
%                     '----'
                if ccvCheckMergeSplines(splines{j}, ...
                                        splines2{k}, 200, ...
                                        200)
                                    ddd = [ddd 1];
                    %not false pos
                    detection = 1;
%                     truthDetections(k) = 1;
                else
                    ddd = [ddd 0];
                end;
                %inc
                k = k+1;                
            end; %while

            %check result
%             result.score = detectionFrame.scores(j);
%             result.detection = detection;
%             results = [results, result];
%             frameDetections = [frameDetections, detection];
        end; %for
        
        
        imshow(imagineTrasata)
        
        if salveazaDetectii == 1
            fprintf(fileID,'frame#%u has %u splines\n',idxImg,numarSplines);
            fprintf(fileID,textCompus);
        end
end
            size(ddd,2)
            sum(ddd)

if salveazaDetectii == 1
    fclose(fileID);
end