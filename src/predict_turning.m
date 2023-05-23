function [direction] = predict_turning(slope_k, slope_last_k)
    right_increment= slope_k(1)-slope_last_k(1);
    left_increment = slope_k(2)-slope_last_k(2);

    if (left_increment <0.05) && (right_increment>0.05)
        direction = 'right turn';

    elseif (left_increment >0.05) && (right_increment<0.05)
        direction = 'left turn';
    else
        direction = 'Straight';
    end