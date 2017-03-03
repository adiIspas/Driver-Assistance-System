tic
clc
img = imread('images/road_4.jpg');

% srcPoints = {[0,40],[300,40],[0,400],[300,400]};
% dstPoints = {[0,0],[300,0],[100,400],[200,400]};

srcPoints = {[0,40],[800,40],[0,200],[800,200]};
dstPoints = {[0,0],[800,0],[300,200],[500,200]};

M = cv.getPerspectiveTransform(srcPoints,dstPoints);
H = cv.findHomography(srcPoints, dstPoints);

result = cv.warpPerspective(img,M,'DSize',[size(img,2) size(img,1)]);
      
imshowpair(img,result,'montage');
toc