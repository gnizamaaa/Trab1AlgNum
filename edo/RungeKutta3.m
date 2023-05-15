%
% Runge-Kutta Third order method
% https://en.wikipedia.org/wiki/List_of_Runge%E2%80%93Kutta_methods#Kutta.27s_third-order_method
% https://en.wikipedia.org/wiki/Runge%E2%80%93Kutta_methods
%
function [X,Y] = RungeKutta3(f, x0, y0, h, n )

%%% Kutta's third-order method
%%% 
%%% 0   |  0    0    0
%%% 1/2 |  1/2  0    0
%%% 1   | -1    2    0
%%% -------------------
%%%     | 1/6  2/3  1/6
%%%
    butcher.isEmbedded = false;
    s = 3; 
    butcher.a = zeros(s,s);
    butcher.a(2,1) = 0.5;
    butcher.a(3,1) = -1.0; butcher.a(3,2) = 2.0;
    butcher.b = [1.0/6 2.0/3 1.0/6];
    butcher.c = [0 0.5 1];
    %fprintf('R-K de terceira ordem, usando tableau de Butcher:\n');
    [X,Y,~] = RungeKutta(f, x0, y0, h, n, butcher, s );
end	
