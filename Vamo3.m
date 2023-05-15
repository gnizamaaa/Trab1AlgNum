%Caso eseteja rodando na pasta do script, ira adicionar o path da pasta edo, fornecida pelo professor
addpath("edo")
warning("off",  'Octave:negative-data-log-axis');
pkg load symbolic;

function null = resolva3(Qin,Qout,dQ, nome)
  %Contantes
  t0 = 0; v0 = 2000; h = 0.5; n = 5; vMax = 5000;

  %Encontro de v(t)
  syms v(t);
  odeTrans = diff(v, t)== dQ;
  cond = v(t0)==v0;
  odeEsv = diff(v, t)== dQ;
  v = dsolve(odeEsv,cond);

  % Encontrando C(t)
  syms c(t)
  t0 = 0; C0 = 0.05; Cin = 2; h = 0.5; n = 5;
  ode = diff(c, t) == (Qin*(Cin - c))/v
  y = sym ('2');
  cond = c(sym('0'))==C0;
  c = dsolve(ode,cond);
  cfunc=matlabFunction(c);

  %Plot c(t)
  i = double(solve(v == 0))

  clf
  hold on
  Xx=0:0.1:i;
  plot(Xx, cfunc(Xx))
  plot([0,i], [C0,C0],  '--')
  plot([0,i], [Cin,Cin],  '--')
  legend ( {"c(t)","c0", "Cin" },"location", "northeastoutside");
  title ("Evolucao temporal de concentracao");
  xlabel("t [min]")
  ylabel("c(t) [kg/L]")
  hold off;
  shg;

  epsfilename = strcat('Concentracao ',nome);
  fprintf('Gerando grafico vetorial em arquivo EPS ''%s''...\n', epsfilename );
  print(epsfilename, '-depsc2');
  
  %Encontrando M(t)
  syms m(t)
  m = c*v
  
  mfunc=matlabFunction(m);

  %Plot M(t)
  clf
  hold on
  plot(Xx, mfunc(Xx))
  plot([0,i], [v0,v0],  '--')
  temp = matlabFunction(v);
  plot(Xx, temp(Xx))
  plot([0,i], [vMax,vMax],  '--')
  plot([i,i], [0,vMax],  '--')
  legend ( {"m(t)","v0", "V(t)","Vmax" },"location", "northeastoutside");
  title ("Evolucao temporal de concentracao");
  xlabel("t [min]")
  ylabel("c(t) [kg/L]")
  hold off;
  shg;

  epsfilename = strcat('Material ',nome);
  fprintf('Gerando grafico vetorial em arquivo EPS ''%s''...\n', epsfilename );
  print(epsfilename, '-depsc2');
end

%De caso

Qin=45;
Qout = 50;
dQ = Qin - Qout;
nome = 'Esvaziamento'

resolva3(Qin,Qout,dQ, nome)