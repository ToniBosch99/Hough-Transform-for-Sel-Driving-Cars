myDirectory = 'C:\Users\Toni\OneDrive\Escriptori\ETSEIB\MUEI\Q3\Sistemes de percepció\Mini Projecte\Implementation';
addpath(genpath(myDirectory))
%%
clear; close; clc

% Main program

clear; close all; clc
disp('Welcome:')
%---------------------------- 1. Import data

video = VideoReader("media\GoPro\GOPR0478.MP4");

y_start = 200;
y_end = 100;
numberFrame = 5;
width = video.Width;
height = video.Height-y_start-y_end;

% Initial variables
Xleft = [0 width width 0 0 ];
Yleft = [0 0 height height 0];
Xright = Xleft;
Yright=Yleft;
last_lanes =  [1.2 -755; 1.2 -755];
counter = 0;
predicted_lane = [-1; 1000; -1; -1000]; %x_hat_o
P = eye(4);
% Variances
Q = eye(4)*0.01; R = eye(4)*1;


% Matrixs of the system
A = eye(4);
C = eye(4);
D = 0;

x_space = 0:video.Width;
y_space = 0:video.Height;

all_left_lanes = [];
all_right_lanes = [];

x_line = x_space;

figure; 
% Loop for every frame on the video
% Every frame will be treated as an image.

while hasFrame(video)
    % Read frame, create image
    initFrame = readFrame(video);
    if numberFrame == 5
        
        numberFrame = 0;
%///////////////////////////////// 1. PREPROCESS FRAME ///////////////////%
        % --------- Cut
        colorFrame = initFrame(y_start:end-y_end, :,:);
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
        
        [lanes, y_right_line, y_left_line] = find_lanes(lines, x_line, last_lanes);
        
        % kalman filter
        % now we have the meaurment (lanes) and we filter it with an
        % estimation
        
        [lanes_pred, P_next] = kalman_filter(lanes, predicted_lane, P, Q, R, A, C);
        if counter >3
            right_lane = lanes_pred(1:2)'; %lanes_pred
            left_lane = lanes_pred(3:4)'; %lanes_pred
        else
            right_lane = lanes(1:2); %lanes_pred
            left_lane = lanes(3:4); %lanes_pred
        end
        predicted_lane = lanes_pred;
        P = P_next;
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
        counter = counter+1;
    else
        numberFrame =  numberFrame+1;
    end
    
    pause(1/5000);
end

n = size(all_right_lanes,1);
figure;
subplot(2,1,1);plot(1:n, all_right_lanes(:, 1)',1:n, all_left_lanes(:, 1)')
subplot(2,1,2);plot(1:n, all_right_lanes(:, 2)',1:n, all_left_lanes(:, 2)')
