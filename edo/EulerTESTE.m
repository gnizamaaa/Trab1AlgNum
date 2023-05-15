
addpath(['../' 'util'], ['../' 'edo']);

func = @(x,y) y; % RHS da EDO (Lado direito da equação diferencial)

x0 = 0;
y0 = 1;
h = 0.1;
n = 5;



[X, Y] = Euler(func, x0, y0, h, n );
printTabXY( X, 'X', Y, 'y aprox', '%8.3f', 'EULER' );



f = @(x) exp(x);	% Função exata

x = linspace(x0, x0+n*h, n+1);

y_exato = f(x);
printTabXY( x, 'X', y_exato, 'y exato', '%8.3f', 'Exponencial' );

printTabXY( x, 'X', Y-y_exato, 'resid  ', '%8.3f', 'Diferenca entre aproximacao e exato' );
