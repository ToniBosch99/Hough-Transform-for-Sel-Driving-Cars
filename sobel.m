function [output_image] = sobel(input_image, threshold)
%     Gx = [-1 0 1; -2 0 2; -1 0 1];
%     Gy = [-1 -2 -1; 0 0 0; 1 2 1];
%     
% Prewitt Operator Mask
Mx = [-1 0 1; -2 0 2; -1 0 1];
My = [-1 -2 -1; 0 0 0; 1 2 1];
  
% Edge Detection Process
% When i = 1 and j = 1, then filtered_image pixel  
% position will be filtered_image(2, 2)
% The mask is of 3x3, so we need to traverse 
% to filtered_image(size(input_image, 1) - 2
%, size(input_image, 2) - 2)
% Thus we are not considering the borders.
for i = 1:size(input_image, 1) - 2
    for j = 1:size(input_image, 2) - 2
  
        % Gradient approximations
        Gx = sum(sum(Mx.*input_image(i:i+2, j:j+2)));
        Gy = sum(sum(My.*input_image(i:i+2, j:j+2)));
                 
        % Calculate magnitude of vector
        filtered_image(i+1, j+1) = sqrt(Gx.^2 + Gy.^2);
         
    end
end
  
% Displaying Filtered Image
filtered_image = uint8(filtered_image);
% Define a threshold value

output_image = max(filtered_image, threshold);
output_image(output_image == round(threshold)) = 0;
  
% Displaying Output Image
output_image = imbinarize(output_image);
end