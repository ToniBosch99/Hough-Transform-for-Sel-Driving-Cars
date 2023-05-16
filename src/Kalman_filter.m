function [x_hat_pred, P_next] = kalman_filter(lane, predicted_lane, P, Q, R, A, C)
% KALMAN_FILTER Filter the detected lane. Two states: slope and offset
%   Basically, we predict the what the next lane should be based on the
%   latest detected lane compared to the prediction done on last step. 
%           - A: identity matrix nxn (n=number of states).
%           - C: same as A.
%           - P: Covariance matrix. Updated t every step
%           - Q: State variances matrix. Estimation of gaussian noise of every
%           state
%           - R: Output variances matrix. Estimation of gaussian noise of every
%           measured state (sensor noise). Normally bigger than Q.

    % Measurement
    y = lane'; % transpose???

    % Predicted lane last iteration
    x_hat = predicted_lane;

    % Prediction step
    x_hat_minus = A * x_hat;
    P_minus = A * P * A' + Q;
    
    % Kalman gain
    K = P_minus * C' * (C * P_minus * C' + R)^-1;
    % Prediction
    x_hat_pred = x_hat_minus + K * (y - C * x_hat_minus);
    % Update P
    P_next = (eye(4) - K * C) * P_minus;
    
end

