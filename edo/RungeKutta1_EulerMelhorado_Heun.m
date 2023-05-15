%
% Runge-Kutta Third order method
% https://en.wikipedia.org/wiki/List_of_Runge%E2%80%93Kutta_methods#Kutta.27s_third-order_method
% https://en.wikipedia.org/wiki/Runge%E2%80%93Kutta_methods
%
function [X, Y] = RungeKutta1_EulerMelhorado_Heun(f, x0, y0, h, n )

%%% Heun = Euler Melhorado
%%% 
%%% 0  |  0   0
%%% 1  |  1   0
%%% ------------
%%%    | 1/2  1/2
%%% 
s = 2;
butcher.isEmbedded = false;
butcher.a = zeros(s,s);
butcher.a(2,1) = 1.0;
butcher.b = [0.5 0.5];
butcher.c = [0 1];
% fprintf('Euler Melhorado (Heun) usando tableau de Butcher:\n');
[X, Y, ~] = RungeKutta(f, x0, y0, h, n, butcher, s );
end	
