%
% Gauss-Legendre
% https://en.wikipedia.org/wiki/List_of_Runge%E2%80%93Kutta_methods#Gauss%E2%80%93Legendre_methods
%
function [X, Y, YLow] = RungeKutta_Gauss_Legendre4(f, x0, y0, h, n )

%%% These methods are based on the points of Gauss-Legendre quadrature.
%%%   The Gauss-Legendre method of order four has Butcher tableau:
%%% s3 := sqrt(3)
%%%
%%% 1/2-s3/6   |   1/4        1/4-s3/6 
%%% 1/2+s3/6   |   1/4+s3/6   1/4
%%% ------------------------------------
%%%            |   1/2        1/2		High-order = 4
%%%            | 1/2+s3/2     1/2-s3/2		Low-order = 3
%%%
    s = 2; 
    butcher.isEmbedded = true;
    s3 = sqrt(3.0); s36 = s3/6; s32 = s3/2;
    butcher.a = zeros(s,s);
    butcher.a(1,1) = 0.25;
    butcher.a(1,2) = 0.5 - s36;
    butcher.a(2,1) = 0.5 + s36;
    butcher.a(2,2) = 0.25;

    butcher.b = [0.5 0.5];
    butcher.bstar = [0.5+s32 0.5-s32];
    butcher.c = [0.5-s36 0.5+s36];
    [X,Y,YLow] = RungeKutta(f, x0, y0, h, n, butcher, s );
end	
 
