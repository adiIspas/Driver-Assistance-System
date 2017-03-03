% Start program
clear; clc;
close all;
tic

numarLinii = 3;
imagineTest = imread('images/x.png');
if size(imagineTest,3) > 1
    imagineTest = rgb2gray(imagineTest);
end

imagineIPM = obtineIPM(imagineTest);
imshow(imagineIPM);
imagineFiltrata = filtrareIPM(imagineIPM);

[liniiImagine, incadrare] = detectieLinii(imagineFiltrata);
[puncteInteres, scorLinie] = RANSAC(imagineFiltrata, incadrare);

imagineRezultat = uint8(zeros(size(imagineTest,1),size(imagineTest,2),1));
imagineRezultat(:,:,1) = imagineFiltrata(:,:);

pos = zeros(0,2);
for u = 1:numarLinii
    puncte = sortrows(puncteInteres(u*4-4+1:u*4,:),2);
    for idx = 1:4
        i = round(puncte(idx,1));
        j = round(puncte(idx,2));
        imagineRezultat(j,i,:) = 255;
        pos = [pos; i j];
    end
end

figure
imageMarked = insertMarker(imagineRezultat,pos,'o');
imshow(imageMarked);
for u = 1:numarLinii
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