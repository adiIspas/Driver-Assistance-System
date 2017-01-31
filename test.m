% Start program
clear; clc;
tic

imagineTest = imread('ipm_image.JPG');
if size(imagineTest,3) > 1
    imagineTest = rgb2gray(imagineTest);
end

% imagineIPM = obtineIPM(imagineTest);

imagineIPM = imagineTest;
imagineFiltrata = filtrareIPM(imagineIPM);
% imshowpair(imagineTest,imagineFiltrata,'montage');

[liniiImagine, incadrare] = detectieLinii(imagineFiltrata);

RANSAC(imagineFiltrata, liniiImagine, incadrare)

for idx = 1:size(liniiImagine,2)
    imagineFiltrata(:,liniiImagine(idx)) = 255;
end

figure
imshow(imagineTest);
figure
imshow(imagineFiltrata);
toc
% Sfarsit program