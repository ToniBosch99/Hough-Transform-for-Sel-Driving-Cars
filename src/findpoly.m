function [Xi, Yi] = findpoly(x_line,right_lane, y_right_line, left_lane, y_left_line, I1, I2)
    [xi,yi] = polyxpoly(x_line, y_right_line, x_line, y_left_line);
    % ------ left line intersections
    n1 = left_lane(2); 
    y_cut = y_left_line(1);
    if n1 < I2    
        Xi = [0; 0];
        Yi = [I2 ;y_cut];
    else
        Xi = [x_line(1)];
        Yi = [y_cut];
    end
    % ------ lane intersections
    if yi>0 %include intersection point
        Xi = [Xi; xi];
        Yi = [Yi; yi];
    else %include intersection with y = 0
        left_x_cut = polyxpoly(x_line, zeros(1, size(x_line,2)), x_line, y_left_line);
        right_x_cut = polyxpoly(x_line, zeros(1, size(x_line,2)), x_line, y_right_line);
        Xi = [Xi; left_x_cut; right_x_cut];
        Yi = [Yi; 0; 0];
    end
    % ------ right lane intersections
    final_y = y_right_line(end);
    if final_y < I2    
        Xi = [Xi; I1; I1];
        Yi = [Yi; final_y; I2 ];
    else
        x_cut = polyxpoly(x_line, repmat(I2,1, size(x_line,2)), x_line, y_right_line);
        Xi = [Xi; x_cut];
        Yi = [Yi; I2];
    end