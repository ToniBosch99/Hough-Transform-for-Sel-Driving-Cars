function [right_lane, y_right_line, left_lane, y_left_line, explicit_lines] = find_lanes(lines, x_line)
    % find_lanes will find two lanes given a set of lines
    % Initiate variables
    explicit_lines = zeros(size(lines,2), 2); % aqui es guarden pendent i offset   
    right_lane_lines =[];
    left_lane_lines = [];
    % loop for every line and decide if it must be from the left or right
    % lane
    for k = 1:length(lines)
        % create line
        xy = [lines(k).point1; lines(k).point2];
        new_line = polyfit(xy(:,1)',xy(:,2)',1);
        
        if new_line(1)<=0
            left_lane_lines = [left_lane_lines; new_line];
        elseif new_line(1)>0
            right_lane_lines = [right_lane_lines; new_line];
        end
        explicit_lines(k, :) = new_line;
    end
    
    % ------- Right lane
    right_lane = mean(right_lane_lines, 1);
    y_right_line = polyval(right_lane, x_line);
    
    % ------- Left lane
    left_lane = mean(left_lane_lines, 1);
    y_left_line = polyval(left_lane, x_line);
end
