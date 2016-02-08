clear all
%% 6.1 Dot gain and Murray-Davies
load('Magenta.mat');

figure;
plot(Spec_150(1,:), 'b')
hold on;
plot(Spec_150(20,:), 'g')
plot(Spec_300(20,:), 'gx')
plot(Spec_600(20,:), 'g--')

% 50%!
plot(Spec_150(20,:) * An(13) + (1 - An(13)) * Spec_150(1,:), 'r--')
plot(Spec_300(20,:) * An(13) + (1 - An(13)) * Spec_300(1,:), 'm--')
plot(Spec_600(20,:) * An(13) + (1 - An(13)) * Spec_600(1,:), 'k--')
plot(Spec_150(13,:), 'rx')
plot(Spec_300(13,:), 'mx')
plot(Spec_600(13,:), 'kx')

%% 6.2 Effective ink coverage
figure;
hold on;
a_eff = zeros(size(Spec_150));
for i = 1:size(Spec_150, 1);
    a_eff(i,:) = (Spec_150(i,:) - Spec_150(1,:)) ./ (Spec_150(20,:) - Spec_150(1,:));
    legendInfo{i} = ['X = ' num2str(An(i) * 100) '%'];
end;
plot(a_eff');
legend(legendInfo);
