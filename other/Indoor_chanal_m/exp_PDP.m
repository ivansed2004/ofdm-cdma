## Copyright (C) 2024
## This program is free software
## Author:  <vlsa@amd64comp>
## Created: 2024-05-26

function PDP = exp_PDP (tau_d,Ts,A_dB,norm_flag)
% Экспоненциальный генератор PDP
% Входн.данные:
% tau_d --- среднеквадратичный разброс задержки (rms delay spread) [sec]
% Ts --- период выборки (Sampling time) [sec]
% A_dB --- наименьшая допустимая мощность (smallest noticeable power) [dB]
% norm_flag --- нормированная общая мощность (normalize total power to unit)
% Выход:
% PDP --- профиль задержки мощности (PDP - power delay profile vector)
if nargin<4, norm_flag=1; endif  % нормирование
if nargin<3, A_dB=-20; endif     % 20dB ниже
sigma_tau=tau_d; A=10^(A_dB/10);
lmax=ceil(-tau_d*log(A)/Ts); % ф-ла (2.2)
% вычисляем коэффициент нормирования для нормированной мощности
if norm_flag
p0=(1-exp(-Ts/sigma_tau))/(1-exp(-(lmax+1)*Ts/sigma_tau)); % ф-ла(2.4)
else p0=1/sigma_tau;
endif
% Экспоненциальный PDP
l=0:lmax; PDP = p0*exp(-l*Ts/sigma_tau); % ф-ла(2.5)
endfunction
%
