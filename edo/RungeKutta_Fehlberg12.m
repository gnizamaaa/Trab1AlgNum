%
% Fehlberg RK1(2)
% https://en.wikipedia.org/wiki/List_of_Runge%E2%80%93Kutta_methods#Embedded_methods
%
function [X, Y, YLow] = RungeKutta_Fehlberg12(f, x0, y0, h, n )

%%% Fehlberg RK1(2) method has two methods of orders 2 and 1. Its extended Butcher Tableau is:
%%% 
%%% 0   |   0             0 
%%% 1/2 |  1/2            0
%%% 1   |  1/256    255/256
%%% ----------------------------
%%%     |  1/512    255/256    1/512 		High-order = 2
%%%     | 1/256     255/256        0 	Low-order = 1
%%%
    s = 3; 
    butcher.isEmbedded = true;
    butcher.a = zeros(s,s);
    butcher.a(2,1) = 0.5;
    butcher.a(3,1) = 1.0/256; butcher.a(3,2) = 255.0/256;
    butcher.b = [1.0/512    255.0/256    1.0/512];
    butcher.bstar = [1.0/256    255.0/256    0.0];
    butcher.c = [0 0.5 1.0];
    %fprintf('Fehlberg RK1(2), usando tableau de Butcher:\n');
    [X, Y, YLow] = RungeKutta(f, x0, y0, h, n, butcher, s );
end	
