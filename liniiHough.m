function [ imageO ] = liniiHough( imageO )

imageT = rgb2gray(imageO);
image = cv.Canny(imageT, 150);

lines = cv.HoughLinesP(image);
% % imshow(image)
% count = 0;
% pragDistantaLinii = 20;
% pragCentru = 60;
% centruImagine = 250;
% finalLines = {};
% topAngle = 90;
% bottomAngle = 270;
% epsilon = 20;
% 
% for i = 1:length(lines)
%     
%     x1 = lines{i}(1,1);
%     x2 = lines{i}(1,3);
%     y1 = lines{i}(1,2);
%     y2 = lines{i}(1,4);
%     dx = x1 - x2;
%     dy = y1 - y2;
%     angle = rad2deg(atan2(y2 - y1,x2 - x1));
%     
%     if angle < 0
%         angle = angle + 360;
%     end
% 
%     if abs(centruImagine - lines{i}(1,1)) <= pragCentru ...
% %             && ( ...
% %         (angle >= topAngle - epsilon && angle <= topAngle + epsilon) || ...
% %         (angle >= bottomAngle - epsilon && angle <= bottomAngle + epsilon) ...
% %         )
%         finalLines = [finalLines lines{i}];
%         break
%     end
% end
% 
% for i = 2:length(lines)
%     
%     x1 = lines{i}(1,1);
%     x2 = lines{i}(1,3);
%     y1 = lines{i}(1,2);
%     y2 = lines{i}(1,4);
%     dx = x1 - x2;
%     dy = y1 - y2;
%     angle = rad2deg(atan2(y2 - y1,x2 - x1));
%     
%     if angle < 0
%         angle = angle + 360;
%     end
%     
%     if abs(centruImagine - lines{i}(1,1)) <= pragCentru ...
% %             && ( ...
% %         (angle >= topAngle - epsilon && angle <= topAngle + epsilon) || ...
% %         (angle >= bottomAngle - epsilon && angle <= bottomAngle + epsilon) ...
% %         )
%         found = 1;
%         for j = 1:length(finalLines)
%             if norm(lines{i} - finalLines{j}) <= pragDistantaLinii
%                     found = 0;
%                     break
%             end
%         end
%         
%         if found == 1
%             finalLines = [finalLines lines{i}];
%         end
%     end
% end
% 
% for i = 1:length(finalLines)
%     imageO = cv.line(imageO,[finalLines{i}(1,1),finalLines{i}(1,2)], ...
%                      [finalLines{i}(1,3),finalLines{i}(1,4)],...
%                      'Thickness',5,'Color',[0 255 0]);
%                  
%                  
%     x1 = finalLines{i}(1,1);
%     x2 = finalLines{i}(1,3);
%     y1 = finalLines{i}(1,2);
%     y2 = finalLines{i}(1,4);
%     dx = x1 - x2;
%     dy = y1 - y2;
%     angle = rad2deg(atan2(y2 - y1,x2 - x1));
%     
%     if angle < 0
%         angle = angle + 360;
%     end
%     
%     imageO = cv.putText(imageO, num2str(angle), [(finalLines{i}(1,1) + finalLines{i}(1,3))/2 ...
%         (finalLines{i}(1,2) + finalLines{i}(1,4))/2]);
% %     imshow(imageO)
% %     pause
% end
% 
% size(finalLines)
% imshow(imageO)
% % impixelinfo
% % pause


for i = 1:length(lines)

    imageO = cv.line(imageO,[lines{i}(1,1),lines{i}(1,2)], ...
                     [lines{i}(1,3),lines{i}(1,4)],...
                     'Thickness',5,'Color',[0 255 0]);
end

imshow(imageO),impixelinfo

end

