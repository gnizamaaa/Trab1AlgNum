%
% Fehlberg
% https://en.wikipedia.org/wiki/List_of_Runge%E2%80%93Kutta_methods#Embedded_methods
%
function [X, Y, YLow] = RungeKutta_Fehlberg45(f, x0, y0, h, n )

%%% Fehlberg method has two methods of orders 5 and 4. Its extended Butcher Tableau is:
%%% 
%%% 0     |   0                  0 
%%% 1/4   |  1/4                 0
%%% 3/8   |  3/32             9/32
%%% 12/13 |  1932/2197  -7200/2197     7296/2197
%%%     1 |  439/216            -8      3680/513     -845/4104
%%%   1/2 |    -8/27            -2    -3544/2565     1859/4104     -11/40
%%% ----------------------------------------------------------------------
%%%       |   16/135             0     6656/12825    28561/56430    -9/50     2/55     High-order = 5
%%%       |   25/216             0      1408/2565     2197/4104     -1/5         0     Low-order = 4
%%%
    s = 6;
    butcher.isEmbedded = true;
    butcher.a = zeros(s,s);
    butcher.a(2,1) = 0.25;
    butcher.a(3,1) = 3.0/32; butcher.a(3,2) = 9.0/32;
    butcher.a(4,1) = 1932.0/2197; butcher.a(4,2) = -7200.0/2197; butcher.a(4,3) = 7296.0/2197;
    butcher.a(5,1) = 439.0/216; butcher.a(5,2) = -8.0; butcher.a(5,3) = 3680.0/513; butcher.a(5,4) = -845.0/4104;
    butcher.a(6,1) = -8.0/27; butcher.a(6,2) = -2.0; butcher.a(6,3) = -3544.0/2565; butcher.a(6,4) = 1859.0/4104; butcher.a(6,5) = -11.0/40;  
    
    butcher.b = [16.0/135  0.0  6656.0/12825  28561.0/56430  -9.0/50  2.0/55];
    butcher.bstar = [25.0/216  0.0  1408.0/2565  2197.0/4104  -1.0/5  0.0];
    butcher.c = [0 0.25 0.375 12.0/13 1.0 0.5];
    %fprintf('Fehlberg RK4(5), usando tableau de Butcher:\n');
    [X, Y, YLow] = RungeKutta(f, x0, y0, h, n, butcher, s );
end	
