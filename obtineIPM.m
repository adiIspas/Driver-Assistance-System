function [ imagineIPM ] = obtineIPM(imagine)
%obtineIPM Pentru o imagine data se intoarce imaginea IPM asociata
%   Detaliile despre implementare pot fi gasite in paper-ul 
% Real time Detection of Lane Markers in Urban Streets, Mohamed Aly

% Transformam imaginea in alb-negru
if size(imagine,3) > 1
    imagine = double(rgb2gray(imagine));
end;

% Initializam parametrii camerei
initializareParametriCamera;

% Setam valorile dn parametri in variabile scurte
alpha = unghiInclinare;
beta  = unghiGiratie;
fu    = lungimeFocalaX;
fv    = lungimeFocalaY;
s1    = sin(alpha);
s2    = sin(beta);
c1    = cos(alpha);
c2    = cos(beta);
cu    = centruOpticX;
cv    = centruOpticY;
h     = inaltimeCamera;

% Definim matricea pentru transformarea omogena
transformareOmogena = h * ...
    [(-1/fu)*c2, (1/fv)*s1*s2,   (1/fu)*cu*c2 - (1/fv)*cv*s1*s2 - c1*s2,  0;
     (1/fu)*s2,  (1/fv)*s1*c1,   (-1/fu)*cu*s2 - (1/fv)*cv*s1*c2 - c1*c2, 0;                                    
     0,          (1/fv)*c1,      (-1/fv)*cv*c1 + s1,                      0;
     0,          (-1/(h*fv))*c1, (1/(h*fv))*cv*c1 - (1/h)*s1,             0
    ];

% Aplicam matrice de transformare omogena intregii imagini

tform = affine2d([1 0 0; .5 1 0; 0 0 1]);
imagineIPM = imwarp(imagine,tform);
imagineIPM = uint8(imagineIPM);
end

