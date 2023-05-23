function [bisector]= bisector_lane(right, left)

    % Encuentra los puntos de intersección
    x_intersect = (right(2) - left(2)) / (right(1) - left(1));
    y_intersect = right(1) * x_intersect + right(2);
    
    % Calcula el punto medio
%     midpoint_x = (x_intersect(1) + x_intersect(2)) / 2;
%     midpoint_y = (y_intersect(1) + y_intersect(2)) / 2;
    
    % Calcula la pendiente de cada línea
    slope1 = right(1);
    slope2 = left(1);
    
    % Calcula la pendiente promedio
    bisector_slope = (slope1 + slope2) / 2;
    
    % Calcula la ordenada al origen de la bisectriz
    bisector_intercept = y_intersect - bisector_slope * x_intersect;

    bisector = [bisector_slope bisector_intercept];