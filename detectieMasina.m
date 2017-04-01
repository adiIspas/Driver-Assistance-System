clc
configuratie_detectie_masina
img = imread('imagine_111.jpg');

imshow(img),impixelinfo;

portiune = img(116:116+32,234:234+111,:);
mediaCulorii = mean(mean(portiune(:,:,:)));
R = mediaCulorii(:,:,1);
G = mediaCulorii(:,:,2);
B = mediaCulorii(:,:,3);

R
G
B

rezultat = ones(size(img))*255;
tic
for i = 1:size(img,1)
    for j = 1:size(img,2)
        if img(i,j,1) >= R - 35 && img(i,j,1) <= R + 35
            rezultat(i,j,1) = 0;
        end
        if img(i,j,2) >= G - 35 && img(i,j,2) <= G + 35
            rezultat(i,j,2) = 0;
        end
        if img(i,j,3) >= B - 35 && img(i,j,3) <= B + 35
            rezultat(i,j,3) = 0;
        end
    end
end
toc
rezultat = uint8(rezultat);
% rezultat = obtineIPM((rezultat),configuratie);

imshowpair(rezultat,img,'montage'),impixelinfo