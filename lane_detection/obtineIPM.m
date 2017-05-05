function [ imagineIPM, matriceInversa, M ] = obtineIPM(imagine, configuratie)
% obtineIPM Pentru o imagine data se intoarce imaginea IPM asociata
%
%   imagine        = imaginea pentru care se doreste obtinerea IPM-ului
%   configuratie   = configuratie data de pozitia camerei
%
%   imagineIPM     = imaginea IPM
%   matriceInversa = matricea inversa cu ajutorul careia s-a obtinut IPM-ul

    procentYMin = configuratie.procentYMin;
    pixeliXPotrivire = configuratie.pixeliXPotrivire;

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
    
    if size(imagine,3) == 1
        imagineIPM = cv.warpPerspective(imagine,M,'DSize',[size(imagine,2) size(imagine,1)]);
        
        imagineIPM = uint8(imagineIPM);
    else
        imagineIPM(:,:,1) = cv.warpPerspective(imagine(:,:,1),M,'DSize',[size(imagine,2) size(imagine,1)]);
        imagineIPM(:,:,2) = cv.warpPerspective(imagine(:,:,2),M,'DSize',[size(imagine,2) size(imagine,1)]);
        imagineIPM(:,:,3) = cv.warpPerspective(imagine(:,:,3),M,'DSize',[size(imagine,2) size(imagine,1)]);

        imagineIPM = uint8(imagineIPM);
    end
end

