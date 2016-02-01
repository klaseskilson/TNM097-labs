function Lab=xyz2lab(XYZ,XoYoZo) 
% Lab=xyz2lab(XYZ,XoYoZo) 
% 
% XoYoZo = CIEXYZ-värden för vitpunkten (belysningen). 
% XYZ = CIEXYZ-värden för färgen som ska kopieras till CIELab-värden
% Lab = CIELAB-värden för den konverterade färgen. 

Xn = XoYoZo(1);
Yn = XoYoZo(2);
Zn = XoYoZo(3);

x = XYZ(1);
y = XYZ(2);
z = XYZ(3);

ylim = Yn*0.008856;
L = (y>ylim).*(116*(y/Yn).^(1/3)-16)+(y<=ylim).*(903.3*y/Yn);
ytemp = foo(y/Yn);
a = 500*(foo(x/Xn)-ytemp);
b = 200*(ytemp-foo(z/Zn));
