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