function [croppedImage, bin_mask] = apply_mask(image, Xleft, Yleft, Xright, Yright)
    % cut_frame: function to crop and mask the image at the beggining

    % ------- create mask 
    % left mask
    mask_left = poly2mask(Xleft', Yleft',size(image,1), size(image,2));
    bin_mask_left = im2uint8(imfill(mask_left, 'holes'));
    % right mask
    mask_right = poly2mask(Xright', Yright', size(image,1), size(image,2));
    bin_mask_right = im2uint8(imfill(mask_right, 'holes'));
    % join
    bin_mask = bitor(bin_mask_left, bin_mask_right);
    
    % -------- apply mask
    blackMaskedImage = image;%bitand(uint8(image), bin_mask);
    blackMaskedImage(~bin_mask) = 0;
%     
%     topLine = round(min(Xi));
%     bottomLine = round(max(Xi));
%     leftColumn = round(min(Yi));
%     rightColumn = round(max(Yi));
%     width = bottomLine - topLine + 1;
%     height = rightColumn - leftColumn + 1;

    croppedImage = blackMaskedImage;%imcrop(blackMaskedImage, [topLine, leftColumn, width, height]);
