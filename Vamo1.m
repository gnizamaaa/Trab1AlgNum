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

Xmatr = zeros(5,n+1); Ymatr = zeros(5,n+1);

[Xmatr(1,:),Ymatr(1,:)] = Euler(func, x0, y0, h,n);
[Xmatr(2,:),Ymatr(2,:)] = EulerMelhorado(func, x0, y0, h,n);
[Xmatr(3,:),Ymatr(3,:)] = EulerModificado(func, x0, y0, h,n);

Ymatr
y(Xe)


clf
hold on
plot (Xx, Yx, 'linewidth', 1.5)

markersize = 50;
lw = 1;

cols = {'r', 'g', 'm', 'c', 'y'};
marks = {'x', 'd', 'o', 's', 'y', 'v', '8'};

for j=1:3
  Xtemp = Xmatr(j,:);
  Ytemp = Ymatr(j,:);

  for i=1:n+1
    px = Xtemp(i);
    py = Ytemp(i);
    scatter(px, py, markersize, cols{j}, marks{j});
    if (i)<(n+1)
      line([Xtemp(i) Xtemp(i+1)], [Ytemp(i) Ytemp(i+1)], 'LineStyle', '-', 'linewidth', lw, 'Color', cols{j});
    end
  end
end


hold off;
shg;

epsfilename = 'Teste';
fprintf('Gerando grafico vetorial em arquivo EPS ''%s''...\n', epsfilename );
print(epsfilename, '-depsc2');



