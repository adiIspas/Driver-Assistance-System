clc
configuratie_detectie_masina
img = rgb2gray(imread('img_car_2.png'));

final = uint8(zeros(size(img)));

tic

BW1 = edge(img,'sobel','vertical',0.2);
BW2 = edge(img,'sobel','horizontal',0.2);

result = BW1 + BW2;

value1 = sum(result,1);
value2 = sum(result,2);

[~, col] = find(value1);
[row, ~] = find(value2);

toc

r = img(row(1):row(end),col(1):col(end));
imwrite(r,'img.png');
imshow(r),impixelinfo;

% imshowpair(BW1,BW2,'montage'),impixelinfo

% portiune = img(116:116+32,234:234+111,:);
% mediaCulorii = mean(mean(portiune(:,:,:)));
% R = mediaCulorii(:,:,1);
% G = mediaCulorii(:,:,2);
% B = mediaCulorii(:,:,3);
% 
% R
% G
% B
% 
% rezultat = ones(size(img))*255;
% tic
% for i = 1:size(img,1)
%     for j = 1:size(img,2)
%         if img(i,j,1) >= R - 35 && img(i,j,1) <= R + 35
%             rezultat(i,j,1) = 0;
%         end
%         if img(i,j,2) >= G - 35 && img(i,j,2) <= G + 35
%             rezultat(i,j,2) = 0;
%         end
%         if img(i,j,3) >= B - 35 && img(i,j,3) <= B + 35
%             rezultat(i,j,3) = 0;
%         end
%     end
% end
% toc
% rezultat = uint8(rezultat);
% % rezultat = obtineIPM((rezultat),configuratie);
% 
% imshowpair(rezultat,img,'montage'),impixelinfo