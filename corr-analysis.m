% Скрипт для генерации новых АКФ и ВКФ по исходным данным
clc;
close all;
clear all;

graphics_toolkit("fltk");

addpath('gold');

% Исходые данные
% 1. Полином, порождающий ПСП
% старшая степень полинома
m = 3;
% степени полинома с единичным коэффициентом
poly = [3, 1];
% 2. Коэффициент децимации
d = 3;

% Матрица кодов Голда
G = gold_code(m, poly, d);
% Замена 0 на 1, 1 на -1
G = 1 - 2*G;

% Для хранения результатов АКФ
ACF = cell(2^m + 1, 1);
% Для хранения результатов ВКФ
CCF = cell((2^m + 1)^2-(2^m + 1), 1);

% Оценка АКФ и ВКФ для всех возможных комбинаций
k = 1;
for i = 1:1:size(G)(1)
  for j = 1:1:size(G)(1)
    if (i == j)
      [R, lag] = acf(G(i, :));
      ACF{i} = R;
    else
      [R, lag] = ccf(G(i, :), G(j, :));
      CCF{k} = R;
      k = k + 1;
    endif
  endfor
endfor

% Преобразование cell в матрицу
ACF_matrix = cell2mat(ACF);
CCF_matrix = cell2mat(CCF);

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
text(3.2, acfmax+1, ['Макс. бокового лепестка АКФ = ', num2str(acfmax)], 'Color', 'b', 'FontSize', 15);
grid on;
set(gca, 'FontSize', 20);
print(["acf-", num2str((r-1)/2), ".pdf"], "-S800,600", "-dpdf");

fig2 = figure();
plot( lag, CCF_matrix, 'linewidth', 2 );
xlabel('Сдвиг'); ylabel('Оценка корреляции'); title(['ВКФ-', num2str((r-1)/2)]);
line([-3*(r-1)/2, 3*(r-1)/2], [ccfmax, ccfmax], 'Color', 'b', 'LineWidth', 1);
text(3.2, ccfmax+1, ['Макс. бокового лепестка ВКФ = ', num2str(ccfmax)], 'Color', 'b', 'FontSize', 15);
grid on;
set(gca, 'FontSize', 20);
print(["ccf-", num2str((r-1)/2), ".pdf"], "-S800,600", "-dpdf");
