imageO = imread('image2.jpg');
% tic
imageT = rgb2gray(imageO);
image = cv.Canny(imageT, 200);

lines = cv.HoughLinesP(image,'Theta',0.1,'Threshold',80,'MinLineLength',100,'MaxLineGap',50);

count = 0;
prag = 200;
prag1 = 200;
finalLines = {};

for i = 1:length(lines)
    if abs(711 - lines{i}(1,1)) <= 180
        finalLines = [finalLines lines{i}];
        break
    end
end

for i = 2:length(lines)
    if abs(711 - lines{i}(1,1)) <= prag1
        found = 1;
        for j = 1:length(finalLines)
            if norm(lines{i} - finalLines{j}) <= prag
                    found = 0;
                    break
            end
        end
        
        if found == 1
            finalLines = [finalLines lines{i}];
        end
    end
end

for i = 1:length(finalLines)
    imageO = cv.line(imageO,[finalLines{i}(1,1),finalLines{i}(1,2)], ...
                     [finalLines{i}(1,3),finalLines{i}(1,4)],...
                     'Thickness',5,'Color',[0 255 0]);
end

imshow(imageO),impixelinfo
