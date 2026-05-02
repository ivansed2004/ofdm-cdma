clc;
close all;
clear all;

addpath('gold');

init = [0, 1, 1];
m_seq = lfsr_sequence(init, [1]);
m_seq_dec = decimation(m_seq, 3);

[R, lag, ccfmax] = ccf( m_seq, m_seq_dec );
figure();
plot(lag, R, "linewidth", 3);
hold on;
xlims = xlim();
line(xlims, [ccfmax, ccfmax], 'linewidth', 2, 'Color', 'magenta', 'LineStyle', '-.');
hold off;
title( 'ACF/CCF' );
xlabel('Lag time');
ylabel('Estimate');
set(gca, 'FontSize', 20);
grid on;

ccfmax * (2^(length(init))-1)
