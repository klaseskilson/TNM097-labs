function [L,a,b]=xyz2lab(x,y,z)

Xn = 95.05;
Yn = 100.00;
Zn = 108.89;

ylim = Yn*0.008856;
L = (y>ylim).*(116*(y/Yn).^(1/3)-16)+(y<=ylim).*(903.3*y/Yn);
ytemp = foo(y/Yn);
a = 500*(foo(x/Xn)-ytemp);
b = 200*(ytemp-foo(z/Zn));

