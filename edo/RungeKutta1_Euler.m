%
% Runge-Kutta Third order method
% https://en.wikipedia.org/wiki/List_of_Runge%E2%80%93Kutta_methods#Kutta.27s_third-order_method
% https://en.wikipedia.org/wiki/Runge%E2%80%93Kutta_methods
%
function [X,Y] = RungeKutta1_Euler(f, x0, y0, h, n )

%%% Kutta's first-order method = Euler
%%% 
%%% 0   |  0
%%% --------
%%%     |  1
%%%
    butcher.isEmbedded = false;
    s = 1; 
    butcher.a = zeros(s,s);
    butcher.a(1,1) = 0;
    butcher.b = [1.0];
    butcher.c = [0];
    %fprintf('R-K de primeira ordem, usando tableau de Butcher:\n');
    [X,Y,~] = RungeKutta(f, x0, y0, h, n, butcher, s );
end	
