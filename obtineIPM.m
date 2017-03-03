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
    theta = unghiInclinare;
    fi  = unghiGiratie;
    fu    = lungimeFocalaX;
    fv    = lungimeFocalaY;
    s1    = sin(theta);
    s2    = sin(fi);
    c1    = cos(theta);
    c2    = cos(fi);
    cu    = centruOpticX;
    cv    = centruOpticY;
    h     = inaltimeCamera;
    
    groundPlane = zeros(size(imagine,1) * size(imagine,2), 4);
    imagePlane = zeros(size(imagine,1) * size(imagine,2), 4);

    % Definim matricea pentru transformarea omogena si inversa acesteia
    
    transformareOmogena = h * ...
        [(-1/fu)*c2, (1/fv)*s1*s2,   (1/fu)*cu*c2 - (1/fv)*cv*s1*s2 - c1*s2,  0;
         (1/fu)*s2,  (1/fv)*s1*c1,   (-1/fu)*cu*s2 - (1/fv)*cv*s1*c2 - c1*c2, 0;                                    
         0,          (1/fv)*c1,      (-1/fv)*cv*c1 + s1,                      0;
         0,          (-1/(h*fv))*c1, (1/(h*fv))*cv*c1 - (1/h)*s1,             0
        ];

    inversaTransformareOmogena = (-1/h) * ...
                                 [fu*c2 + cu*c1*s2, cu*c1*c2-s2*fu,   -cu*s1,       0;
                                  s2*(cv*c1-fv*s1), c2*(cv*c1-fv*s1), -fv*c1-cv*s1, 0;
                                  c1*s2,            c1*s2,            -s1,          0;
                                  c1*s2,            c1*s2,            -s1,          0;];

    % Aplicam matrice de transformare omogena intregii imagini
    % size(imagine)
    % size(imagine,1)
    % size(imagine,2)
    % imshow(imagine)
    % pause
%     x = transformareOmogena * [1; 1; 1; 1]
%     y = inversaTransformareOmogena * [1; 1; -h; 1]
%     indice = 0;
%     for idy = 1:size(imagine,1)
%         for idx = 1:size(imagine,2)
%             indice = indice + 1;
%             groundPlane(indice,:) = round(transformareOmogena * [idx idy 1 1]');
%         end
%     end
    
%     indice = 0;
%     for idy = 1:size(imagine,1)
%         for idx = 1:size(imagine,2)
%             indice = indice + 1;
%             imagePlane(indice,:) = inversaTransformareOmogena * groundPlane(indice,:)';
%         end
%     end
    
%         x = max(groundPlane);
%     
%     IPM = zeros(x(1),x(3));
%     indice = 1;
%     for idy = 1:size(imagine,1)
%         for idx = 1:size(imagine,2)
%             
%             if groundPlane(indice,1) > 0 && groundPlane(indice,3) > 0
%                 
%                 IPM(groundPlane(indice,1),groundPlane(indice,3)) = imagine(idy,idx);
%                 indice = indice + 1;
%             end
%         end
%     end
        
%       round(groundPlane(:,:))
%     save('X.mat','groundPlane');
%     groundPlane(:,:)
%     imagineIPM = uint8(IPM);


%--------------

% alpha1 = 14;
% beta1 = 0;
% gamma1 = 0;
% f1 = 309;
% dist1 = 2000;
% PI = pi;
% alpha =(double(alpha1 -90)) * PI/180;
% beta =(double(beta1 -90)) * PI/180;
% gamma =(double(gamma1) -90) * PI/180;
% focalLength = double(f1);
% dist = double(dist1);
% 
% w = double(size(imagine,2));
% h = double(size(imagine,1));
% 
% % // Projecion matrix 2D -> 3D
% 		A1 = [
% 			1, 0, -w/2
% 			0, 1, -h/2
% 			0, 0, 0
% 			0, 0, 1 ];
% 
% 
% % 		// Rotation matrices Rx, Ry, Rz
% 
% 		RX = [
% 			1, 0, 0, 0
% 			0, cos(alpha), -sin(alpha), 0
% 			0, sin(alpha), cos(alpha), 0
% 			0, 0, 0, 1 ];
% 
% 		RY = [
% 			cos(beta), 0, -sin(beta), 0
% 			0, 1, 0, 0
% 			sin(beta), 0, cos(beta), 0
% 			0, 0, 0, 1	];
% 
% 		RZ = [
% 			cos(gamma), -sin(gamma), 0, 0
% 			sin(gamma), cos(gamma), 0, 0
% 			0, 0, 1, 0
% 			0, 0, 0, 1	];
%         
% %         // R - rotation matrix
% 		R = double(RX * RY * RZ);
% 
% % 		// T - translation matrix
% 		T = double([
% 			1, 0, 0, 0
% 			0, 1, 0, 0
% 			0, 0, 1, dist
% 			0, 0, 0, 1]);
% 
% % 		// K - intrinsic matrix
% 		K = double([
% 			focalLength, 0, w/2, 0
% 			0, focalLength, h/2, 0
% 			0, 0, 1, 0
% 			]);
% 
% 
% 		transformationMat = double(K * (T * (R * A1)))
%         tform = affine2d(transformationMat);
%  
%  J = imwarp(imagine,tform);
% figure
% imshow(J)

%--------------

% alpha = 14;
% beta = 0;
% gamma = 0;
% 
% RAlpha = [1 0 0 0;
%           0 cos(alpha) sin(alpha) 0;
%           0 -sin(alpha) cos(alpha) 0;
%           0 0 0 1];
% RBeta = [cos(beta) 0 -sin(beta) 0;
%          0 1 0 0;
%          sin(beta) 0 cos(beta) 0;
%          0 0 0 1];
%      
% RGamma = [cos(gamma) sin(gamma) 0 0;
%           -sin(gamma) cos(gamma) 0 0;
%           0 0 1 0;
%           0 0 0 1];
%           
% r = RAlpha * RBeta * RGamma;
% 
% x1 = 1;
% y1 = 1;
% for x1 = 1:size(imagine,2)
%     for y1 = 1:size(imagine,1)
%         '--------------'
%         x2 = round((r(1,1) * x1 + r(1,2) * y1 + r(1,3))/(r(3,1) * x1 + r(3,2) * y1 + r(3,3)))
%         y2 = round((r(2,1) * x1 + r(2,2) * y1 + r(2,3))/(r(3,1) * x1 + r(3,2) * y1 + r(3,3)))
%         '--------------'
%     end
% end
%---------------------------

% alpha = 14;
% f = 326;
% ku = 84;
% kv = 281;
% s = 1;
% uo = 1;
% vo = 1;
% h = 2179.8;
% R = [1 0 0 0;
%     0 cos(alpha)  -sin(alpha) 0;
%     0 sin(alpha) cos(alpha) 0;
%     0 0 0 1];
% 
% T = [1 0 0 0;
%      0 1 0 0;
%      0 0 1 -h/sin(alpha);
%      0 0 0 1];
% K = [f*ku s uo 0;
%     0 f*kv vo 0;
%     0 0 1 0];
% 
% p = K * T * R;
% 
% x = [p(1,1) p(1,3) p(1,4);
%      p(2,1) p(2,3) p(2,4);
%      p(3,1) p(3,3) p(3,4)];
 
%-----------------------------
% u = x;
% v = y;
% points = zeros(size(imagine,1)*size(imagine,2),4);
% indice = 0;
% for y1 = 1:size(imagine,1)
%     for x1 = 1:size(imagine,2)
%         x2 = round((r(1,1) * x1 + r(1,2) * y1 + r(1,3))/(r(3,1) * x1 + r(3,2) * y1 + r(3,3)));
%         y2 = round((r(2,1) * x1 + r(2,2) * y1 + r(2,3))/(r(3,1) * x1 + r(3,2) * y1 + r(3,3)));
%         
%         if x2 > 0 && y2 > 0
%             indice = indice + 1;
%             points(indice,:) = [y2,x2,y1,x1];
%         end
%     end
% end
% 
% % finalPoints = zeros(indice,2);
% finalPoints = points(1:indice,:);
% 
% x_max = max(finalPoints(:,1))
% y_max = max(finalPoints(:,2))
% 
% imagineFinala = zeros(y_max,x_max);
% 
% for idx = 1:size(finalPoints,1)
%     imagineFinala(finalPoints(idx,1),finalPoints(idx,2)) = imagine(finalPoints(idx,3),finalPoints(idx,4));
% end
%-----------------------------

% fx = lungimeFocalaX;
% fy = lungimeFocalaY;
% cx = centruOpticX;
% cy = centruOpticY;
% 
% C = [fx 0  cx;
%      0  fy cy;
%      0  0  1];
% 
% h = 217.9;
% theta = 35;
% fi = 0;
% 
% H = C * [ cos(fi)  sin(fi)*sin(theta)   h*sin(fi)*sin(theta);
%          -sin(fi)  cos(fi)*sin(theta)  -h*cos(fi)*sin(theta);
%               0      cos(theta)             h*cos(theta)];

% R1 = [cos(fi) sin(theta) 0;
%      -sin(fi) cos(theta) 0;
%       0        0         1];
%   
% R2 = [1 0 0;
%       0 cos(theta) sin(theta);
%       0 -sin(theta) cos(theta)];
  
%  R = R1 * R2;
% H = rotx(30);
% A = transpose(H);
% t = projective2d(A);
% imOut = imwarp(imagine,t);
% % 
% A = transpose(H);
% t = projective2d(A);
% imOutFinal = imwarp(imOut,t);

% x = 150;
% y = 250;
% theta = 14;
% alpha = 1;
% n = 850*120;
% u = (atan(y/x) - theta - alpha)/((2*alpha)*(n - 1)^(-1))
% 
% imagineIPM = uint8(imOut);
% % imshow(imagineIPM)
% imshowpair(imagine,imagineIPM,'montage');

%--------------

alpha1 = 14;
beta1 = 0;
gamma1 = 0;
f1 = 309;
dist1 = 2000;
PI = pi;
alpha =(double(alpha1 -90)) * PI/180;
beta =(double(beta1 -90)) * PI/180;
gamma =(double(gamma1) -90) * PI/180;
focalLength = double(f1);
dist = double(dist1);

w = double(size(imagine,2));
h = double(size(imagine,1));

% // Projecion matrix 2D -> 3D
		A1 = [
			1, 0, -w/2
			0, 1, -h/2
			0, 0, 0
			0, 0, 1 ];


% 		// Rotation matrices Rx, Ry, Rz

		RX = [
			1, 0, 0, 0
			0, cos(alpha), -sin(alpha), 0
			0, sin(alpha), cos(alpha), 0
			0, 0, 0, 1 ];

		RY = [
			cos(beta), 0, -sin(beta), 0
			0, 1, 0, 0
			sin(beta), 0, cos(beta), 0
			0, 0, 0, 1	];

		RZ = [
			cos(gamma), -sin(gamma), 0, 0
			sin(gamma), cos(gamma), 0, 0
			0, 0, 1, 0
			0, 0, 0, 1	];
        
%         // R - rotation matrix
		R = double(RX * RY * RZ);

% 		// T - translation matrix
		T = double([
			1, 0, 0, 0
			0, 1, 0, 0
			0, 0, 1, dist
			0, 0, 0, 1]);

% 		// K - intrinsic matrix
		K = double([
			focalLength, 0, w/2, 0
			0, focalLength, h/2, 0
			0, 0, 1, 0
			]);


		transformationMat = double(K * (T * (R * A1)));
        x= zeros(3,3);
        
        imagineTest = imread('images/road_4.JPG');
if size(imagineTest,3) > 1
    imagineTest = rgb2gray(imagineTest);
end
        imagineRezultat = cv.warpPerspective(imagineTest,x);
        
        imshow(imagineRezultat);
       
 
%  J = imwarp(imagine,tform);
% figure
% imshow(J)

end

