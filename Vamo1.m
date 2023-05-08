pkg load symbolic;
syms y(x)
%path
addpath("edo","-begin")


func = @(x,y) (1-2*exp(x)*y)/exp(x);
x0 = 0; y0 = 1; h = 0.5; n = 5;
ax = [-1 3 -1 5];
ode = exp(x)*diff(y, x) + 2*exp(x)*y == 1;
cond = y(x0)==y0;
sol = dsolve(ode,cond);
y=matlabFunction(sol);

fprintf("EDO e sua condicao inicial\n");
ode
cond
fprintf("\nSolucao analitica\n");
sol
fprintf("\nSolucao numerica\n");
y

Xx= 0:0.01:2.5;
Yx = y(Xx);

Xmatr = zeros(7,n+1); Ymatr = zeros(7,n+1);

%Euler method
[Xmatr(1,:),Ymatr(1,:)] = Euler(func, x0, y0, h,n);
[Xmatr(2,:),Ymatr(2,:)] = EulerMelhorado(func, x0, y0, h,n);
[Xmatr(3,:),Ymatr(3,:)] = EulerModificado(func, x0, y0, h,n);

%Van der Houwen's/Wray third-order method
butcher.isEmbedded = false;
s = 3;
%butcher.a = zeros(s,s);
%butcher.a(2,1) = 8/15; butcher.a(3,1) = 1/4; butcher.a(3,2) = 5/12;
butcher.a =[0,0,0;8/15,0,0;1/4,5/12,0];
butcher.b = [1/4, 0, 3/4];
butcher.c = [0, 8/15, 2/3];
[Xmatr(4,:),Ymatr(4,:),~] = RungeKutta(func, x0, y0, h, n, butcher, s );

%Ralston's fourth-order method
ralston.isEmbedded = false;
s = 4;
ralston.a = zeros(s,s);
ralston.a(2,1) = 0.4;
ralston.a(3,1) = 0.29697761; ralston.a(3,2) = 0.15875964;
ralston.a(4,1) = 0.21810040; ralston.a(4,2) = -3.05096516; ralston.a(4,3) = 3.83286476;
ralston.b = [0.17476028, -0.55148066, 1.20553560, 0.17118478];
ralston.c = [0,0.4, 0.45573725, 1];
[Xmatr(5,:),Ymatr(5,:),~] = RungeKutta(func, x0, y0, h, n, ralston, s );

%Dormand-Prince
dormand.isEmbedded = true;
s = 7;
dormand.a = zeros(s,s);
dormand.a = [0,0,0,0,0,0,0;
             1/5,0,0,0,0,0,0;
             3/40,9/40,0,0,0,0,0;
             44/45,-56/15,32/9,0,0,0,0;
             19372/6561,-25360/2187,64448/6561,-212/729,0,0,0;
             9017/3168,-355/33,46732/5247,49/176,-5103/18656,0,0;
             35/384,0,500/1113,125/192,-2187/6784,11/84,0];
dormand.b = [35/384,0,500/1113,125/192,-2187/6784,11/84,0];
dormand.bstar = [5179/57600,0,7571/16695,393/640,-92097/339200,187/2100,1/40];
dormand.c = [0,1/5, 3/10, 4/5, 8/9, 1, 1];
[Xmatr(6,:),Ymatr(6,:),~] = RungeKutta(func, x0, y0, h, n, dormand, s );

[Xmatr(7,:),Ymatr(7,:)]=RungeKutta_Dormand_Prince_ode45(func, x0, y0, h, n, true);
[Xesp,Yesp]=RungeKutta_Dormand_Prince_ode45(func, x0, y0, h, n, false);


%Printando e plotando td
clf
hold on
plot (Xx, Yx, 'linewidth', 2)

markersize = 50;
lw = 1;

cols = {[1, 0, 0.094118], [1, 0.647059, 0.172549], [1, 1, 0.254902],[0, 0.501961, 0.094118], [0, 0, 0.976471], [0.525490, 0, 0.490196],[0.184314, 0.309804, 0.309804]};
marks = {'x', 'd', 'o', 's', 'y', 'v', '*'};

for j=1:7
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


%Impressao do passo adaptativo
for i=1:columns(Xesp)
    px = Xesp(i);
    py = Yesp(i);
    scatter(px, py, markersize, 'k', '*');
    if (i)<(n+1)
      line([Xesp(i) Xesp(i+1)], [Yesp(i) Yesp(i+1)], 'LineStyle', '-', 'linewidth', lw, 'Color', 'k');
    end
end
hold off;
shg;

epsfilename = 'Teste';
fprintf('Gerando grafico vetorial em arquivo EPS ''%s''...\n', epsfilename );
print(epsfilename, '-depsc2');


