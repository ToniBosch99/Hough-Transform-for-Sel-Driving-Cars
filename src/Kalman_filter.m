function [x_hat_pred, P_next] = Kalman_filter(lane, predicted_lane, P, Q, R, A, B, C)
%KALMA_FILTER Summary of this function goes here
%   Detailed explanation goes here
      
    y = lane;
    x_hat = predicted_lane;

    % Càlcul de la matriu de l'observador
    L= A*P*C'*(R+C*P*C')^-1; 

    % Calculem els valors de x_hat estimada
    x_hat_pred= A*x_hat+B*u+L*(y-C*x_hat);

    % Calculem els valors de P per la següent iteració
    P_next= Q +(A-L*C)*P*A';
    
    % Intervals de confiança
%     lb=x_hat(k+1)-alpha*sqrt(P_next);
%     ub=x_hat(k+1)+alpha*sqrt(P_next);
end

