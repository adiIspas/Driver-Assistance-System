fprintf('Incarcam imaginile din director \n');

clear, clc, close all;

numeFolderImagini = '../videos_paper/cordova1';
% numeFolderImagini = '../washington2';
% numeFolderImagini = 'road';
numeDirector = [pwd '\' numeFolderImagini '\'];
tipImagine = 'png';

% The ground truth labels
truthFiles = {
  'cordova1/labels.ccvl'
  };

filelist = dir([numeDirector '*.' tipImagine]);

%load the ground truth
truths = ccvLabel('read', truthFiles{1});

for idxImg = 1:length(filelist)
    clc
    
    imgName = filelist(idxImg).name;
    image = imread([numeDirector imgName]);
    
    if(size(truths.frames(idxImg).labels,1) > 0)
        imagineTrasata = image;
        for idy = 1:size(truths.frames(idxImg).labels,2)
            punctePlan = truths.frames(idxImg).labels(idy).points;

            for u = 1:size(punctePlan,1)/4
                puncte = sortrows(punctePlan(u*4-4+1:u*4,:),2);
                
                for idx = 2:size(puncte,1)
                    i = round(puncte(idx-1,1));
                    j = round(puncte(idx-1,2));
                    ii = round(puncte(idx,1));
                    jj = round(puncte(idx,2));
                    
                    if truths.frames(idxImg).labels(idy).subtype == 'dy'
                        imagineTrasata = cv.line(imagineTrasata, ...
                            [i j],[ii jj], ...
                            'Thickness',5,'Color',[0 255 0]);
                    elseif truths.frames(idxImg).labels(idy).subtype == 'sw'
                        imagineTrasata = cv.line(imagineTrasata, ...
                            [i j],[ii jj], ...
                            'Thickness',5,'Color',[255 0 0]);
                    elseif truths.frames(idxImg).labels(idy).subtype == 'bw'
                        imagineTrasata = cv.line(imagineTrasata, ...
                            [i j],[ii jj], ...
                            'Thickness',5,'Color',[0 0 255]);
                    end
                    imagineTrasata = cv.putText(imagineTrasata, num2str(idy), [i j]);
                end
            end
        end
    end
    
    imshow(imagineTrasata)
end