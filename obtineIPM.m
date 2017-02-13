function [ imagineIPM ] = obtineIPM(imagine)
    % IN LUCRU - NU ESTE FINALIZATA
    % obtineIPM Pentru o imagine data se intoarce imaginea IPM asociata
    %   Detaliile despre implementare pot fi gasite in paper-ul 
    % Real time Detection of Lane Markers in Urban Streets, Mohamed Aly

    % Transformam imaginea in alb-negru
    if size(imagine,3) > 1
        imagine = double(rgb2gray(imagine));
    end;

    % Initializam parametrii camerei
    initializareParametriCamera;
    imagineIPM = zeros(size(imagine));

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

    % Definim matricea pentru transformarea omogena si inversa acesteia
    transformareOmogena = h * ...
        [(-1/fu)*c2, (1/fv)*s1*s2,   (1/fu)*cu*c2 - (1/fv)*cv*s1*s2 - c1*s2,  0;
         (1/fu)*s2,  (1/fv)*s1*c1,   (-1/fu)*cu*s2 - (1/fv)*cv*s1*c2 - c1*c2, 0;                                    
         0,          (1/fv)*c1,      (-1/fv)*cv*c1 + s1,                      0;
         0,          (-1/(h*fv))*c1, (1/(h*fv))*cv*c1 - (1/h)*s1,             0
        ];

    inversaTransformareOmogena = [fu*c2 + cu*c1*s2, cu*c1*c2-s2*fu,   -cu*s1,       0;
                                  s2*(cv*c1-fv*s1), c2*(cv*c1-fv*s1), -fv*c1-cv*s1, 0;
                                  c1*s2,            c1*s2,            -s1,          0;
                                  c1*s2,            c1*s2,            -s1,          0;];

    % Aplicam matrice de transformare omogena intregii imagini
    % size(imagine)
    % size(imagine,1)
    % size(imagine,2)
    % imshow(imagine)
    % pause
    x = transformareOmogena * [1; 1; 1; 1]
    y = inversaTransformareOmogena * [1; 1; -h; 1]
    % for idx = 1:size(imagine,2)
    %     for idy = 1:size(imagine,1)
    %         [idx idy 1 1]'
    %         transformareOmogena * [idx idy 1 1]'
    %     end
    % end

    imagineIPM = uint8(imagineIPM);
end

