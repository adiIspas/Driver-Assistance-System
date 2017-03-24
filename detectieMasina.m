clc
configuratie_detectie_masina
img = imread('car_1.jpg');

imshow(img),impixelinfo;

portiune = img(150:250,100:400,:);
mediaCulorii = mean(mean(portiune(:,200:300,:)));
R = mediaCulorii(:,:,1);
G = mediaCulorii(:,:,2);
B = mediaCulorii(:,:,3);

R
G
B

rezultat = ones(size(img))*255;
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

rezultat = uint8(rezultat);
rezultat = obtineIPM((img),configuratie);

imshowpair(rezultat,img,'montage'),impixelinfo