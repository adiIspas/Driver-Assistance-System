% Script which maps the MATLAB test image in camera pixel coordinates (Ic)
    % to a bird's eye view image in world coordinates (Iw).
    clear; clc;
    m = 240;
    n = 320;
    % Ic = imread('grayRoadScene.tif');
    Ic = imread('images/road.jpg');
    Ic = imresize(Ic, [m, n]);
    Ic = double(Ic)/255;
    alpha = 30/2*pi/180;  % Might need 30/2????
    cx = 4;
    cy = -10;
    cz = 5;
    gamma0 = 0;
    theta0 = atan(0.5/20);
    %-------------------------
    %% Get Xvis Yvis Matrices
    %-------------------------
    rHorizon = ceil((m-1)/(2*alpha)*(alpha-theta0)+1);
    mCropped = m-rHorizon+1;
    Xvis = zeros(mCropped,n);
    Yvis = zeros(size(Xvis));
    Icropped = Ic(rHorizon:m,:);
    for r = 1:mCropped
        rOrig = r + rHorizon - 1;
        u = rOrig - 1;
        for c = 1:n
            v = c - 1;
            cotStuff = cot(theta0-alpha+u*(2*alpha)/(m-1));
            otherArg = gamma0-alpha+v*(2*alpha)/(n-1);
            Xvis(r,c) = cz*cotStuff*sin(otherArg) + cx;
            Yvis(r,c) = cz*cotStuff*cos(otherArg) + cy;
        end
    end
    % To see how the image points spread out in the world frame, we can do:
    % plot(Xvis(:), Yvis(:), 'LineStyle', 'none', 'Marker', '.', 'MarkerSize', 4);
    
    
    %---------------------------
    %% Set up the xg, yg ranges
    %---------------------------
    % Based on the above plot command, the following ranges seem reasonable.
    xg = -50:0.25:50;
    yg = (0:0.25:150)';
    %------------------------------------------------
    %% Interpolate to get the world coordinate image
    %------------------------------------------------
    [rows, columns] = size(Icropped);
    Xvis = imresize(Xvis, [rows, columns]);%Resize because of griddata bitchin'
    Yvis = imresize(Yvis, [rows, columns]);
    Iw = griddata(Xvis, Yvis, Icropped, xg, yg, 'linear');
    imagesc(Iw,[0 1]); colormap(gray);
    axis image;