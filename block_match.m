% EXAMPLE: Estimate motion using BlockMatcher
        img1 = im2double(rgb2gray(imread('onion.png')));
        hbm = vision.BlockMatcher( ...
            'ReferenceFrameSource', 'Input port', 'BlockSize', [35 35]);
        hbm.OutputValue = ...
            'Horizontal and vertical components in complex form';
        halphablend = vision.AlphaBlender;
        % Offset the first image by [5 5] pixels to create second image
        img2 = imtranslate(img1, [5 5]);
        % Compute motion for the two images
        motion = step(hbm, img1, img2);  
        % Blend two images
        img12 = step(halphablend, img2, img1);
        % Use quiver plot to show the direction of motion on the images   
        [X, Y] = meshgrid(1:35:size(img1, 2), 1:35:size(img1, 1));         
        imshow(img12); hold on;
        quiver(X(:), Y(:), real(motion(:)), imag(motion(:)), 0); hold off;