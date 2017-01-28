% Start program
tic

imagineTest = imread('ipm_image.JPG');


imagineIPM = obtineIPM(imagineTest);

imagineTest = rgb2gray(imagineTest);
img = filtrareIPM(imagineTest);

imshowpair(imagineTest,img,'montage')
toc
% Sfarsit program