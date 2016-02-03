clear all
%% 6.1 Dot gain and Murray-Davies
load('Magenta.mat');

figure;
plot(Spec_150(1,:), 'b')
hold on;
plot(Spec_150(13,:), 'r')
plot(Spec_150(20,:), 'g')
plot( Spec_150(20,:)*An(1) + (1-An(1)) * Spec_150(1,:), 'b--')

plot( Spec_150(20,:)*An(13) + (1-An(13)) * Spec_150(1,:), 'r--')
plot( Spec_150(20,:)*An(20) + (1-An(20)) * Spec_150(1,:), 'g--')

plot(Spec_300(13,:), 'mx')
plot(Spec_600(13,:), 'kx')