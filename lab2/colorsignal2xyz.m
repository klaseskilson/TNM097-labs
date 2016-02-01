function XYZ=colorsignal2xyz(reflectance,illumination) 
% XYZ=colorsignal2xyz(reflectance,illumination) 
% 
% reflectance = Reflektansspektra 
% illumination = Belysningens spektralf�rdelning 
% XYZ = CIEXYZ-v�rden 
% 
% Reflektansspektra multipliceras med belysningens spektralf�rdelning 
% och �vers�tts sedan med hj�lp av CIE:s standardobservat�r till 
% CIEXYZ-v�rden. Observat�ren �terfinns i filen "xyz.mat". Gl�m inte 
% att ber�kna k-v�rdet f�r belysningen och skala CIEXYZ-v�rdena med 
% erh�llet k-v�rde! (Formler f�r detta �terfinns i laboration 3) 
% 
% Om CIEXYZ-v�rden ska ber�knas f�r en belysning s� kan 
% reflektanspektrat ers�ttas med ettor (full reflektans i alla 
% v�gl�ngder). 
% Ex: reflectance = ones(1,61); 
 
color = reflectance.*illumination;
