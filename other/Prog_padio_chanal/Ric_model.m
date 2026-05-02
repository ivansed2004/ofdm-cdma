## Copyright (C) 2024
## This program is free software
## Author:  <vlsa@amd64comp>
## Created: 2024-05-12

function H = Ric_model (K_dB,L)
% Модель канала Райса - LOS (Line-of-Sight) канал с прямой видимостью
% Вход: K_dB = K затухание на радиотрассе [dB]
% L = количество канальных реализаций
% Выход: H = вектор канальных реализаций
K = 10^(K_dB/10);
H = sqrt(K/(K+1)) + sqrt(1/(K+1))*Ray_model(L);
endfunction
