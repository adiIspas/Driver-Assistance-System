image = rgb2gray(imread('images/road.jpg'));

imagineTest = (image(412:412+152,215:215+499));
imagineIPM = obtineIPM(imagineTest);

imshow(imagineIPM);