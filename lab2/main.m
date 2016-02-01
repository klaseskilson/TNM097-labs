clear all
%% 1.1 Compute RGB for chips20.mat

load('chips20.mat');
load('Ad.mat');
load('illum.mat', 'CIED65');

illum = repmat(CIED65, size(chips20, 1), 1);
rgb_raw = (illum .* chips20) * Ad;

%% 2.1