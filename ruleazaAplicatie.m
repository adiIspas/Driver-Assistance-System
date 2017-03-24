fprintf('Incarcam imaginile din director \n');

clear, clc, close all;

numeFolderImagini = 'cordova2';
% numeFolderImagini = 'washington2';
numeDirector = [pwd '\' numeFolderImagini '\'];
tipImagine = 'png';

configuratie_video_paper;

yInceputDecupare = configuratie.yInceputDecupare;
xInceputDecupare = configuratie.xInceputDecupare;
yLungimeDecupare = configuratie.yLungimeDecupare;
xLungimeDecupare = configuratie.xLungimeDecupare;

salveazaDetectii = 0;
mod2Benzi = 1;

filelist = dir([numeDirector '*.' tipImagine]);

if salveazaDetectii == 1
    fileID = fopen(['Evaluare_2Benzi\',numeFolderImagini,'\list.txt_results.txt'],'w');
end

for idxImg = 1:length(filelist)
        clc
        fprintf(['Imaginea ' num2str(idxImg) ' din ' num2str(length(filelist)) ' ... \n']);
        imgName = filelist(idxImg).name;
        
%         tic
        img = imread([numeDirector imgName]);

        imagineTest = img(yInceputDecupare:yInceputDecupare+yLungimeDecupare,...
            xInceputDecupare:xInceputDecupare+xLungimeDecupare,:);
        
        [imagineIPM, matriceInversa] = obtineIPM((imagineTest),configuratie);
        
        imshowpair(imagineTest,imagineIPM,'montage');
        pause
        
%         imagineFiltrata = filtrareIPM(imagineIPM);
% 
%         [liniiImagine, incadrare] = detectieLinii(imagineFiltrata, mod2Benzi);
%         [puncteInteres, scorLinie] = RANSAC(imagineFiltrata, incadrare);
% 
%         punctePlan = obtinePunctePlan(puncteInteres,matriceInversa);
%         
%         imagineTrasata = img;
%         numarSplines = 0;
%         textCompus = '';
%         for u = 1:size(punctePlan,1)/4
%             puncte = sortrows(punctePlan(u*4-4+1:u*4,:),2);
% %             puncte = ccvEvalBezSpline(puncte,.01);
%             textCompus = strcat(textCompus, ['\tspline#', num2str(u), ' has ', ...
%                 num2str(size(puncte,1)), ' points and score ', num2str(10), '\n']);
%             
%             for idx = 2:size(puncte,1)
%                 i = round(puncte(idx-1,1));
%                 j = round(puncte(idx-1,2));
%                 ii = round(puncte(idx,1));
%                 jj = round(puncte(idx,2));
%                 
%                 imagineTrasata = cv.line(imagineTrasata, ...
%                     [i+xInceputDecupare j+yInceputDecupare],[ii+xInceputDecupare jj+yInceputDecupare], ...
%                     'Thickness',5,'Color',[0 255 0]);
% 
%                 textCompus = strcat(textCompus, ['\t\t', num2str(i+xInceputDecupare),', ',num2str(j+yInceputDecupare),'\n']);
%             end
%             textCompus = strcat(textCompus, ['\t\t', num2str(ii+xInceputDecupare),', ',num2str(jj+yInceputDecupare),'\n']);
%             
%             numarSplines = numarSplines + 1;
%         end
%         toc
%         image(imagineTrasata);
%         pause(0.01);

        if salveazaDetectii == 1
            fprintf(fileID,'frame#%u has %u splines\n',idxImg,numarSplines);
            fprintf(fileID,textCompus);
        end
end
if salveazaDetectii == 1
    fclose(fileID);
end