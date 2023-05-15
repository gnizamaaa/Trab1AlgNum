%
% BogackiShampine
% https://en.wikipedia.org/wiki/List_of_Runge%E2%80%93Kutta_methods#Bogacki.E2.80.93Shampine
%
function [X, Y, YLow] = RungeKutta_Bogacki_Shampine(f, x0, y0, h, n )

%%% BogackiShampine method has two methods of orders 3 and 2. Its extended Butcher Tableau is:
%%% 
%%% 0   |   0     0     0     0 
%%% 1/2 |  1/2    0     0     0
%%% 3/4 |   0    3/4    0     0
%%% 1   |  2/9   1/3   4/9    0
%%% ----------------------------
%%%     |  2/9   1/3   4/9    0		High-order = 3
%%%     | 7/24   1/4   1/3   1/8	Low-order = 2
%%%
    s = 4; 
    butcher.isEmbedded = true;
    butcher.a = zeros(s,s);
    butcher.a(2,1) = 0.5;
    butcher.a(3,2) = 3.0/4;
    butcher.a(4,1) = 2.0/9; butcher.a(4,2) = 1.0/3; butcher.a(4,3) = 4.0/9;
    butcher.b = [2.0/9 1.0/3 4.0/9 0.0];
    butcher.bstar = [7.0/24 1.0/4 1.0/3 1.0/8];
    butcher.c = [0 0.5 0.75 1.0];
    %fprintf('R-K de terceira ordem, usando tableau de Butcher:\n');
    [X, Y, YLow] = RungeKutta(f, x0, y0, h, n, butcher, s );
end	
