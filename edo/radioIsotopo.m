
%%% export Python=/bin/python
%%% export PYTHON=/bin/python

%%% export Python=/usr/bin/python3
%%% export PYTHON=/usr/bin/python3

%%% pip install --user sympy==1.5.1

%%% octave:1> pkg install -forge symbolic


clear all;

addpath(['../' 'util'], ['../' 'edo']);

is_octave = (exist('OCTAVE_VERSION','builtin')>1); % Octave ou Matlab
if is_octave
	pkg load symbolic;
end;


% Agora (Versão >= 5.2.0) funciona com estes símbolos
syms N(t) lambda t0 N0
ode = diff(N, t) == -lambda * N

%syms y(x) lambda
%ode = diff(y, x) == -lambda * y
sol = dsolve(ode)

sol = dsolve(ode, N(t0)==N0)

F = sol;
f = matlabFunction(F);
%disp('y: EDO='); ode
%disp('y(x)='); f
disp('N: EDO='); ode
disp('N(t)='); f


tt = 0:0.1:5;
t0 = 0;
N0 = 100;
lambda = 0.5;
NN = f(N0, lambda, tt, t0);


hold on
leg = {};
tt = 0:0.01:5;

clf
hold on
leg = {};

lambda = [10 5 1 0.5 0.1];
for i=1:length(lambda)
	NN = f(N0, lambda(i), tt, t0);
	plot(tt, NN, 'linewidth', 1);
	leg{end+1} = sprintf('N(t) = %.2f exp(-%.2f * t)', N0, lambda(i));
end

fontsize = 16;
title({'EDO: dN(t)/dt = -\lambda * N(t)', 'Valor inicial: N(0)=N_{0}',...
       'Solução: N(t) = N_{0} exp(-\lambda t)'}, 'fontsize', fontsize);

hold off;
legend(leg, 'fontsize', fontsize);

shg;
