img = rgb2gray(imread('images/road_test_2.jpg'));

imgIPM = obtineIPM(img);

imshow(imgIPM);