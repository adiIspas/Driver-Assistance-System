function [ descriptori ] = obtineDescriptori( parametri )
%obtineDescriptori 

    imgFiles = dir(fullfile(parametri.numeDirector, ['*.' parametri.extensie]));
    numarImagini = length(imgFiles);
    
    descriptori = zeros(numarImagini,(parametri.dimensiuneFereastra/parametri.dimensiuneCelulaHOG)^2*parametri.dimensiuneDescriptorCelula);
    
    for idx = 1:numarImagini
        disp(['Procesam exemplul numarul ' num2str(idx) ' din directorul ' parametri.numeDirector]);
        
        img = imread([parametri.numeDirector '/' imgFiles(idx).name]);
        if size(img,3) > 1
            img = rgb2gray(img);
        end   

        descriptorHOG = vl_hog(single(img),parametri.dimensiuneCelulaHOG);
        descriptorHOG = descriptorHOG(:)';
        descriptori(idx,:) = descriptorHOG; 
    end
end

