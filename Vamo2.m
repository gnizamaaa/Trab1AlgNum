pkg load symbolic;

%Caso eseteja rodando na pasta do script, ira adicionar o path da pasta edo, fornecida pelo professor
addpath("edo","-end")

Qin=50;
Qout = 45;
dQ = Qin - Qout;

syms v(t);
%func = @(v,t) dQ;
t0 = 0; v0 = 2000; h = 0.5; n = 5; vMax = 5000;
at = [-1 3 -1 5];
odeTrans = diff(v, t)== dQ;
cond = v(t0)==v0;

fprintf("Caso enchendo (Transbordamento):\n")

fprintf("Solucao analitica simbolica:\n")
solTrans = dsolve(odeTrans,cond)

fprintf("\nFuncao numerica:\n")
yTrans=matlabFunction(solTrans)

fprintf("Instante em que transborda:\n")
iTrans = solve(solTrans == vMax)

Qin=45;
Qout = 50;
dQ = Qin - Qout;
odeEsv = diff(v, t)== dQ;

fprintf("\nCaso Esvaziamento:\n")

fprintf("Solucao analitica simbolica:\n")
solEsv = dsolve(odeEsv,cond)

fprintf("\nFuncao numerica:\n")
yEsv=matlabFunction(solEsv)

fprintf("Instante em que esvazia completamente:\n")
iEsv = solve(solEsv == 0)

Qin=50;
Qout = 50;
dQ = Qin - Qout;
odeConst = diff(v, t)== dQ;

fprintf("\nCaso Esvaziamento:\n")

fprintf("Solucao analitica simbolica:\n")
solConst = dsolve(odeConst,cond)

fprintf("\nFuncao numerica:\n")
yConst=matlabFunction(solConst)

lineMax = @(v,t)5000
%lineMin = @(v,t) == 0;


clf
hold on
iDouble = double (iTrans)
x = 0:0.1:iDouble;
plot([0,iDouble],[vMax,vMax], 'r--', 'color','g')
plot([0,iDouble],[v0,v0], 'r--', 'color','b')
plot([iDouble,iDouble],[0,vMax], 'r--')
plot(x,yTrans(x))
xlabel ("t [min]");
ylabel ("V(t) [L]");


hold off;
shg;

epsfilename = 'Transbordamento';
fprintf('Gerando grafico vetorial em arquivo EPS ''%s''...\n', epsfilename );
print(epsfilename, '-depsc2');



clf
hold on

iDouble = double (iEsv)
x = 0:0.1:iDouble;
plot([0,iDouble],[vMax,vMax], 'r--', 'color','g')
plot([0,iDouble],[v0,v0], 'r--', 'color','b')
plot([iDouble,iDouble],[0,vMax], 'r--')
plot(x,yEsv(x))
xlabel ("t [min]");
ylabel ("V(t) [L]");

hold off;
shg;

epsfilename = 'Esvaziamento';
fprintf('Gerando grafico vetorial em arquivo EPS ''%s''...\n', epsfilename );
print(epsfilename, '-depsc2');

clf
hold on

iDouble = 500
x = 0:0.1:iDouble;
plot([0,iDouble],[vMax,vMax], 'r--', 'color','g')
plot([0,iDouble],[v0,v0], 'r--', 'color','b')

%Por algum motivo, quando tento plotar como os outros demora muito tempo
%Imagino que seja porque yConst nao depende de t é apenas @()2000, nao @(t)2000
plot([0,iDouble],[yConst(),yConst()], '-', 'color', 'k')

ylim([0,vMax])
xlabel ("t [min]");
ylabel ("V(t) [L]");

hold off;
shg;

epsfilename = 'Constante';
fprintf('Gerando grafico vetorial em arquivo EPS ''%s''...\n', epsfilename );
print(epsfilename, '-depsc2');

