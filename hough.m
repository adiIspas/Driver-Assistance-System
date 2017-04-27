
imageO = imread('image.png');
% tic
imageT = rgb2gray(imageO);
image = cv.Canny(imageT, 200);

lines = cv.HoughLinesP(image,'Threshold',80,'MinLineLength',100,'MaxLineGap',50);

count = 0;
for i = 1:length(lines)
    
    if abs(711 - lines{i}(1,1)) <= 180
    imageO = cv.line(imageO,[lines{i}(1,1),lines{i}(1,2)],[lines{i}(1,3),lines{i}(1,4)],...
        'Thickness',5,'Color',[0 i*10 0]);
    count = count + 1;
    end
%     imshow(imageT)
%     pause
end
% toc
count
% imshowpair(image,imageO,'montage')
imshow(imageO),impixelinfo
% 
% bool intersection(Point2f o1, Point2f p1, Point2f o2, Point2f p2,
%                       Point2f &r)
% {
%     Point2f x = o2 - o1;
%     Point2f d1 = p1 - o1;
%     Point2f d2 = p2 - o2;
% 
%     float cross = d1.x*d2.y - d1.y*d2.x;
%     if (abs(cross) < /*EPS*/1e-8)
%         return false;
% 
%     double t1 = (x.x * d2.y - x.y * d2.x)/cross;
%     r = o1 + d1 * t1;
%     return true;
% }