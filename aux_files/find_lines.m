
clear; close all; clc
%//////////////////////////////// 1. IMPORT IMAGE ////////////////////////%
% --------- Read image
RGB = imread('.\media\Prova\road_curve.jpg');
% --------- To grayscale
if size(RGB, 3) == 3
    I = im2gray(RGB);
else
    I = RGB;
end

% --------- Resize & cut image
I = imresize(I, [183, 275]);
I_cut = I(90:end, :);


%//////////////////////////////// 2. FILTER AND FINDE EDGES //////////////%
% --------- BLur
I_blurr = imgaussfilt(I_cut, 4);
% --------- Find edges
thr = 0.6; % threshold to binarize image
edgedFrame = edge(I_blurr, 'canny', thr, 2);



%//////////////////////////////// 3. HOUGH TRANSFROM /////////////////////%
% --------- Find hough map
theta_vals = [-60:1:-20, 20:1:60]; % limit range of thetaas to find 
[H,theta,rho] = hough(edgedFrame, 'RhoResolution' ,.5, 'Theta' ,theta_vals);

% --------- Find peaks in the map
P = houghpeaks(H, 20, 'threshold' ,ceil(0.5*max(H(:))));

% --------- Find the lines of those peaks
minLength = 7;
lines = houghlines(edgedFrame, theta, rho, P, 'FillGap' ,10, 'MinLength' ,minLength);

% ---------- Plots
figure;
imshow(imadjust(rescale(H)), 'XData' ,theta, 'YData' ,rho, ... 
      'InitialMagnification' , 'fit' );
title( 'Hough transform of gantrycrane.png' );
xlabel( '\theta' ), ylabel( '\rho' );
axis on , axis normal , hold on ;
colormap(gca,hot);
hold on
x = theta(P(:,2));
y = rho(P(:,1));
plot(x,y, 's' , 'color' , 'green','LineWidth',2);



%//////////////////////////////// 4. POST-PROCESS LINES //////////////////%
% ---------- Start plots
figure;
subplot(3,1,1);imshow(I_cut), hold on
max_len = 0;

% ---------- Eliminate similar lines
% aixo alomillor no fa falta
% ES POT DESCOMENTAR
% [vals, indices] = unique([lines.theta; lines.rho]', 'rows');
% filtered_lines = lines(indices);

% creem les linies
x_line = 0:size(edgedFrame,2);
explicit_line = zeros(size(lines,2), 2); % aqui es guarden pendent i offset
y_line = zeros(size(lines,2), size(x_line,2));

right_lane_lines =[];
left_lane_lines = [];
for k = 1:length(lines)
    xy = [lines(k).point1; lines(k).point2];
    plot(xy(:,1)', xy(:,2)','blue');

    new_line = polyfit(xy(:,1)',xy(:,2)',1);
    y_line(k,:) = polyval(new_line, x_line);
    
    % Ara podriem agrupar les linies per esquerra i dreta
    % una vegada arupades, trobem el pendent mitja dels de lesquerra i dels de
    % la dreta ----> veure funcions de Python
    
    % un cop tenim els pendents mitjans, ja podem crear les dues linies de
    % carril

    if new_line(1)<=0
        lines(k).theta
        disp('left')
        left_lane_lines = [left_lane_lines; new_line];
    elseif new_line(1)>0
        lines(k).theta
        disp('right')
        right_lane_lines = [right_lane_lines; new_line];
    end
    explicit_line(k, :) = new_line;
%     plot de cada una de les linies
%     plot(x_line, y_line(k,:),'blue');
end

% % carril dret
% right_lane = mean(right_lane_lines, 1);
% y_right_line = polyval(right_lane, x_line);
% 
% plot(x_line, y_right_line, 'red','LineWidth',2);
% 
% % carril esquerra
% left_lane = mean(left_lane_lines, 1);
% y_left_line = polyval(left_lane, x_line);
% plot(x_line, y_left_line, 'red','LineWidth',2);
% 
% 
% %---------------Intersection between two lines
% 
% % plot(round(xi),round(yi),'x','LineWidth',2,'Color','green')


subplot(3,1,2);imshow(I_blurr), hold on
subplot(3,1,3);imshow(edgedFrame); title( 'Edges' ); hold on

% [Xi, Yi] = findpoly(x_line, right_lane, y_right_line, left_lane, y_left_line, size(I_cut, 2), size(I_cut, 1));
% 
% mask = poly2mask(Xi, Yi, size(I_cut, 1), size(I_cut, 2));
% mask = im2uint8(imfill(mask, 'holes'));
% 
% blackMaskedImage = I_cut;
% blackMaskedImage(~mask) = 0;
% 
% topLine = round(min(Xi));
% bottomLine = round(max(Xi));
% leftColumn = round(min(Yi));
% rightColumn = round(max(Yi));
% width = bottomLine - topLine + 1;
% height = rightColumn - leftColumn + 1;
% croppedImage = imcrop(blackMaskedImage, [topLine, leftColumn, width, height]);
% figure; imshow(croppedImage);