function [ imagine_interes, pozitie_masina ] = obtineZonaInteres(imagine, zonaInteresImagine, start_x, end_x, start_y, end_y)
%obtineZonaInteres 

    portiune = imagine(start_y:end_y,start_x:end_x,:);
    mediaCulorii = mean(mean(portiune(:,:,:)));
    R = mediaCulorii(:,:,1);
    G = mediaCulorii(:,:,2);
    B = mediaCulorii(:,:,3);

%     configuratie_detectie_masina;
%     imagineIPM = obtineIPM(imagine,configuratie);
    
    rezultat = ones(size(zonaInteresImagine));
    for i = 1:size(zonaInteresImagine,1)
        for j = 1:size(zonaInteresImagine,2)
            if zonaInteresImagine(i,j,1) >= R - 35 && zonaInteresImagine(i,j,1) <= R + 35
                rezultat(i,j,1) = 0;
            end
            if zonaInteresImagine(i,j,2) >= G - 35 && zonaInteresImagine(i,j,2) <= G + 35
                rezultat(i,j,2) = 0;
            end
            if zonaInteresImagine(i,j,3) >= B - 35 && zonaInteresImagine(i,j,3) <= B + 35
                rezultat(i,j,3) = 0;
            end
        end
    end
    
    imagine_interes = uint8(double(zonaInteresImagine) .* rezultat);
    
    I = rgb2gray(zonaInteresImagine);
    tic
    mask = zeros(size(I));
mask(25:end-25,25:end-25) = 1;
% figure
% imshow(mask)
% title('Initial Contour Location')

tic
bw = activecontour(I,mask);
toc
figure
imshow(bw)
title('Segmented Image')

pause
    
    [valoriColoana,indexColoana] = sort(sum(rezultat,1),'descend');
    [valoriLinie,indexLinie] = sort(sum(rezultat,2),'descend');
    
    valoriColoana(1:2)
    valoriLinie(1:2)
    
    size(imagine_interes)
    indexColoana(1),indexColoana(2)
    indexLinie(1),indexLinie(2)
    
    pozitie_masina = uint8(imagine(min(indexLinie(1),indexLinie(2)):max(indexLinie(1),indexLinie(2)),...
                             min(indexColoana(1),indexColoana(2)):max(indexColoana(1),indexColoana(2)),:));
end

