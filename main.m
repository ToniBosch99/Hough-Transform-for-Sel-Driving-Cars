% myDirectory = 'C:\Users\Toni\OneDrive\Escriptori\ETSEIB\MUEI\Q3\Sistemes de percepció\Mini Projecte\Implementation';
% addpath(genpath(myDirectory))

clear; close; clc

% Main program

clear; close all; clc
disp('Welcome:')
%---------------------------- 1. Import data

video = VideoReader("media\CarreteraProva.mp4");
% implay("media\CarreteraProva.mp4")
h = 360;
width = video.Width;
height = video.Height-h;
Xi = [0 width width 0 0 ];
Yi = [0 0 height height 0];

x_space = 0:video.Width;
y_space = 0:video.Height;
figure;
% Loop for every frame on the video
% Every frame will be treated as an image.
while hasFrame(video)
    % Read frame, create image
    bigFrame = readFrame(video);
%///////////////////////////////// 1. PREPROCESS FRAME ///////////////////%
    % --------- To grayscale
    bigFrameGray = im2gray(bigFrame);
    % --------- Cut
    frame = bigFrameGray(h:end, :);

%//////////////////////////////// 2. FILTER AND FIND EDGES ///////////////%
    % --------- Filter    
    mask_sze = 4;
    filtered_frame = filter_frame(frame, mask_sze);
    % --------- Find edges
    thr = 0.6; % threshold to binarize image
    edgedFrame = edge(filtered_frame, 'canny', thr);
    laneFrame = apply_mask(edgedFrame, Xi, Yi);
    % Plot image
    imshow(laneFrame);hold on;
    title(sprintf('Current Time = %.3f sec', video.CurrentTime));
%//////////////////////////////// 3. HOUGH TRANSFROM /////////////////////%
    theta_vals = [-80:.5:-10, 10:.5:80]; % limit range of thetas to find 
    minLength = 7;
    lines = hough_transform(laneFrame, theta_vals, minLength);

%//////////////////////////////// 4. POST-PROCESS LINES //////////////////%
    x_line = x_space;
    [right_lane, y_right_line, left_lane, y_left_line] = find_lanes(lines, x_line);

%///////////////////////////////// 5. PLOTS //////////////////////////////%
    plot(x_line, y_right_line, 'red','LineWidth',2);
    plot(x_line, y_left_line, 'green','LineWidth',2);

%///////////////////////////////// 6. ROI UPDATE /////////////////////////%
    [Xi, Yi] = findpoly(x_line, right_lane, y_right_line, left_lane, y_left_line, width, height);
    % Diminish speed by 2
    pause(1/video.FrameRate);
end
