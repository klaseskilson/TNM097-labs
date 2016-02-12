clear all;
%% 1 Color gamut

load('DLP.mat');
load('xyz.mat');
XYZdlp = sum(DLP, 2)' * xyz;

load('Dell.mat');
load('Inkjet.mat');

plot_chrom(XYZdlp', 'r');
hold on;
plot_chrom(XYZdell, 'g');
plot_chrom(XYZinkjet, 'b');

%% 2.1.1 Mathematical metrics - grayscale image - interpolation

p = im2double(imread('peppers_gray.tif'));
p_nearest = imresize(imresize(p,0.25,'nearest'),4,'nearest');
p_bilinear = imresize(imresize(p,0.25,'bilinear'),4,'bilinear');
p_bicubic = imresize(imresize(p,0.25,'bicubic'),4,'bicubic');

MSE_nearest = mean(mean((p - p_nearest).^2));
MSE_bilinear = mean(mean((p - p_bilinear).^2));
MSE_bicubic = mean(mean((p - p_bicubic).^2));

SNR_nearest = snr(p, p - p_nearest);
SNR_bilinear = snr(p, p - p_bilinear);
SNR_bicubic = snr(p, p - p_bicubic);

subplot(2,2,1), imshow(p)
subplot(2,2,2), imshow(p_nearest)
subplot(2,2,3), imshow(p_bilinear)
subplot(2,2,4), imshow(p_bicubic)

%% 2.1.2 Grayscale image halftoning

p_thresh = double(p >= 0.5);
p_dither = double(dither(p));

MSE_dither = mean(mean((p - p_dither).^2));
MSE_thresh = mean(mean((p - p_thresh).^2));

SNR_dither = snr(p, p - p_dither);
SNR_thresh = snr(p, p - p_thresh);

subplot(1,2,1), imshow(p_thresh)
subplot(1,2,2), imshow(p_dither)

%% 2.2 Color image

pc = im2double(imread('peppers_color.tif'));
pc_lab = rgb2lab(pc);

pc_thresh(:,:,1) = pc(:,:,1) >= 0.5;
pc_thresh(:,:,2) = pc(:,:,2) >= 0.5;
pc_thresh(:,:,3) = pc(:,:,3) >= 0.5;
pc_thresh = double(pc_thresh);

pc_dither(:,:,1) = dither(pc(:,:,1));
pc_dither(:,:,2) = dither(pc(:,:,2));
pc_dither(:,:,3) = dither(pc(:,:,3));
pc_dither = double(pc_dither);

pc_thresh_lab = rgb2lab(pc_thresh);
pc_dither_lab = rgb2lab(pc_dither);

diff_thresh = sqrt(sum((pc_thresh_lab - pc_lab) .^ 2, 2));
diff_dither = sqrt(sum((pc_dither_lab - pc_lab) .^ 2, 2));

diff_thresh_max = max(diff_thresh(:));
diff_thresh_mean = mean(diff_thresh(:));
diff_dither_max = max(diff_dither(:));
diff_dither_mean = mean(diff_dither(:));
disp(['thresh max: ' num2str(diff_thresh_max) ' mean: ' num2str(diff_thresh_mean)])
disp(['dither max: ' num2str(diff_dither_max) ' mean: ' num2str(diff_dither_mean)])

subplot(1,3,1), imshow(pc);
subplot(1,3,2), imshow(pc_thresh);
subplot(1,3,3), imshow(pc_dither);

%% 3 Mathematical metrics involving HVS

% grayscale!
SNRfilter_dither = snr_filter(p, p - p_dither);
SNRfilter_thresh = snr_filter(p, p - p_thresh);

% color!
pc_hvs = rgb_filter(pc);
pc_thresh_hvs = rgb_filter(pc_thresh);
pc_dither_hvs = rgb_filter(pc_dither);

pc_hvs_lab = rgb2lab(pc_hvs);
pc_thresh_hvs_lab = rgb2lab(pc_thresh_hvs);
pc_dither_hvs_lab = rgb2lab(pc_dither_hvs);

subplot(1,4,1), imshow(pc);
subplot(1,4,2), imshow(pc_hvs);
subplot(1,4,3), imshow(pc_thresh_hvs);
subplot(1,4,4), imshow(pc_dither_hvs);

% calc delta e
diff_thresh_hsv = sqrt(sum((pc_thresh_hvs_lab - pc_hvs_lab) .^ 2, 2));
diff_dither_hsv = sqrt(sum((pc_dither_hvs_lab - pc_hvs_lab) .^ 2, 2));

diff_thresh_hsv_max = max(diff_thresh_hsv(:));
diff_thresh_hsv_mean = mean(diff_thresh_hsv(:));
diff_dither_hsv_max = max(diff_dither_hsv(:));
diff_dither_hsv_mean = mean(diff_dither_hsv(:));
disp(['thresh max: ' num2str(diff_thresh_hsv_max) ' mean: ' num2str(diff_thresh_hsv_mean)])
disp(['dither max: ' num2str(diff_dither_hsv_max) ' mean: ' num2str(diff_dither_hsv_mean)])
disp('Oh! Piece of candy!');

%% 4.1 S-CIELab as a full-reference metric

addpath('scielab');
wp = [95.047 100.00 108.883];
pc_bicubic = imresize(imresize(pc,0.25,'bicubic'),4,'bicubic');
pc_nearest = imresize(imresize(pc,0.25,'nearest'),4,'nearest');
pc_bilinear = imresize(imresize(pc,0.25,'bilinear'),4,'bilinear');
pc_xyz = rgb2xyz(pc, 'WhitePoint', wp);
pc_bicubic_xyz = rgb2xyz(pc_bicubic, 'WhitePoint', wp);
pc_nearest_xyz = rgb2xyz(pc_nearest, 'WhitePoint', wp);
pc_bilinear_xyz = rgb2xyz(pc_bilinear, 'WhitePoint', wp);

ppi = 72;
distance = 500 / 25.4;
sampPerDeg = ppi * distance * tan(pi/180);

scie_bicubic = scielab(sampPerDeg, pc_xyz, pc_bicubic_xyz, wp, 'xyz');
scie_nearest = scielab(sampPerDeg, pc_xyz, pc_nearest_xyz, wp, 'xyz');
scie_bilinear = scielab(sampPerDeg, pc_xyz, pc_bilinear_xyz, wp, 'xyz');

scie_bicubic_mean = mean(scie_bicubic(:));
scie_nearest_mean = mean(scie_nearest(:));
scie_bilinear_mean = mean(scie_bilinear(:));

disp([num2str(scie_nearest_mean) ' nearest ' num2str(scie_bilinear_mean) ' bilinear ' num2str(scie_bicubic_mean) ' bicubic'])

subplot(2,2,1), imshow(pc);
subplot(2,2,2), imshow(pc_nearest);
subplot(2,2,3), imshow(pc_bilinear);
subplot(2,2,4), imshow(pc_bicubic);

figure;
subplot(1,3,1), imshow(uint8(scie_nearest));
subplot(1,3,2), imshow(uint8(scie_bilinear));
subplot(1,3,3), imshow(uint8(scie_bicubic));

%% 4.2 S-CIELab as a no-reference metric

load('colorhalftones.mat');

c1_xyz = rgb2xyz(c1, 'WhitePoint', wp);
c2_xyz = rgb2xyz(c2, 'WhitePoint', wp);
c3_xyz = rgb2xyz(c3, 'WhitePoint', wp);
c4_xyz = rgb2xyz(c4, 'WhitePoint', wp);
c5_xyz = rgb2xyz(c5, 'WhitePoint', wp);
c1_scie = scielab(sampPerDeg, c1_xyz);
c2_scie = scielab(sampPerDeg, c2_xyz);
c3_scie = scielab(sampPerDeg, c3_xyz);
c4_scie = scielab(sampPerDeg, c4_xyz);
c5_scie = scielab(sampPerDeg, c5_xyz);

c1_std = std(c1_scie(:));
c2_std = std(c2_scie(:));
c3_std = std(c3_scie(:));
c4_std = std(c4_scie(:));
c5_std = std(c5_scie(:));

disp(['c1 std: ' num2str(c1_std) ' c2 std: ' num2str(c2_std) ' c3 std: ' num2str(c3_std) ' c4 std: ' num2str(c4_std) ' c5 std: ' num2str(c5_std)])

subplot(2, 3, 1), imshow(c1);
subplot(2, 3, 2), imshow(c2);
subplot(2, 3, 3), imshow(c3);
subplot(2, 3, 4), imshow(c4);
subplot(2, 3, 5), imshow(c5);

