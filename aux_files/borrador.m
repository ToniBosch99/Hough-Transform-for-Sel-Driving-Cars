
clear; close; clc

% Main program

clear; close all; clc
disp('Welcome:')
%---------------------------- 1. Import data

video = VideoReader("media\GoPro\GOPR0458.MP4");
% implay("media\CarreteraProva.mp4")
h = 360;
numberFrame = 5;
width = video.Width;
height = video.Height-h;
Xi = [0 width width 0 0 ];
Yi = [0 0 height height 0];

last_lanes =  [1.2 -755; 1.2 -755];
x_space = 0:video.Width;
y_space = 0:video.Height;

all_left_lanes = [];
all_right_lanes = [];

figure; 
% Loop for every frame on the video
% Every frame will be treated as an image.
while hasFrame(video)
    % Read frame, create image

%///////////////////////////////// 1. PREPROCESS FRAME ///////////////////%
        % --------- Cut
        colorFrame = initFrame(h:end, :,:);
        % --------- To grayscale
        frame = im2gray(colorFrame);

%//////////////////////////////// 2. FILTER AND FIND EDGES ///////////////%
        % --------- Filter    
        mask_sze = 4;
        filtered_frame = filter_frame(frame, mask_sze);
        % --------- Find edges
        thr = 0.6; % threshold to binarize image
        edgedFrame = edge(filtered_frame, 'canny', thr);
        % once edges found and image binarised, apply ROI
        laneFrame = apply_mask(edgedFrame, Xi, Yi);
     
%///////////////////////////////// 5. PLOTS //////////////////////////////%
        % Plot image
        subplot(2,1,1);imshow(frame);hold on;
        title(sprintf('Current Time = %.3f sec', video.CurrentTime));
        plot(x_line, y_right_line, 'red','LineWidth',2);
        plot(x_line, y_left_line, 'green','LineWidth',2);
    
        subplot(2,1,2);imshow(laneFrame);hold on;

    pause(1/5000);
end

