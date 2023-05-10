function [Xleft, Yleft, Xright, Yright] = mask_creation(right_lane, left_lane, I1, offset)

    % ------ left line intersections
    n1 = left_lane(2); 
    m1 = left_lane(1);
    x_big_intersect = m1*I1+n1;
    Xleft = [0; I1; I1; 0];
    Yleft = [n1-offset; x_big_intersect-offset; ...
        x_big_intersect+offset;n1+offset ];

    % ------ right line intersections
    n2 = right_lane(2); 
    m2 = right_lane(1);
    x_big_intersect_right = m2*I1+n2;
    Xright = [0; I1; I1; 0];
    Yright = [n2-offset; x_big_intersect_right-offset; ...
        x_big_intersect_right+offset; n2+offset ];
    
end

