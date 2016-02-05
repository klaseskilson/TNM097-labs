clear all
%% 1.1 Compute RGB for chips20.mat

load('chips20.mat');
load('Ad.mat');
load('illum.mat', 'CIED65');

illum = repmat(CIED65, size(chips20, 1), 1);
rgb_raw = (illum .* chips20) * Ad;

%% 2.1 Compute normalization factors
e = ones(1, 61);
norm_fact = (CIED65 .* e) * Ad;

%% 2.2 Compute calibrated device-dependent RGB data
big_norm_fact = repmat(norm_fact, size(chips20, 1), 1);
rgb_cal = rgb_raw ./ big_norm_fact;

%% 3.1 Calculate XYZ and Lab data
load('M_XYZ2RGB.mat');
m_rgb2xyz = inv(M_XYZ2RGB);
xyz_cal = zeros(size(rgb_cal));
for i = 1:size(rgb_cal, 1)
    xyz_cal(i, 1:3) = m_rgb2xyz * rgb_cal(i, 1:3)';
end

% calculate reference xyz
xyz_ref = zeros(size(rgb_cal));
for i = 1:size(chips20, 1)
    xyz_ref(i, 1:3) = colorsignal2xyz(chips20(i, 1:61), CIED65);
end

% calculate lab data
xyz_d65 = [95, 100, 109];
lab_cal = zeros(size(rgb_cal));
lab_ref = zeros(size(rgb_cal));
for i = 1:size(rgb_cal, 1)
    lab_cal(i, 1:3) = xyz2lab(xyz_cal(i, 1:3), xyz_d65);
    lab_ref(i, 1:3) = xyz2lab(xyz_ref(i, 1:3), xyz_d65);
end

% calculate euclidean distance
diff = sqrt(sum((lab_cal - lab_ref) .^ 2, 2));
max_diff = max(diff)
mean_diff = mean(diff)
median_diff = median(diff)

%% 3.2 Calculate better A!
a = pinv(rgb_cal) * xyz_ref;

xyz_better = zeros(size(rgb_cal));
lab_better = zeros(size(rgb_cal));
for i = 1:size(rgb_cal, 1)
    xyz_better(i, 1:3) = a * rgb_cal(i, 1:3)';
    lab_better(i, 1:3) = xyz2lab(xyz_better(i, 1:3), xyz_d65);
end

% calculate euclidean distance
diff = sqrt(sum((lab_better - lab_ref) .^ 2, 2));
max_diff = max(diff)
mean_diff = mean(diff)
median_diff = median(diff)

%% 3.3 Use polynomial regression!
w = Optimize_poly(rgb_cal', xyz_ref');
xyz_poly = Polynomial_regression(rgb_cal', w)';

lab_poly = zeros(size(xyz_poly));
for i = 1:size(rgb_cal, 1)
    lab_poly(i, 1:3) = xyz2lab(xyz_poly(i, 1:3), xyz_d65);
end

% calculate euclidean distance
diff = sqrt(sum((lab_poly - lab_ref) .^ 2, 2));
max_diff = max(diff)
mean_diff = mean(diff)
median_diff = median(diff)

%% 4.1 Spectral forward model for DLP output
load('DLP.mat');
load('xyz.mat');
s_rgb = rgb_raw * DLP';

% prepare for xyz conversion
dlp_proj = sum(DLP, 2);
xyz_proj = colorsignal2xyz(ones(1,61), dlp_proj);

% calculate normalization factor
k = 100 / (dlp_proj' * xyz(:,2));

% convert to xyz
xyz_dlp = zeros(size(rgb_raw));
lab_dlp = zeros(size(rgb_raw));
for i=1:size(rgb_raw, 1)
    % apply xyz matrix to rgb spectral values
    xyz_dlp(i,:) = s_rgb(i,:) * xyz;
    % apply k
    xyz_dlp(i,:) = xyz_dlp(i,:) .* k;
    % convert to rgb
    lab_dlp(i,:) = xyz2lab(xyz_dlp(i,:), xyz_proj);
end

% calculate euclidean distance
diff = sqrt(sum((lab_dlp - lab_ref) .^ 2, 2));
max_diff = max(diff)
mean_diff = mean(diff)
median_diff = median(diff)

%% 4.2 SFM with calibrated rgb values
s_rgb_cal = rgb_cal * DLP';

% convert to xyz
xyz_dlp_cal = zeros(size(rgb_cal));
lab_dlp_cal = zeros(size(rgb_cal));
for i=1:size(rgb_cal, 1)
    % apply xyz matrix to rgb spectral values
    xyz_dlp_cal(i,:) = s_rgb_cal(i,:) * xyz;
    % apply k
    xyz_dlp_cal(i,:) = xyz_dlp_cal(i,:) .* k;
    % convert to rgb
    lab_dlp_cal(i,:) = xyz2lab(xyz_dlp_cal(i,:), xyz_proj);
end

% calculate euclidean distance
diff = sqrt(sum((lab_dlp_cal - lab_ref) .^ 2, 2));
max_diff = max(diff)
mean_diff = mean(diff)
median_diff = median(diff)

%% 5.1 Output device model
A_crt = zeros(3,3);

A_crt(1,:) = (DLP' * xyz(:,1))';
A_crt(2,:) = (DLP' * xyz(:,2))';
A_crt(3,:) = (DLP' * xyz(:,3))';
A_crt = A_crt .* k;

%% 5.2 
rgb_better_proj = zeros(size(rgb_cal));
xyz_better_proj = zeros(size(rgb_cal));
lab_better_proj = zeros(size(rgb_cal));
proj_spectra = zeros(size(chips20));
for i = 1:size(rgb_cal, 1)
    rgb_better_proj(i, :) = (inv(A_crt) * xyz_poly(i, :)')';
    % apply xyz (CMF) to new spectral values
    proj_spectra(i, :) = rgb_better_proj(i,:) * DLP';
    xyz_better_proj(i, :) = proj_spectra(i, :) * xyz .* k;
    lab_better_proj(i, :) = xyz2lab(xyz_better_proj(i, :), xyz_d65);
end

% calculate euclidean distance
diff = sqrt(sum((lab_better_proj - lab_ref) .^ 2, 2));
max_diff = max(diff)
mean_diff = mean(diff)
median_diff = median(diff)

%% 5.3 Plot and compare
figure;
spectra = (illum .* chips20);
plot(spectra(1,:), 'b--'); hold on;
plot(proj_spectra(1,:), 'b');
