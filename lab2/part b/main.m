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
coverage_150 = zeros(size(Spec_150));
coverage_300 = zeros(size(Spec_150));
coverage_600 = zeros(size(Spec_150));
for i = 1:size(coverage_150, 1);
    coverage_150(i,:) = (Spec_150(i,:) - Spec_150(1,:)) ./ (Spec_150(20,:) - Spec_150(1,:));
    coverage_300(i,:) = (Spec_300(i,:) - Spec_300(1,:)) ./ (Spec_300(20,:) - Spec_300(1,:));
    coverage_600(i,:) = (Spec_600(i,:) - Spec_600(1,:)) ./ (Spec_600(20,:) - Spec_600(1,:));
    legendInfo{i} = ['X = ' num2str(An(i) * 100) '%'];
end;

plot(coverage_150');
legend(legendInfo);

%% 6.3 Total dot gain
figure;
hold on;
selected_wl = 20;
total_gain_150 = coverage_150(:, selected_wl) - An';
total_gain_300 = coverage_300(:, selected_wl) - An';
total_gain_600 = coverage_600(:, selected_wl) - An';
plot(An, total_gain_150);
plot(An, total_gain_300, 'x');
plot(An, total_gain_600, '--');
plot(An, An - An)
legend('150 dpi', '300 dpi', '600 dpi', 'An');

%% 7.1 Dot gain compensation
close all;
a_eff = coverage_150(:, selected_wl);
pup = double(rgb2gray(imread('puppy.jpg')));
pup = pup / max(pup(:));
pup_out = 1 - interp1(a_eff, An, 1 - pup);
figure;
subplot(1,2,1), imshow(pup);
subplot(1,2,2), imshow(pup_out);

%% 8.1 Color prediction
load('CM.mat');

frac_w = (1 - rand150(:,4)) .* (1 - rand150(:,5));
frac_c = rand150(:,4) .* (1 - rand150(:,5));
frac_m = (1 - rand150(:,4)) .* rand150(:,5);
frac_b = rand150(:,4) .* rand150(:,5);

paper = c150(1, 1:3);
cyan = c150(21, 1:3);
magenta = m150(21, 1:3);
blue = b150(21, 1:3);

predic = frac_w * paper + frac_c * cyan + frac_m * magenta + frac_b * blue;
predic_lab = xyz2lab(predic, paper);
rand_lab = xyz2lab(rand150(:, 1:3), paper);

diff = sqrt(sum((predic_lab - rand_lab) .^ 2, 2));
max_diff = max(diff)
mean_diff = mean(diff)

%% 8.2 
