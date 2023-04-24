% gaussian mask
function [filteredImage]= GaussianFilter(image, size, var)
    % creation filter
%     LoG = fspecial('log', size, var);
    % convolution operation 
    filteredImage = imgaussfilt(image, var, 'FilterSize' , size);
    

end