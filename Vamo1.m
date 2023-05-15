%Caso eseteja rodando na pasta do script, ira adicionar o path da pasta edo, fornecida pelo professor
addpath("edo")
warning("off",  'Octave:negative-data-log-axis');
pkg load symbolic;

function null = resolva1(func,ode,cond,x0,y0,h,n,letra)
  sol = dsolve(ode,cond);
  y=matlabFunction(sol);

  fprintf("EDO e sua condicao inicial\n");
  ode
  cond

  fprintf("\nSolucao analitica\n");
  sol
  fprintf("\nSolucao numerica\n");
  y

  Xx= x0:(h/10):(x0+h*n);
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
  %[Xesp,Yesp]=RungeKutta_Dormand_Prince_ode45(func, x0, y0, h, n, false);
  [Xesp,Yesp]=ode45(func, [x0, (x0+h*n)], y0);

  % Armazenando os erros de cada metodo
  Yexato = y(Xmatr(1,:));
  Yerros = zeros(7,n+1);
  for j=1:7
    for i=1:length(Xmatr(1,:))
    Yerros(j,i)=abs(Yexato(1,i)-Ymatr(j,i));
    end
  end


  %Printando e plotando tudo
  clf
  hold on
  plot (Xx, Yx, 'linewidth', 2)

  markersize = 50;
  lw = 1;

  cols = {[1, 0, 0.094118], [1, 0.647059, 0.172549], [1, 1, 0.254902],[0, 0.501961, 0.094118], [0, 0, 0.976471], [0.525490, 0, 0.490196],[0.184314, 0.309804, 0.309804]};
  marks = {'-+', '-d', '-o', '-s', '-y', '-v', '-^'};

  for j=1:7
    Xtemp = Xmatr(j,:);
    Ytemp = Ymatr(j,:);
    plot(Xtemp,Ytemp, marks{j})
  end


  plot(Xesp,Yesp, "-*");

  xlabel ("x");
  ylabel ("y");
  legend ( {"y(x)","Euler", "Euler Mel.","Euler Mod.", "V d Houven/Wray","Ralston", "Dorm.-Pr45-Bu","ODE45 fixo", "ODE45 adap."},"location", "northeastoutside");

  hold off;
  shg;

  epsfilename = strcat('Solucao EDO ', letra);
  fprintf('Gerando grafico vetorial em arquivo EPS ''%s''...\n', epsfilename );
  print(epsfilename, '-depsc2');

  %Impressao das tabelas
  fprintf("          x     |      Valor Exato |        Euler   |      Euler Mel. |      Euler Mod. | V d Houven/Wray |     Ralston     |   Dorm.-Pr45-Bu |      ODE45 fixo |      ODE45 adap\n");
  fprintf('--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n');
  for i=1:length(Xmatr(1,:))
    fprintf('     %10.6f |      %10.6f |      %10.6f |      %10.6f |      %10.6f |      %10.6f |      %10.6f |      %10.6f |      %10.6f |      ----\n', Xmatr(1,i), Yexato(i), Ymatr(1,i),Ymatr(2,i),Ymatr(3,i),Ymatr(4,i),Ymatr(5,i), Ymatr(6,i), Ymatr(7,i) );
  end

  fprintf('Erros:\n');
  for i=1:length(Xmatr(1,:))
    fprintf('   %10.6e |    %10.6e |    %10.6e |    %10.6e |    %10.6e |    %10.6e |    %10.6e |    %10.6e |    %10.6e |      ----\n', Xmatr(1,i), Yexato(i)-Yexato(i), Yerros(1,i),Yerros(2,i),Yerros(3,i),Yerros(4,i),Yerros(5,i), Yerros(6,i), Yerros(7,i) );
  end

  %Plot do grafico de erros em escala logaritmica
  clf
  hold on

  marks = {'-+', '-d', '-o', '-s', '-y', '-v', '-^'};

  semilogy(Xmatr(1,:), Yerros,marks)

  xlabel ("x");
  ylabel ("ln(|Erro|)");
  %legend ( "location", "northeast");
  semilogy(Xesp,abs(y(Xesp)-Yesp), '-*')
  legend ( {"Euler", "Euler Mel.","Euler Mod.", "V d Houven/Wray","Ralston", "Dorm.-Pr45-Bu","ODE45 fixo", "ODE45 adap."},"location", "northeastoutside");
  title ("Erros, Escala logaritmica");

  hold off;
  shg;

  epsfilename =  strcat('Erros Escala Log ', letra) ;
  fprintf('Gerando grafico vetorial em arquivo EPS ''%s''...\n', epsfilename );
  print(epsfilename, '-depsc2');

endfunction


clear
  syms y(x)
  func = @(x,y) (1-2*exp(x)*y)/exp(x);
  x0 = 0; y0 = 1; h = 0.5; n = 5;
  ode = exp(x)*diff(y, x) + 2*exp(x)*y == 1;
  cond = y(x0)==y0;
 letra = "a";

resolva1(func, ode, cond, x0, y0,h,n, letra)

clear
 syms y(x)
  x0 = pi; y0 = 1; h = 1; n = 5;
  ode = x*diff(y, x) + (3*y) == sin(x)/(x.^2);
  func = @(x, y) ((sin(x)/(x^2))-3*y)/x;
  cond = y(x0)==y0;
  letra = "b";

resolva1(func, ode, cond, x0, y0,h,n, letra)

clear
syms y(x)
  x0 = pi/8; y0 = 1; h = pi/16; n = 5;
  ode = diff(y, x) + (tan(x)*y) == (cos(x)^2)
  func = @(x, y) (cos(x)^2) - (tan(x)*y) 
  cond = y(x0)==y0;
  letra = "c";

resolva1(func, ode, cond, x0, y0,h,n, letra)

clear
 syms y(x)
  x0 = 1; y0 = 1; h = 0.1; n = 5;
  ode = x*diff(y, x) + (2*y) == 1 - (1/x);
  func = @(x, y) (1 - (1/x) - (2*y))/x;
  cond = y(x0)==y0;
  letra = "d";

resolva1(func, ode, cond, x0, y0,h,n, letra)




