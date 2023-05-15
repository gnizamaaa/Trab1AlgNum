%
% Cash-Karp
% https://en.wikipedia.org/wiki/List_of_Runge%E2%80%93Kutta_methods#Cash-Karp
%
function [X, Y, YLow] = RungeKutta_Cash_Karp45(f, x0, y0, h, n )

%%% Cash and Karp have modified Fehlberg's original idea. The extended tableau for the Cash–Karp method is 
%%% 
%%%  0     |   0 
%%%  1/5   |  1/5
%%%  3/10  |  3/40             9/40
%%%  3/5   |  3/10            -9/10             6/5
%%%   1    |  -11/54            5/2          -70/27         35/27
%%%   7/8  |  1631/55296    175/512       575/13824  44275/110592    253/4096
%%% -----------------------------------------------------------------------------------------
%%%        |   37/378             0         250/621        125/594          0       512/1771   High-order = 5
%%%        |   2825/27648         0     18575/48384    13525/55296  277/14336        1/4       Low-order = 4
%%%
    s = 6; 
    butcher.isEmbedded = true;
    butcher.a = zeros(s,s);
    butcher.a(2,1) = 0.2;
    butcher.a(3,1) = 3.0/40;       butcher.a(3,2) = 9.0/40;
    butcher.a(4,1) = 0.3;          butcher.a(4,2) = -0.9;      butcher.a(4,3) = 1.2;
    butcher.a(5,1) = -11.0/54;     butcher.a(5,2) = 2.5;       butcher.a(5,3) = -70.0/27;    butcher.a(5,4) = 35.0/27;
    butcher.a(6,1) = 1631.0/55296; butcher.a(6,2) = 175.0/512; butcher.a(6,3) = 575.0/13824; butcher.a(6,4) = 44275.0/110592; butcher.a(6,5) = 253.0/4096;  
    
    butcher.b = [37.0/378             0         250.0/621        125.0/594          0       512.0/1771];
    butcher.bstar = [2825.0/27648         0     18575.0/48384    13525.0/55296  277.0/14336        0.25];
    butcher.c = [0  0.2  0.3  0.6  1.0  0.875];
    fprintf('Cash-Karp RK4(5), usando tableau de Butcher:\n');
    [X, Y, YLow] = RungeKutta(f, x0, y0, h, n, butcher, s );
end	


