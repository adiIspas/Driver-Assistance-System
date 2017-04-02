function [detectii, scoruriDetectii, imageIdx] = ruleazaDetectorFacial(parametri, frameCurent)
    % 'detectii' = matrice Nx4, unde 
    %           N este numarul de detectii  
    %           detectii(i,:) = [x_min, y_min, x_max, y_max]
    % 'scoruriDetectii' = matrice Nx1. scoruriDetectii(i) este scorul detectiei i
    % 'imageIdx' = tablou de celule Nx1. imageIdx{i} este imaginea in care apare detectia i
    %               (nu punem intregul path, ci doar numele imaginii: 'albert.jpg')

    % Aceasta functie returneaza toate detectiile ( = ferestre) pentru toate imaginile din parametri.numeDirectorExempleTest
    % Directorul cu numele parametri.numeDirectorExempleTest contine imagini ce
    % pot sau nu contine fete. Aceasta functie ar trebui sa detecteze fete atat pe setul de
    % date MIT+CMU dar si pentru alte imagini (imaginile realizate cu voi la curs+laborator).
    % Functia 'suprimeazaNonMaximele' suprimeaza detectii care se suprapun (protocolul de evaluare considera o detectie duplicata ca fiind falsa)
    % Suprimarea non-maximelor se realizeaza pe pentru fiecare imagine.

    % Functia voastra ar trebui sa calculeze pentru fiecare imagine
    % descriptorul HOG asociat. Apoi glisati o fereastra de dimeniune paremtri.dimensiuneFereastra x  paremtri.dimensiuneFereastra (implicit 36x36)
    % si folositi clasificatorul liniar (w,b) invatat poentru a obtine un scor. Daca acest scor este deasupra unui prag (threshold) pastrati detectia
    % iar apoi mporcesati toate detectiile prin suprimarea non maximelor.
    % pentru detectarea fetelor de diverse marimi folosit un detector multiscale

    %initializare variabile de returnat
    detectii = zeros(0,4);
    scoruriDetectii = zeros(0,1);
    imageIdx = cell(0,1);
    imaginiFinale = cell(0,1);
    
    imaginiPuternicNegative = [];
    exemplePuternicNegative = 0;
    idxPN = 0;

    img = frameCurent;    
    if(size(img,3) > 1)
        img = rgb2gray(img);
    end

    %completati codul functiei in continuare

    imgOriginala = img;
    marimeInitiala = size(img);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                                               %
    %    Partea in care realizam marirea imagini    %
    %                                               %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    detectiiTemporareMarire = zeros(0,4);
    scoruriDetectiiTemporareMarire = zeros(0,1);
    imageIdxTemporareMarire = cell(0,1);
    imaginiTemporareMarire = cell(0,1);

    img = imgOriginala;
    scale = 1.2;
    for pas = 1:3
        img = imresize(img,scale);
        descriptorHOGImagine = vl_hog(single(img),parametri.dimensiuneCelulaHOG);
        step = round(parametri.dimensiuneFereastra/parametri.dimensiuneCelulaHOG);
        dimCelula = parametri.dimensiuneCelulaHOG;
        detectiiCurente = zeros(0,4);
        scoruriDetectiiCurente = zeros(0,1);
        imageIdxCurente = cell(0,1);
        dim = parametri.dimensiuneFereastra;

        for j = 1:size(descriptorHOGImagine,1)-step
            for k = 1:size(descriptorHOGImagine,2)-step
                descriptorHOGCurent = descriptorHOGImagine(j:j-1+step,k:k-1+step,:);
                result = descriptorHOGCurent(:)'*parametri.w+parametri.b;
                if result > parametri.threshold
                    rezultat_clasificare = result;
                    marimeActuala = size(img);
                    raport_x = (marimeInitiala(2)/marimeActuala(2));
                    raport_y = (marimeInitiala(1)/marimeActuala(1));

                    detectiiCurente = [detectiiCurente; ceil(((k-1)*dimCelula+1)*raport_x) ceil(((j-1)*dimCelula+1)*raport_y) ceil(((k-1)*dimCelula+dim)*raport_x) ceil(((j-1)*dimCelula+dim)*raport_y)];
                    scoruriDetectiiCurente = [scoruriDetectiiCurente rezultat_clasificare];
%                     imageIdxCurente = [imageIdxCurente imgFiles(i).name];
                end
            end
        end

        rezultate = [];
        if(size(detectiiCurente,1) > 0)
            rezultate = eliminaNonMaximele(detectiiCurente,scoruriDetectiiCurente,size(imgOriginala));
        end

        detectiiTemporareMarire = [detectiiTemporareMarire; detectiiCurente(rezultate,:)];
        scoruriDetectiiTemporareMarire = [scoruriDetectiiTemporareMarire scoruriDetectiiCurente(rezultate)];
%         imageIdxTemporareMarire = [imageIdxTemporareMarire imageIdxCurente(rezultate)];
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                                               %
    %  Partea in care realizam micsorarea imagini   %
    %                                               %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    detectiiTemporareMicsorare = zeros(0,4);
    scoruriDetectiiTemporareMicsorare = zeros(0,1);
    imageIdxTemporareMicsorare = cell(0,1);
    imaginiTemporareMicsorare = cell(0,1);

%         img = imgOriginala;
%         scale = 0.9;
%         while size(img,1) >= 45 && size(img,2) >= 45
% %             img = imresize(img,scale);
%             descriptorHOGImagine = vl_hog(single(img),parametri.dimensiuneCelulaHOG);
%             step = round(parametri.dimensiuneFereastra/parametri.dimensiuneCelulaHOG);
%             dimCelula = parametri.dimensiuneCelulaHOG;
%             detectiiCurente = zeros(0,4);
%             scoruriDetectiiCurente = zeros(0,1);
%             imageIdxCurente = cell(0,1);
%             dim = parametri.dimensiuneFereastra;
% 
%             for j = 1:size(descriptorHOGImagine,1)-step
%                 for k = 1:size(descriptorHOGImagine,2)-step
%                     descriptorHOGCurent = descriptorHOGImagine(j:j-1+step,k:k-1+step,:);
%                     result = descriptorHOGCurent(:)'*parametri.w+parametri.b;
%                     if result > parametri.threshold
%                         rezultat_clasificare = result;
%                         marimeActuala = size(img);
%                         raport_x = (marimeInitiala(2)/marimeActuala(2));
%                         raport_y = (marimeInitiala(1)/marimeActuala(1));
%                         
%                         if puternicNegative == 1
%                             idxPN = idxPN + 1;
%                             imagineCurenta = uint8(img((j-1)*dimCelula+1:(j-1)*dimCelula+dim,(k-1)*dimCelula+1:(k-1)*dimCelula+dim));
%                             imaginiTemporareMicsorare = [imaginiTemporareMicsorare imagineCurenta];
%                         end
%                         
%                         detectiiCurente = [detectiiCurente; ceil(((k-1)*dimCelula+1)*raport_x) ceil(((j-1)*dimCelula+1)*raport_y) ceil(((k-1)*dimCelula+dim)*raport_x) ceil(((j-1)*dimCelula+dim)*raport_y)];
%                         scoruriDetectiiCurente = [scoruriDetectiiCurente rezultat_clasificare];
%                         imageIdxCurente = [imageIdxCurente imgFiles(i).name];
%                     end
%                 end
%             end
% 
%             rezultate = [];
%             if(size(detectiiCurente,1) > 0)
%                 rezultate = eliminaNonMaximele(detectiiCurente,scoruriDetectiiCurente,size(imgOriginala));
%             end
% 
%             detectiiTemporareMicsorare = [detectiiTemporareMicsorare; detectiiCurente(rezultate,:)];
%             scoruriDetectiiTemporareMicsorare = [scoruriDetectiiTemporareMicsorare scoruriDetectiiCurente(rezultate)];
%             imageIdxTemporareMicsorare = [imageIdxTemporareMicsorare imageIdxCurente(rezultate)];
%             
%             if puternicNegative == 1
%                 imaginiTemporareMicsorare = [imaginiTemporareMicsorare imaginiTemporareMicsorare(rezultate)];
%             end
%             img = imresize(img,scale);
%         end


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                                               %
    %  Partea in care trecem prin toate detectiile  %
    %                                               %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    detectiiTemporare = zeros(0,4);
    scoruriDetectiiTemporare = zeros(0,1);
    imageIdxTemporare = cell(0,1);
    imaginiTemporare = cell(0,1);

    detectiiTemporare = [detectiiTemporare; detectiiTemporareMicsorare; detectiiTemporareMarire];
    scoruriDetectiiTemporare = [scoruriDetectiiTemporare scoruriDetectiiTemporareMicsorare scoruriDetectiiTemporareMarire];
%     imageIdxTemporare = [imageIdxTemporare imageIdxTemporareMicsorare imageIdxTemporareMarire];

    rezultate = [];
    if(size(detectiiTemporare,1) > 0)
        rezultate = eliminaNonMaximele(detectiiTemporare,scoruriDetectiiTemporare,size(imgOriginala));
    end

    detectii = [detectii; detectiiTemporare(rezultate,:)];
    scoruriDetectii = [scoruriDetectii scoruriDetectiiTemporare(rezultate)];
%     imageIdx = [imageIdx imageIdxTemporare(rezultate)];

end