function Lab=xyz2lab(XYZ,XoYoZo)
% Lab=xyz2lab(XYZ,XoYoZo)
%
% XoYoZo = CIEXYZ-värden för vitpunkten (belysningen).
% XYZ = CIEXYZ-värden för färgen som ska konverteras till CIELAB-värden.
% Lab = CIELAB-värden för den konverterade färgen.
% Formlerna för konvertering återfinns i laboration 3.
% Martin Solli, marso@itn.liu.se
% Linköpings Universitet, Sweden.
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
