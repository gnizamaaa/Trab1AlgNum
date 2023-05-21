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
  ode = diff(c, t) == (Qin*(Cin - c))/v;
  y = sym ('2');
  cond = c(sym('0'))==C0;
  printf('Solucao c(t) do PVI:\n')
  c = dsolve(ode,cond)
  cfunc=matlabFunction(c);

  %Plot c(t)
  i=500;
  if (dQ>0)
    i = double(solve(v == vMax));
  endif
  if (dQ<0)
    i = double(solve(v == 0));
  endif
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
  printf('funcao do aditivo m(t):\n')
  m = c*v
  mfunc=matlabFunction(m);

  %Plot M(t)
  clf
  hold on
  plot(Xx, mfunc(Xx))
  plot([0,i], [v0,v0],  '--')
  temp = matlabFunction(v);
  if(v==v0)
      plot([0,i], [v0,v0])
  else
      plot(Xx, temp(Xx))
  end
  plot([0,i], [vMax,vMax],  '--')
  if(dQ!=0)
    plot([i,i], [0,vMax],  '--')
  end
  legend ( {"m(t)","v0", "V(t)","Vmax" },"location", "northeastoutside");
  title ("Evolucao temporal de material e volume do tanque");
  xlabel("t [min]")
  ylabel("m(t) [kg], V(t) [L]")
  hold off;
  shg;

  epsfilename = strcat('Material ',nome);
  fprintf('Gerando grafico vetorial em arquivo EPS ''%s''...\n', epsfilename );
  print(epsfilename, '-depsc2');
end

warning("off", "OctSymPy:sym:rationalapprox");

%Primeiro caso: Esvaziamento
clear
Qin=45;
Qout = 50;
dQ = Qin - Qout;
nome = 'Esvaziamento';
printf('Caso de esvaziamento:\n')
resolva3(Qin,Qout,dQ, nome)

%Terceiro caso: Transbordamento
clear
Qin=50;
Qout = 45;
dQ = Qin - Qout;
nome = 'Transbordamento';
printf('Caso de Transbordamento:\n')
resolva3(Qin,Qout,dQ, nome)

%Segundo caso: constante
clear
Qin=45;
Qout = 45;
dQ = Qin - Qout;
nome = 'constante';
printf('Caso constante:\n')
resolva3(Qin,Qout,dQ, nome)
