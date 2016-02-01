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
