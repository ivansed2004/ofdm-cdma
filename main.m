% Скрипт для генерации графиков BER(SNR) по ранее сгенерированным файлам biterrors.csv
clc;
close all;
clear all;

graphics_toolkit("fltk");

% Считываем все данные из CSV в одну общую матрицу
strings = dlmread('biterrors.csv');

% Извлекаем первую строку в массив pSN
pSN = strings(1, :);

% Извлекаем остальные строки
BitErrors = strings(2:end, :);
num_curves = size(BitErrors, 1);

% Устанавливаем порядок цветов для этих осей
set(gca, 'ColorOrder', jet(num_curves));
hold on;

fig1 = figure();
plot( pSN, BitErrors, 'linewidth', 3 );
xlabel('SNR (dB)'); ylabel('BitError'); title('Битовые ошибки, BER');
legend({'QPSK+OFDM', 'CDMA(31)+OFDM', 'CDMA(63)+OFDM', 'CDMA(127)+OFDM'},
       'location', 'northeast',
       'fontsize', 5);
grid on;
set(gca, 'FontSize', 20, 'yscale', 'log');

print("biterrors.pdf", "-S768,1024", "-dpdf");
