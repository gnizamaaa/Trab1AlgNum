
addpath(['../' 'util'], ['../' 'edo']);


is_octave = (exist('OCTAVE_VERSION','builtin')>1); % Octave or Matlab
if is_octave
	% if not installed, install with:
	% In shell:
	% sudo apt-get install python-pip
	% pip install --user sympy
	% In Octave:
	%% pkg install -forge symbolic
	% pkg install  symbolic-2.6.0.tar.gz
	pkg load symbolic
end


%%%
%%% Problema do valor inicial
%%%
%func = @(x,y) y; % RHS da EDO (Lado direito da equação diferencial)
x0 = sym(0); y0 = sym(1);


%
% Solução analítica, usando pacote simbólico de Octave/Matlab (Python sympy)
%
syms y(x)
RHS = y;
edo = diff(y, x) == RHS;
sol = dsolve(edo, y(x0)==y0);
sol = simplify(sol);
F = sol;
yx = matlabFunction(F);	% https://www.mathworks.com/help/symbolic/matlabfunction.html

fprintf('EDO:');
edo
fprintf('Solucao analitica:');
F
fprintf('Solucao analitica em forma de funcao numerica de Octave:');
yx
fprintf('Tem que coincidir no ponto conhecido: y(x0)=y0? : %e = %e ?\n', yx(double(x0)), double(y0) );


%
% Método de Euler = Método de primeira ordem
% Sabendo a solução analítica do PVI, ou seja, a função y(x)
% é possível calular o termo de erro
% e(x_k) = M_k+1 * h^{k+1}/(k+1)!
% Majorante M_k+1 = max | y^(k+1)(x) |   x no intervalo
% Euler: k = 1
% M_2 = max | y''(x) | , x no intervalo
%


% calculando a segunda derivada de f(x) = y(x)
dfdx = diff(F, x)
d2fdx2 = diff(dfdx, x)  % = diff(F, x, 2) = diff(F, x, x)


x0 = 0.0
xn = 0.04

fprintf('Segunda derivada da funcao y(x):\n');
y2 = matlabFunction(d2fdx2)

% Sabe se que a função exponencial é monótona
y2min = y2(x0)
y2max = y2(xn)

fprintf('Intervalo=[%.2f, %.2f] --- Valores no inicio e fim: y2min=%.2f, y2min=%.2f\n',...
    x0, xn, y2min, y2max)

% Majorante é maior valor no intervalo
M2 = max(y2min, y2max)


% Erro máximo permitido
erromax = 5e-4;

syms h
% Valor máximo do passo
s = solve(erromax == M2/sym(2) * h^2)

maxh = max(double(s))

% n tem que ser número inteiro
% n >= (xn-x0) / maxh

n = ceil((xn-x0) / maxh)

h = (xn-x0) / n

% Agora podemos dividir o intervalo


x = linspace(x0, x0+n*h, n+1);

func = @(x, y) y;
y_exato = yx(x);
x0 = double(x0); y0 = double(y0);
[X, Y] = Euler(func, x0, y0, h, n );
printTabXY( x, 'X', y_exato, 'y exato', '%.3e', 'Euler' );

printTabXY( x, 'X', Y-y_exato, 'resid  ', '%.3e', 'Diferenca entre aproximacao e exato' );

clf
hold on

leg = {};
linewidth = 1;

xx = x0:0.001:xn;
plot(xx, yx(xx), 'linewidth', linewidth)

xlabel ('x');
ylabel ('y');
title ('EDO');
leg{end+1} = 'y(x)';

for i=1:n+1
    plot(X(i), Y(i), 'r+', 'linewidth', linewidth)
    leg{end+1} = sprintf('(x_{%d},y_{%d})', i, i);
end

legend(leg);
shg; % Mostre a figura

epsfilename = 'edoRL324';
fprintf('Gerando grafico vetorial em arquivo EPS ''%s''...\n', epsfilename );
print(epsfilename, '-depsc2');
