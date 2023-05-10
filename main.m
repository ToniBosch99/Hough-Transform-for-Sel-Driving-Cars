myDirectory = 'C:\Users\Toni\OneDrive\Escriptori\ETSEIB\MUEI\Q3\Sistemes de percepció\Mini Projecte\Implementation';
addpath(genpath(myDirectory))
%%
clear; close; clc

% Main program

clear; close all; clc
disp('Welcome:')
%---------------------------- 1. Import data

video = VideoReader("media\GoPro\GOPR0466.MP4");

h = 360;
numberFrame = 5;
width = video.Width;
height = video.Height-h;

% Initial variables
Xleft = [0 width width 0 0 ];
Yleft = [0 0 height height 0];
Xright = Xleft;
Yright=Yleft;
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
    initFrame = readFrame(video);
    if numberFrame == 10
        
        numberFrame = 0;
%///////////////////////////////// 1. PREPROCESS FRAME ///////////////////%
        % --------- Cut
        colorFrame = initFrame(h:end, :,:);
        % --------- To grayscale
        frame = im2gray(colorFrame);

%//////////////////////////////// 2. FILTER AND FIND EDGES ///////////////%
        % --------- Filter    
        mask_sze = 6;
        filtered_frame = filter_frame(frame, mask_sze);
        % --------- Find edges
        thr = 0.4; % threshold to binarize image
        edgedFrame = edge(filtered_frame, 'canny', thr);
        % once edges found and image binarised, apply ROI
        laneFrame = apply_mask(edgedFrame, Xleft, Yleft, Xright, Yright);
      
%//////////////////////////////// 3. HOUGH TRANSFROM /////////////////////%
        theta_vals = [-80:.5:-10, 10:.5:80]; % limit range of thetas to find 
        minLength = 7;
        lines = hough_transform(laneFrame, theta_vals, minLength);

%//////////////////////////////// 4. POST-PROCESS LINES //////////////////%
        x_line = x_space;
        [right_lane, y_right_line, left_lane, y_left_line] = find_lanes(lines, x_line, last_lanes);
        
        % kalman filter
        % now we have the meaurment (lanes) and we filter it with an
        % estimation
        
% [x_hat_pred, P_next] = Kalman_filter(lane, predicted_lane, P, Q, R, A, B, C)

        % save to a bigger matrix for later use
        all_left_lanes = [all_left_lanes; left_lane];
        all_right_lanes = [all_right_lanes; right_lane];
        
%///////////////////////////////// 5. PLOTS //////////////////////////////%
        % Plot image
        subplot(2,1,1);imshow(frame);hold on;
        title(sprintf('Current Time = %.3f sec', video.CurrentTime));
        plot(x_line, y_right_line, 'red','LineWidth',2);
        plot(x_line, y_left_line, 'green','LineWidth',2);
    
        subplot(2,1,2);imshow(laneFrame);hold on;

%///////////////////////////////// 6. ROI UPDATE /////////////////////////%
%         [Xi, Yi] = findpoly(x_line, right_lane, y_right_line, left_lane, y_left_line, width, height);
        offset = 200;
        [Xleft, Yleft, Xright, Yright] = mask_creation(right_lane, left_lane, width, offset);
        % plot
        plot([Xleft;Xright], [Yleft;Yright], 'b')
        
        last_lanes =  [right_lane; left_lane];
     
    else
        numberFrame =  numberFrame+1;
    end
   
    pause(1/5000);
end

n = size(all_right_lanes,1);
figure;
subplot(2,1,1);plot(1:n, all_right_lanes(:, 1)',1:n, all_left_lanes(:, 1)')
subplot(2,1,2);plot(1:n, all_right_lanes(:, 2)',1:n, all_left_lanes(:, 2)')
