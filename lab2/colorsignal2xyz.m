function XYZ=colorsignal2xyz(reflectance,illumination) 
% XYZ=colorsignal2xyz(reflectance,illumination) 
% 
% reflectance = Reflektansspektra 
% illumination = Belysningens spektralfördelning 
% XYZ = CIEXYZ-värden 
% 
% Reflektansspektra multipliceras med belysningens spektralfördelning 
% och översätts sedan med hjälp av CIE:s standardobservatör till 
% CIEXYZ-värden. Observatören återfinns i filen "xyz.mat". Glöm inte 
% att beräkna k-värdet för belysningen och skala CIEXYZ-värdena med 
% erhållet k-värde! (Formler för detta återfinns i laboration 3) 
% 
% Om CIEXYZ-värden ska beräknas för en belysning så kan 
% reflektanspektrat ersättas med ettor (full reflektans i alla 
% våglängder). 
% Ex: reflectance = ones(1,61); 
 
% Martin Solli, marso@itn.liu.se
% ITN, Linköpings Universitet

load 'xyz.mat';

if (size(reflectance, 1) == 61)
    reflectance = reflectance';
end;
if (size(illumination,1) == 61)
    illumination = illumination';
end;

colorsignal = reflectance * diag(illumination);
XYZ = colorsignal * xyz;
k = 100 / (illumination * xyz(:,2));
XYZ = XYZ .* k;
return;
