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
diff = sqrt(sum((lab_cal(:, 2:3) - lab_ref(:, 2:3)) .^ 2, 2));
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
diff = sqrt(sum((lab_better(:, 2:3) - lab_ref(:, 2:3)) .^ 2, 2));
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
diff = sqrt(sum((lab_poly(:, 2:3) - lab_ref(:, 2:3)) .^ 2, 2));
max_diff = max(diff)
mean_diff = mean(diff)
median_diff = median(diff)

%% 4.1 Spectral forward model
load('DLP.mat');
s_rgb = rgb_raw * DLP';

% prepare for xyz conversion
dlp_proj = sum(DLP, 2);
xyz_proj = colorsignal2xyz(ones(1,61), dlp_proj);

% convert to xyz
xyz_dlp = zeros(size(rgb_raw));
lab_dlp = zeros(size(rgb_raw));
for i=1:size(rgb_raw, 1)
    xyz_dlp(i,:) = colorsignal2xyz(s_rgb(i,:), dlp_proj);
    lab_dlp(i,:) = xyz2lab(xyz_dlp(i,:), xyz_proj);
end

% calculate euclidean distance
diff = sqrt(sum((lab_dlp(:, 2:3) - lab_ref(:, 2:3)) .^ 2, 2));
max_diff = max(diff)
mean_diff = mean(diff)
median_diff = median(diff)

%% 4.2 SFM with calibrated rgb values

