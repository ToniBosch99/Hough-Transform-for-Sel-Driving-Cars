function [croppedImage, bin_mask] = apply_mask(image, Xi, Yi)
    % cut_frame: function to crop and mask the image at the beggining

    % create mask 
    mask = poly2mask(Xi', Yi', size(image,1), size(image,2));
    bin_mask = im2uint8(imfill(mask, 'holes'));

    blackMaskedImage = image;
    blackMaskedImage(~bin_mask) = 0;
    
    topLine = round(min(Xi));
    bottomLine = round(max(Xi));
    leftColumn = round(min(Yi));
    rightColumn = round(max(Yi));
    width = bottomLine - topLine + 1;
    height = rightColumn - leftColumn + 1;

    croppedImage = imcrop(blackMaskedImage, [topLine, leftColumn, width, height]);
