%
% Método Genérico de Segunda Ordem
% https://en.wikipedia.org/wiki/List_of_Runge%E2%80%93Kutta_methods#Generic_second-order_method
% https://en.wikipedia.org/wiki/Runge%E2%80%93Kutta_methods
%
function [X, Y] = RungeKutta_GenericoSegundaOrdem(f, x0, y0, h, n, a )
    if nargin(f) ~= 2
    	fprintf('GenericoSegundaOrdem: Erro: lado direito tem que ter dois argumentos: f(x,y)\n');
    	return;
    end


%%% Método Genérico de Segunda Ordem
%%% 
%%% 0   |  0          		0
%%% a   |  a          		0
%%% ------------------------------
%%%     | 1-1/(2a)  1/(2a)
%%%
    butcher.isEmbedded = false;
    s = 2; 
    butcher.a = zeros(s,s);
    b2 = 1/(2*a);
    b1 = 1-b2;
    butcher.a(2,1) = a; butcher.a(2,2) = a;
    butcher.b = [ b1 b2 ];
    butcher.c = [ 0 a ];
    %fprintf('R-K de segunda ordem, usando tableau de Butcher:\n');
    [X,Y,~] = RungeKutta(f, x0, y0, h, n, butcher, s );
end	
