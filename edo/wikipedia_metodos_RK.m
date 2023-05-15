butcher.isEmbedded = false;
s = 2; 
butcher.a = zeros(s,s);
a = 2/3;
b2 = 1/(2*a);
b1 = 1-b2;
butcher.a(2,1) = a; %butcher.a(2,2) = a;
butcher.b = [ b1 b2 ];
butcher.c = [ 0 a ];

f = @(x, y) tan(y) + 1;
x0 = 1;
y0 = 1;
h = 0.025;
n = 4;


fprintf('R-K de segunda ordem, usando tableau de Butcher:\n');
[X,Y,~] = RungeKutta(f, x0, y0, h, n, butcher, s );
fmt = '%.9f';
printTabXY( X, 'X', Y, 'Y', fmt, 'R.-K. de ordem 2 com alpha=2/3' );

