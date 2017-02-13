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
puncte = RANSAC(imagineFiltrata, incadrare)

% for idx = 1:size(liniiImagine,2)
%     imagineFiltrata(:,liniiImagine(idx)) = 255;
% end

for idx = 1:4
    i = round(puncte(idx,1));
    j = round(puncte(idx,2));
    imagineFiltrata(j,i) = 255;
end

figure
imshow(imagineTest);
figure
imshow(imagineFiltrata);
toc
% Sfarsit program