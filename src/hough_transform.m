function [lines, theta, rho] = hough_transform(Frame, theta_vals, minLength)
% hough_transform: function that will search for lines in a binarized frame

% --------- Find hough map

[H, theta, rho] = hough(Frame, 'RhoResolution' ,0.5, 'Theta' ,theta_vals);

% --------- Find peaks in the map
P = houghpeaks(H, 5, 'threshold' ,ceil(0.4*max(H(:))));

% --------- Find the lines of those peaks
lines = houghlines(Frame, theta, rho, P, 'FillGap' ,30, 'MinLength' , minLength);

end

