function Lab=xyz2lab(XYZ,XoYoZo)
% Lab=xyz2lab(XYZ,XoYoZo)
%
% XoYoZo = CIEXYZ-v�rden f�r vitpunkten (belysningen).
% XYZ = CIEXYZ-v�rden f�r f�rgen som ska konverteras till CIELAB-v�rden.
% Lab = CIELAB-v�rden f�r den konverterade f�rgen.
% Formlerna f�r konvertering �terfinns i laboration 3.
% Martin Solli, marso@itn.liu.se
% Link�pings Universitet, Sweden.
% September 2004
    
XYZrel(:,1) = XYZ(:,1) ./ XoYoZo(:,1);
XYZrel(:,2) = XYZ(:,2) ./ XoYoZo(:,2);
XYZrel(:,3) = XYZ(:,3) ./ XoYoZo(:,3);
fXYZ = XYZrel .^ (1/3);
[r, c] = find(XYZrel <= 0.008856);

if (r > 0)
    for n = 1:size(r, 1)
        fXYZ(r(n),c(n)) = 7.787 * XYZrel(r(n), c(n)) + 16 / 116;
    end
end

r2 = find(c==2);
L = 116 * fXYZ(:,2) - 16;
L(r(r2)) = 903.3 * XYZrel(r(r2), 2);
a = 500 * (fXYZ(:,1) - fXYZ(:,2));
b = 200 * (fXYZ(:,2) - fXYZ(:,3));
Lab = [L,a,b];
return;
