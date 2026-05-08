clc;
close all;
clear all;

graphics_toolkit("fltk");

% параметры
mu1 = 3;
mu2 = 7;
sigma = 1.7;

% диапазон значений x
x = linspace(-3, 13, 500);

% гауссовские функции
f1 = (1 ./ sqrt(2*pi*sigma^2)) .* exp(-(x - mu1).^2 ./ (2*sigma^2));
f2 = (1 ./ sqrt(2*pi*sigma^2)) .* exp(-(x - mu2).^2 ./ (2*sigma^2));

% построение графика
plot(x, f1, 'b', 'LineWidth', 2); hold on;
plot(x, f2, 'r', 'LineWidth', 2);

% оформление
title('Функции правдоподобия');
xlabel('z');
ylabel('p(z|s)');
grid on;
set(gca, 'FontSize', 20);

hold off;
