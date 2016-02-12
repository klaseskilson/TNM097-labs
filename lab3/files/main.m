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

