%
% Fehlberg
% https://en.wikipedia.org/wiki/List_of_Runge%E2%80%93Kutta_methods#Embedded_methods
%
function [X, Y, YLow] = RungeKutta_Dormand_Prince45(f, x0, y0, h, n )

%%% Dormand-Prince method has two methods of orders 5 and 4. Its extended Butcher Tableau is:
%%%
%%% 0    |   0 
%%% 1/5  |  1/5
%%% 3/10 |  3/40                  9/40
%%% 4/5  |  44/45                -56/15      32/9
%%% 8/9  |  19372/6561      -25360/2187      64448/6561      -212/729
%%%   1  |  9017/3168           -355/33      46732/5247        49/176      -5103/18656
%%%   1  |  35/384                    0        500/1113       125/192      -2187/6784            11/84
%%% --------------------------------------------------------------------------------------------------------------------------------
%%%      |    35/384                  0        500/1113       125/192      -2187/6784            11/84      0     High-order = 5
%%%      |   5179/57600               0      7571/16695       393/640      -92097/339200      187/2100      1/40  Low-order = 4
%%%
    s = 7;
    butcher.isEmbedded = true;
    butcher.a = zeros(s,s);
    butcher.a(2,1) = 0.2;
    butcher.a(3,1) = 3.0/40;       butcher.a(3,2) = 9.0/40;
    butcher.a(4,1) = 44.0/45;      butcher.a(4,2) = -56.0/15;    butcher.a(4,3) = 32.0/9;
    butcher.a(5,1) = 19372.0/6561; butcher.a(5,2) = -25360/2187; butcher.a(5,3) = 64448.0/6561;  butcher.a(5,4) = -212.0/729;
    butcher.a(6,1) = 9017.0/3168;  butcher.a(6,2) = -355.0/33;   butcher.a(6,3) = 46732.0/5247;  butcher.a(6,4) = 49.0/176;  butcher.a(6,5) = -5103.0/18656;
    butcher.a(7,1) = 35.0/384;     butcher.a(7,2) = 0;           butcher.a(7,3) = 500/1113;      butcher.a(7,4) = 125/192;   butcher.a(7,5) = -2187.0/6784; butcher.a(7,6) = 11.0/84; 
    
    butcher.b = [35/384                  0        500/1113       125/192      -2187/6784            11/84      0];
    butcher.bstar = [5179/57600               0      7571/16695       393/640      -92097/339200      187/2100      1/40];
    butcher.c = [0 0.2 0.3 0.8 8.0/9 1 1];
    %fprintf('Dormand_Prince45, usando tableau de Butcher:\n');
    [X, Y, YLow] = RungeKutta(f, x0, y0, h, n, butcher, s );
end
