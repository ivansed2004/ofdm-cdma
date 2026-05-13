clc;
close all;
clear all;

graphics_toolkit("fltk");

addpath('gold');

m = 7; poly = [7, 1]; d = 13;
G = gold_code(m, poly, d);

ACF = cell(4, 1);  # Для хранения результатов АКФ
CCF = cell(12, 1); # Для хранения результатов ВКФ

k = 1;
for i = 1:1:size(G)(1)
  for j = 1:1:size(G)(1)
    if (i == j)
      [R, lag] = acf(G(i, :));
      ACF{i} = R;
    else
      [R, lag, ccfmax] = ccf(G(i, :), G(j, :));
      CCF{k} = R;
      k = k + 1;
    endif
  endfor
endfor

ACF_matrix = cell2mat(ACF);
CCF_matrix = cell2mat(CCF);

fig1 = figure();
plot( lag, ACF_matrix, 'linewidth', 2 );
xlabel('Lag'); ylabel('Estimate'); title('ACF');
grid on;
set(gca, 'FontSize', 25);

fig2 = figure();
plot( lag, CCF_matrix, 'linewidth', 2 );
xlabel('Lag'); ylabel('Estimate'); title('CCF');
grid on;
set(gca, 'FontSize', 25);
