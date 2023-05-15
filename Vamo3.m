clear

Qin=45;
Qout = 50;
dQ = Qin - Qout;

syms v(t);
%func = @(v,t) dQ;
t0 = 0; v0 = 2000; h = 0.5; n = 5; vMax = 5000;
at = [-1 3 -1 5];
odeTrans = diff(v, t)== dQ;
cond = v(t0)==v0;


odeEsv = diff(v, t)== dQ;

v = dsolve(odeEsv,cond);
yEsv=matlabFunction(v);


% Encontrando C(t)
syms c(t)
t0 = 0; C0 = 0.05; Cin = 2; h = 0.5; n = 5;
ode = diff(c, t) == (Qin*(Cin - c))/v
y = sym ('2');
cond = c(sym('0'))==C0;
c = dsolve(ode,cond);
cfunc=matlabFunction(c);

%Plot
Xx=0:0.5:400;
plot(Xx, cfunc(Xx))

syms m(t)

m = c*(Qin-Qout)+c*v
mfunc=matlabFunction(m);

Xx=0:0.5:400;
plot(Xx, mfunc(Xx))
ylim([0 5000])
