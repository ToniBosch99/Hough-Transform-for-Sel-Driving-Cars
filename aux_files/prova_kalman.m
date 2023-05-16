%Activitat 2: Estimació d'Estats amb el Filtre de Kalman Analític
clear; close all; clc

%/////////////////////////////////////////////////////////////////////////%

% ----------------------------- 1.Load values and data

load results\all_left_lanes ; % load data u,x,y (only uses u and y)
N=size(all_left_lanes,1); % determine the number of points


% ----------------------------- 2.Initial conditions & parameters
x_hat = [-1; 0];
P = [1 0; 0 1];
% Variances
Q = eye(2)*0.01; R = eye(2)*1;


% Matrixs of the system
A = eye(2);
C = eye(2);
D = 0;

x_hat_est = zeros(N, 2);
% P=zeros(N+1,1 ); % initialization of   P matrix
% L=zeros(N,1);

filtered_state = zeros(2, N);

for i = 1:N
    % Prediction step
    x_hat_minus = A * x_hat;
    y = all_left_lanes(i,:)';
    P_minus = A * P * A' + Q;
    
    % Update step
    K = P_minus * C' * (C * P_minus * C' + R)^-1;
    x_hat = x_hat_minus + K * (y - C * x_hat_minus);
    P = (eye(2) - K * C) * P_minus;
    
    filtered_state(:,i) = x_hat;

end
% 
% 
% % ----------------------------- 4. Loop
% for k=1:N 
%     y = all_left_lanes(k,:)';
%     % Càlcul de la matriu de l'observador
%     L= A*P*C'*(R+C*P*C')^-1;
%     % Calculem els valors de x_hat estimada
%     x_hat_pred = A*x_hat + L*(y-C*x_hat);
%     % Calculem els valors de P per la següent iteració
%     P = Q +(A-L*C)*P*A';
% 
%     
%     x_hat_est(k,:) =  x_hat;
%     x_hat = x_hat_pred;
% end
%%
% ----------------------------- 5.Plot results
figure()
plot(filtered_state(1,:)); % plot state estimation
hold on;
plot(all_left_lanes(:,1)); % plot state estimation
ylim([-2 0])

legend('Estimated estate', 'Real lanes')
