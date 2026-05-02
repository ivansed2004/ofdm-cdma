clc;
close all;
clear all;

graphics_toolkit("fltk");

% 1. Считываем все данные из CSV в одну общую матрицу
strings = dlmread('biterrors.csv', ';');

% 2. Извлекаем первую строку в массив pSN
pSN = strings(1, :);

% 3. Извлекаем остальные строки
BitErrors = strings(2:end, :);

num_curves = size(BitErrors, 1);
% Устанавливаем порядок цветов для этих осей
set(gca, 'ColorOrder', jet(num_curves));
hold on;

fig1 = figure();
plot( pSN, BitErrors, 'linewidth', 2 );
xlabel('SNR (dB)'); ylabel('BitError'); title('Битовые ошибки, BER');
legend({'OFDM+QPSK', 'OFDM+CDMA(15)', 'OFDM+CDMA(31)', 'OFDM+CDMA(63)', 'OFDM+CDMA(127)', 'OFDM+CDMA(255)'},
       'location', 'northeast',
       'fontsize', 25);
grid on;
set(gca, 'FontSize', 25, 'yscale', 'log');
