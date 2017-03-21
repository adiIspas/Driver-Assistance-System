function [ imagineIPM, matriceInversa ] = obtineIPMRGB(imagine)
    % IN LUCRU - NU ESTE FINALIZATA
    % obtineIPM Pentru o imagine data se intoarce imaginea IPM asociata
    %   Detaliile despre implementare pot fi gasite in paper-ul 
    % Real time Detection of Lane Markers in Urban Streets, Mohamed Aly

    imagineIPM = zeros(size(imagine));
    
%     procentYMin = 20;
%     pixeliXPotrivire = 65;

    procentYMin = 50;
    pixeliXPotrivire = 65;
    
    xMax = size(imagine,2);
    yMax = size(imagine,1);
    yMin = size(imagine,1) * procentYMin/100;
    perfectX1 = round(size(imagine,2)/2 - pixeliXPotrivire);
    perfectX2 = round(size(imagine,2)/2 + pixeliXPotrivire);

    % Punctele sunt date sub forma [x,y]
    srcPoints = {[0,yMin],[xMax,yMin],[0,yMax],[xMax,yMax]};
    dstPoints = {[0,0],[xMax,0],[perfectX1,yMax],[perfectX2,yMax]};

    M = cv.getPerspectiveTransform(srcPoints,dstPoints);
    matriceInversa = inv(M);

    imagineIPM(:,:,1) = cv.warpPerspective(imagine(:,:,1),M,'DSize',[size(imagine,2) size(imagine,1)]);
    imagineIPM(:,:,2) = cv.warpPerspective(imagine(:,:,2),M,'DSize',[size(imagine,2) size(imagine,1)]);
    imagineIPM(:,:,3) = cv.warpPerspective(imagine(:,:,3),M,'DSize',[size(imagine,2) size(imagine,1)]);
    
    imagineIPM = uint8(imagineIPM);
end

