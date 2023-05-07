pkg load symbolic;
syms y(x)
addpath('./edo')


func = @(x,y) (1-2*exp(x)*y)/exp(x);
x0 = 0; y0 = 1; h = 0.5; n = 5;
ax = [-1 3 -1 5];
ode = exp(x)*diff(y, x) + 2*exp(x)*y == 1;
cond = y(x0)==y0;
sol = dsolve(ode,cond);
y=matlabFunction(sol)

fprintf("EDO e sua condicao inicial\n");
ode
cond
fprintf("\nSolucao analitica\n");
sol
fprintf("\nSolucao numerica\n");
y

Xx= 0:0.01:2.5;
Yx = y(Xx);
[Xe,Ye] = Euler(func, x0, y0, h,n)
[Xem,Yem] = EulerMelhorado(func, x0, y0, h,n)
[Xemod,Yemod] = EulerModificado(func, x0, y0, h,n)

y(Xe)


clf
hold on


plot (Xx, Yx, 'linewidth', 1.5)

markersize = 50;
lw = 1;

cols = {'r', 'g', 'm', 'c', 'y'};

for i=1:n+1
	px = Xe(i);
	py = Ye(i);
	scatter(px, py, markersize, cols{1}, 'x');
  if (i)<(n+1)
    line([Xe(i) Xe(i+1)], [Ye(i) Ye(i+1)], 'LineStyle', '-', 'linewidth', lw, 'Color', cols{1});
  end
  %if i > 1
  %  line([Xe(i) Xe(i)], [Ye(i) y(Xe(i))], 'LineStyle', '-.', 'linewidth', lw, 'Color', cols{1});
 % end
end
for i=1:n+1
	px = Xem(i);
	py = Yem(i);
	scatter(px, py, markersize, cols{2}, 'd');
  if (i)<(n+1)
    line([Xem(i) Xem(i+1)], [Yem(i) Yem(i+1)], 'LineStyle', '-', 'linewidth', lw, 'Color', cols{2});
  end
end
for i=1:n+1
	px = Xemod(i);
	py = Yemod(i);
	scatter(px, py, markersize, cols{3}, 'o');
  if (i)<(n+1)
    line([Xemod(i) Xemod(i+1)], [Yemod(i) Yemod(i+1)], 'LineStyle', '-', 'linewidth', lw, 'Color', cols{3});
  end
end


hold off;
shg;

epsfilename = 'Teste';
fprintf('Gerando grafico vetorial em arquivo EPS ''%s''...\n', epsfilename );
print(epsfilename, '-depsc2');



