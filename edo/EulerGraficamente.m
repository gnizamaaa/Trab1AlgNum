
clear all;

addpath(['../' 'util'], ['../' 'edo']);

is_octave = (exist('OCTAVE_VERSION','builtin')>1); % Octave ou Matlab
if is_octave
    % available_graphics_toolkits();
    % graphics_toolkit fltk;
    % graphics_toolkit gnuplot;
    % pkg install -forge symbolic
    pkg load symbolic;	% Carregar bibliotéca simbólica
end;

% Declararção das variáveis simbólicas
syms y(x)


if 1	% 1=Use 0=Não use
func = @(x,y) y;
edostr = 'EDO: dy/dx = y(x) ; Valor inicial: y(0)=1 --- Solução: y(x) = exp(x)';
x0 = 0; y0 = 1; h = 0.5; n = 3;
ax = [-1 3 -1 5];
ode = diff(y, x) == y;
end


if 0	% 1=Use 0=Não use
func = @(x,y) 1.0 - y/x;
edostr = 'EDO: dy/dx = 1-y(x)/x ; Valor inicial: y(2)=2 --- Solução: y(x) = x/2 + 2/x';
x0 = 2.0; y0 = 2.0; h = 1.0; n = 5;
ax = [-1 3 -1 5];
ode = x * diff(y, x) == x-y;
end


fprintf('EDO: '); ode


cond = y(x0)==y0;
fprintf('Condicao inicicial: '); cond

sol = dsolve(ode, cond);
fprintf('Solucao: '); sol

F = sol;

yx = matlabFunction(F);
fprintf('Versao numerica da solucao: '); yx

%

[X,Y] = Euler(func, x0, y0, h, n )
printTabXY( X, 'X', Y, 'Y', '%.5e', 'Euler' );
printTabXY( X, 'X', yx(X)-Y, 'Erro', '%.5e', 'ERRO: Euler' );



x = ax(1):0.01:ax(2);

clf
leg = {};
hold on
fontsize = 16;
markersize = 50;
lw = 1.5;

axis(ax);
scatter(X, yx(X), markersize, 'k', 'filled');
leg{end+1} = sprintf('(x,y(x))');
%scatter(X, Y, markersize, 'filled');

plot(x, yx(x), 'linewidth', lw)
leg{end+1} = 'y(x)';
title(edostr, 'fontsize', fontsize);


cols = {'r', 'g', 'b', 'm', 'c', 'y'};

% https://www.mathworks.com/matlabcentral/answers/281511-how-do-i-plot-the-plot-a-line-using-slope-and-one-x-y-coordinate-on-matlab
inclinacao_tangente = @(x,y) func(x,y);
for i=1:n+1
	px = X(i);
	py = Y(i);
	scatter(px, py, markersize, cols{i}, 'filled');
    leg{end+1} = sprintf('(x_{%d},y_{%d})', i-1, i-1);
	m = inclinacao_tangente(px, py);
	tangente = @(x) m*(x - px) + py;
	%xa = px - h;
	xa = px;	%%% Pintar tangente somente a partir de xn
	ya = tangente(xa);
	xb = px + h;
	yb = tangente(xb);
	line([xa xb], [ya yb], 'linestyle', '-', 'linewidth', lw, 'color', cols{i});
   	leg{end+1} = sprintf('Tangente %d', i-1);

	xa = px - h;
	ya = tangente(xa);
	xb = px;
	yb = tangente(xb);
	line([xa xb], [ya yb], 'linestyle', '--', 'linewidth', lw, 'color',...
			cols{i},  'HandleVisibility','off'); % Hide from legend;
    if i > 1
        line([X(i) X(i)], [Y(i) yx(X(i))], 'LineStyle', '-.', 'linewidth', lw, 'Color', cols{i-1});
        leg{end+1} = sprintf('Erro Euler {%d}', i-1);
    end
end

h = legend(leg);
set (h, 'fontsize', fontsize, 'location', 'east');
hold off;

shg;

epsfilename = 'EulerGraficamente';
fprintf('Gerando grafico vetorial em arquivo EPS ''%s''...\n', epsfilename );
set (h, 'fontsize', fontsize);
print(epsfilename, '-depsc2');

