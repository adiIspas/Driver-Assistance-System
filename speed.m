% clear
% htm=vision.TemplateMatcher;
% hmi = vision.MarkerInserter('Size', 10, ...
% 'Fill', true, 'FillColor', 'White', 'Opacity', 0.75); 
% 
% I1 = imread('img_0.jpg');
% I2 = imread('img_1.jpg');
% 
% % Input image
% I1 = rgb2gray(I1); 
% I2 = rgb2gray(I2);
% T = I1(250:250,1:end); 
% 
% tic
% % Find the [x y] coordinates
% Loc=step(htm,I2,T);  
% toc
% 
% % Mark the location on the image using white disc
% J = step(hmi, I2, Loc);
% 
% imshow(T); title('Template');
% figure; imshow(J); title('Marked target');

% % % --- Second ---- % % % 

%% Estimate Motion Using BlockMatcher
%
clear,clc
%% 
% Read and convert RGB image to grayscale.
img1 = im2double(imresize(rgb2gray(imread('img_0.jpg')),0.4));
img2 = im2double(imresize(rgb2gray(imread('img_1.jpg')),0.4));
%% 
% Create objects.
htran = vision.GeometricTranslator('Offset',[5 5],...
        'OutputSize','Same as input image');
hbm = vision.BlockMatcher('ReferenceFrameSource',...
        'Input port','BlockSize',[35 35]);
hbm.OutputValue = 'Horizontal and vertical components in complex form';
halphablend = vision.AlphaBlender;

%% 
% Compute motion for the two images.
tic
motion = step(hbm,img1,img2);
toc
%% 
% Blend two images.
img12 = step(halphablend,img2,img1);
%% 
% Use quiver plot to show the direction of motion on the images.   
[X Y] = meshgrid(1:35:size(img1,2),1:35:size(img1,1));         
imshow(img12); 
hold on;
quiver(X(:),Y(:),real(motion(:)),imag(motion(:)),0); 
hold off; 