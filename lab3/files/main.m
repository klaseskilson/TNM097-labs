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

pc = imread('peppers_color.tif');
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
