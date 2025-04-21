clear; clc; close all;

%% Load curves file
filename = 'Data/SensCurves_WRGBCMY.txt';
data = readmatrix(filename);

% Extract each color
wavelength = data(:,1);
R = data(:,2); 
G = data(:,3); 
B = data(:,4); 
C = data(:,5); 
M = data(:,6); 
Y = data(:,7); 

figure;
hold on;
plot(wavelength, R, 'r', 'LineWidth', 1.5);
plot(wavelength, G, 'g', 'LineWidth', 1.5);
plot(wavelength, B, 'b', 'LineWidth', 1.5);
plot(wavelength, C, 'c--', 'LineWidth', 1.5);
plot(wavelength, M, 'm--', 'LineWidth', 1.5);
plot(wavelength, Y, 'y--', 'LineWidth', 1.5);
hold off;

xlabel('Wavelength (nm)');
ylabel('Intensity');
title('RGB and CMY color curves by wavelength');
legend({'Red (R)', 'Green (G)', 'Blue (B)', 'Cyan (C)', 'Magenta (M)', 'Yellow (Y)'}, 'Location', 'Best');
grid on;
