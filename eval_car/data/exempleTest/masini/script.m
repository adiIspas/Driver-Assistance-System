clear
clc
numeDirector = [pwd '/'];
tipImagine = 'jpg';

filelist = dir([numeDirector '*.' tipImagine]);

detection = [];
n = 1151
for idxImg = n:n
        fprintf(['Imaginea ' num2str(idxImg) ' din ' num2str(length(filelist)) ' ... \n']);
        imgName = filelist(idxImg).name;
        image = imread([numeDirector imgName]);
        
        imshow(image),impixelinfo
        rect = getrect;
        
        current = [imgName ' ' num2str(rect(1)) ' ' num2str(rect(2)) ' ' num2str(rect(1) + rect(3)) ' ' num2str(rect(2) + rect(4))];
        detection = [detection; string(current)];
end

detection