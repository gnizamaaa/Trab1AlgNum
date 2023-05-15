
clear all;

addpath(['../' 'util'], ['../' 'edo']);

is_octave = (exist('OCTAVE_VERSION','builtin')>1); % Octave ou Matlab
if is_octave
	available_graphics_toolkits();
	graphics_toolkit gnuplot;
	%graphics_toolkit qt;

	pkg load symbolic;
	%
	% Se o pacote 'symbolic' do Octave ainda não estiver instalado, pegue aqui:
	% https://octave.sourceforge.io/download.php?package=symbolic-2.7.0.tar.gz
	% instale com o comando dentro do Octave: pkg install symbolic-2.7.0.tar.gz
	%
end;


func = @(x,y) y;			x0 = 0; y0 = 1;	h=0.1; n=5;		%%% y(x) = exp(x)
func = @(x,y) 1 - y./x;		x0 = 2; y0 = 2;	h=0.1; n=5;		%%% Aula R.-L. p. 325
func = @(x,y) 2*x.*y;		x0 = 1; y0 = 1;	h=0.1; n=5;		%%% Dissertação Karine N. F. Valle  p. 20


%%%
%%% https://pt.wikipedia.org/wiki/M%C3%A9todo_de_Runge-Kutta
%%% https://en.wikipedia.org/wiki/List_of_Runge%E2%80%93Kutta_methods
%%% https://pt.wikipedia.org/wiki/Lista_de_m%C3%A9todos_Runge-Kutta
%%%


[X, Y, YLow] = RungeKutta_Cash_Karp45(func, x0, y0, 1, 1 );
printTabXY( X, 'X', YLow, 'YLow', '%.10f', 'Cash-Karp ordem baixa (4)' );
printTabXY( X, 'X', Y, 'Y', '%.10f', 'Cash-Karp ordem alta (5)' );
return


fmt = '%.5f';

[X, Y] = Euler(func, x0, y0, h, n );
printTabXY( X, 'X', Y, 'Y', fmt, 'Euler' );

[X, Y] = RungeKutta1_Euler(func, x0, y0, h, n );
printTabXY( X, 'X', Y, 'Y', fmt, 'Euler por Runge-Kutta' );

[X, Y] = EulerMelhorado(func, x0, y0, h, n );
printTabXY( X, 'X', Y, 'Y', fmt, 'EulerMelhorado (Heun)' );

[X, Y] = RungeKutta1_EulerMelhorado_Heun(func, x0, y0, h, n );
printTabXY( X, 'X', Y, 'Y', fmt, 'Euler Melhorado (Heun) por Runge-Kutta' );

[X, Y] = RungeKutta3(func, x0, y0, h, n );
printTabXY( X, 'X', Y, 'Y', fmt, 'Runge-Kutta ordem tres' );

[X, Y, YLow] = RungeKutta_Bogacki_Shampine(func, x0, y0, h, n );
printTabXY( X, 'X', YLow, 'YLow', fmt, 'Bogacki_Shampine ordem baixa (2)' );
printTabXY( X, 'X', Y, 'Y', fmt, 'Bogacki_Shampine ordem alta (3)' );

[X, Y, YLow] = RungeKutta_Gauss_Legendre4(func, x0, y0, h, n );
printTabXY( X, 'X', YLow, 'YLow', fmt, 'Gauss-Legendre ordem baixa (3)' );
printTabXY( X, 'X', Y, 'Y', fmt, 'Gauss-Legendre ordem alta (4)' );

[X, Y, YLow] = RungeKutta_Cash_Karp45(func, x0, y0, h, n );
printTabXY( X, 'X', YLow, 'YLow', fmt, 'Cash-Karp ordem baixa (4)' );
printTabXY( X, 'X', Y, 'Y', fmt, 'Cash-Karp ordem alta (5)' );

[X, Y, YLow] = RungeKutta_Fehlberg45(func, x0, y0, h, n );
printTabXY( X, 'X', YLow, 'YLow', fmt, 'Fehlberg ordem baixa (4)' );
printTabXY( X, 'X', Y, 'Y', fmt, 'Fehlberg ordem alta (5)' );



a = [1/4 1/2 3/4];
for i=1:length(a)
	[X, Y] = RungeKutta_GenericoSegundaOrdem(func, x0, y0, h, n, a(i) );
	printTabXY( X, 'X', Y, 'Y', fmt, sprintf('Runge-Kutta generico de segunda ordem com a=%.3f', a(i)));
end

[X, Y] = RungeKutta_Dormand_Prince45(func, x0, y0, h, n );
printTabXY( X, 'X', Y, 'Y', fmt, 'Dormand-Prince pelo tableau de Butcher' );

passofixo = true;
[X, Y] = RungeKutta_Dormand_Prince_ode45(func, x0, y0, h, n, passofixo );
printTabXY( X, 'X', Y, 'Y', fmt, 'Dormand-Prince (Matlab/Octave ode45) --- Passo fixo' );

passofixo = false;
[X, Y] = RungeKutta_Dormand_Prince_ode45(func, x0, y0, h, n, passofixo );
printTabXY( X, 'X', Y, 'Y', fmt, 'Dormand-Prince (Matlab/Octave ode45) --- Passo adaptativo' );

