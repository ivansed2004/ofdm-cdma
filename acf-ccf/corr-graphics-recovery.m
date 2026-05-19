clc;
close all;
clear all;

graphics_toolkit("fltk");

% Чтение из бинарного файла
load('acf-127.bin');
load('ccf-127.bin');

r = size(ACF_matrix)(2);
lag = -(r-1)/2:1:(r-1)/2;

% Поиск максимального уровня бокового лепестка АКФ
max_val = max(ACF_matrix(:));
temp = ACF_matrix;
temp(temp == max_val) = -Inf;
acfmax = max(temp(:));

% Поиск максимального уровеня бокового лепестка ВКФ
ccfmax = max(CCF_matrix(:));

% Вывод результатов
fig1 = figure();
plot( lag, ACF_matrix, 'linewidth', 2 );
xlabel('Сдвиг'); ylabel('Оценка корреляции'); title(['АКФ-', num2str((r-1)/2)]);
line([-3*(r-1)/2, 3*(r-1)/2], [acfmax, acfmax], 'Color', 'b', 'LineWidth', 1);
text(3.2, acfmax+1, ['Макс. бокового лепестка = ', num2str(acfmax)], 'Color', 'b', 'FontSize', 15);
grid on;
set(gca, 'FontSize', 20);
print(["acf-", num2str((r-1)/2), ".pdf"], "-S800,600", "-dpdf");

fig2 = figure();
plot( lag, CCF_matrix, 'linewidth', 2 );
xlabel('Сдвиг'); ylabel('Оценка корреляции'); title(['ВКФ-', num2str((r-1)/2)]);
line([-3*(r-1)/2, 3*(r-1)/2], [ccfmax, ccfmax], 'Color', 'b', 'LineWidth', 1);
text(3.2, ccfmax+1, ['Макс. бокового лепестка = ', num2str(ccfmax)], 'Color', 'b', 'FontSize', 15);
grid on;
set(gca, 'FontSize', 20);
print(["ccf-", num2str((r-1)/2), ".pdf"], "-S800,600", "-dpdf");
