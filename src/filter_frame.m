function [filtered_image] = filter_frame(image, mask_sike)
% this funcition returns a given image with the following filters applied

% --------- BLur
filtered_image = imgaussfilt(image, mask_sike);
end