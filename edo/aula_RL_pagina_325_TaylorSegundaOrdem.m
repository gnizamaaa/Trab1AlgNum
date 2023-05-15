
clear all;

addpath(['../' 'util'], ['../' 'edo']);

is_octave = (exist('OCTAVE_VERSION','builtin')>1); % Octave ou Matlab
if is_octave
	available_graphics_toolkits();
	graphics_toolkit gnuplot;
	%graphics_toolkit qt;	% Start octave with: octave --no-gui

	pkg load symbolic;
	%
	% Se o pacote 'symbolic' do Octave ainda não estiver instalado, pegue aqui:
	% https://octave.sourceforge.io/download.php?package=symbolic-2.7.0.tar.gz
	% instale com o comando dentro do Octave: pkg install symbolic-2.7.0.tar.gz
	%
end;


syms f(x,y) T2(x,y,h)


%f(x,y) = y;				func = @(x,y) y;			x0 = 0; y0 = 1;	hh=0.1; n=5;		%%% y(x) = exp(x)
f(x,y) = 1 - y./x;		func = @(x,y) 1 - y./x;		x0 = 2; y0 = 2;	hh=0.1; n=5;		%%% Aula R.-L. p. 325
%f(x,y) = 2*x.*y;		func = @(x,y) 2*x.*y;		x0 = 1; y0 = 1;	hh=0.1; n=5;		%%% Dissertação Karine N. F. Valle  p. 20


%%% Taylor de segunda ordem
%%% (tem que ficar na frente de 'syms y(x)'
dfdx = diff(f,x);
dfdy = diff(f,y);

T2(x,y,h) = y +  h*f(x,y) + (h*h/sym(2))*(dfdx + dfdy*f(x,y));

%%%% !!! Atencão: Argumentos em ordem alfabetica (Octave), ou não (Matlab)
t2 = matlabFunction(T2);
if is_octave
    t2 = @(x, y, h) t2(h, x, y);
end

syms y(x) x0sym y0sym

x0sym = sym(x0);
y0sym = sym(y0);

ode = diff(y, x) == f(x,y);
sol = dsolve(ode, y(x0)==y0);

disp('A equacao diferencia oridinaria (EDO):'); ode
fprintf('Valor inicial: y(%.2f) = %.2f\n', x0, y0); 
disp('A solucao analitica da EDO='); sol

F = sol;
F = simplify(F);

ff = matlabFunction(F);
disp('A funcao numerica da solucao analitica da EDO='); ff

disp('Derivada parcial do lado direito da EDO em relacao a x:'); dfdx
disp('Derivada parcial do lado direito da EDO em relacao a y:'); dfdy
disp('Aproximacao de Taylor de ordem 2 da EDO:'); T2
disp('A funcao numerica:'); t2


xn = x0+n*hh;
x = x0:hh:xn;
taylor2 = zeros(n,1);
fx = zeros(1, n);	% Importante: Vetor de linha, pois os resultados dos Euler... também são linhas

%return

clf;
hold on
leg = {};
%plot(x,ff(x,x0,y0))

xx = x0:hh/100:xn;
linewidth = 1;
plot(xx, ff(xx), 'linewidth', linewidth)
xlabel ('x');
ylabel ('y');
title ('EDO');
leg{end+1} = 'y(x)';
shg; % Mostre a figura


y = y0;
i = 1;
taylor2(i) = y;
fx(i) = y;
fprintf('x[%3d]=%12.5f taylor2[%3d]=%12.5f  f(%12.5f)=%12.5f  Erro=%15.5e\n', ...
			i, x0, i, y, x0, fx(i), y-fx(i))
for i = 2:length(x)
	y = t2(x(i-1),y,hh);
	taylor2(i) = y;
	fx(i) = ff(x(i));
	fprintf('x[%3d]=%12.5f taylor2[%3d]=%12.5f  f(%12.5f)=%12.5f  Erro=%15.5e\n', ...
			i, x(i), i, y, x(i), fx(i), y-fx(i))
end
fmt = '%.5e';
printTabXY( x, 'X', taylor2, 'Y', fmt, 'Taylor explicito Segunda Ordem' );
printTabXY( x, 'X', fx-taylor2, 'Erro', fmt, 'ERRO: Taylor explicito Segunda Ordem' );

plot(x, taylor2, 'rd', 'linewidth', linewidth)
leg{end+1} = 'Taylor explicito Segunda Ordem';
plot(x, fx, 'b+', 'linewidth', linewidth)
leg{end+1} = 'f(x)';

[X,Y] = Euler(func, x0, y0, hh, n );
printTabXY( X, 'X', Y, 'Y', fmt, 'Euler' );
printTabXY( x, 'X', fx-Y, 'Erro', fmt, 'ERRO: Euler' );
plot(X, Y, 'm^', 'linewidth', linewidth)
leg{end+1} = 'Euler';

[X,Y] = EulerModificado(func, x0, y0, hh, n );
printTabXY( X, 'X', Y, 'Y', fmt, 'Euler Modificado' );
printTabXY( x, 'X', fx-Y, 'Erro', fmt, 'ERRO: Euler Modificado' );
plot(X, Y, 'g^', 'linewidth', linewidth)
leg{end+1} = 'Euler Modificado';

[X,Y] = EulerMelhorado(func, x0, y0, hh, n );
printTabXY( X, 'X', Y, 'Y', fmt, 'Euler Melhorado' );
printTabXY( x, 'X', fx-Y, 'Erro', fmt, 'ERRO: Euler Melhorado' );
plot(X, Y, 'c^', 'linewidth', linewidth)
leg{end+1} = 'Euler Melhorado';
hold off


xlabel ('x');
ylabel ('y');
title ('EDO');

legend(leg);
shg;

%return;

epsfilename = 'edoRL325';
fprintf('Gerando grafico vetorial em arquivo EPS ''%s''...\n', epsfilename );
print(epsfilename, '-depsc2');
fprintf('Gerando grafico vetorial em arquivo SVG ''%s''...\n', 'edoRL325.svg' );
print('edoRL325.svg', '-dsvg');

