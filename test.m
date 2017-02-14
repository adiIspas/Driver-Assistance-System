% Start program
% de utilizat functia quantile
clear; clc;
close all;
tic

imagineTest = imread('images/ipm_image.JPG');
if size(imagineTest,3) > 1
    imagineTest = rgb2gray(imagineTest);
end

% imagineIPM = obtineIPM(imagineTest);

imagineIPM = imagineTest;
imagineFiltrata = filtrareIPM(imagineIPM);
% imshowpair(imagineTest,imagineFiltrata,'montage');

[liniiImagine, incadrare] = detectieLinii(imagineFiltrata);
puncteInteres = RANSAC(imagineFiltrata, incadrare);

imagineRezultat = uint8(zeros(size(imagineTest,1),size(imagineTest,2),1));
imagineRezultat(:,:,1) = imagineFiltrata(:,:);

pos = zeros(0,2);
for u = 1:3
    puncte = sortrows(puncteInteres(u*4-4+1:u*4,:),2);
    for idx = 1:4
        i = round(puncte(idx,1));
        j = round(puncte(idx,2));
        imagineRezultat(j,i,:) = 255;
        pos = [pos; i j];
    end
end

figure
imageMark = insertMarker(imagineRezultat,pos,'o');
imshow(imageMark);
for u = 1:3
    puncte = sortrows(puncteInteres(u*4-4+1:u*4,:),2);

    for idx = 2:4
        i = round(puncte(idx-1,1));
        j = round(puncte(idx-1,2));
        ii = round(puncte(idx,1));
        jj = round(puncte(idx,2));
        line([i ii],[j jj]);
    end
end

toc
% Sfarsit program