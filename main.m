% Main program

clear; close all; clc
disp('Welcome:')
%---------------------------- 1. Import data

video = VideoReader("media\CarreteraProva.mp4");
% implay("media\CarreteraProva.mp4")

% Loop for every frame on the video
% Every frame will be treated as an image.
while hasFrame(video)
    % Read frame, create image
    bigFrame = readFrame(video);
    %Cut image
    frame = bigFrame(360:end, :, :);
    % Image to gray:
    grayFrame = im2gray(frame);
    grayFrame = double(grayFrame);
    % ------------------------- Canny edge detection
    % Gaussian filter
    grayFrame = GaussianFilter(grayFrame, 9, 5);
    % Sobel operator
    edgedFrame = sobel(grayFrame, 80);

    % Plot image
    imshow(edgedFrame);
    title(sprintf('Current Time = %.3f sec', video.CurrentTime));

    % Diminish speed by 2
    pause(1/video.FrameRate);
end
