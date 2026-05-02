## Copyright (C) 2024
## This program is free software
## Author:  <vlsa@amd64comp>
## Created: 2024-05-12

function H = Ray_model (L)
% Модель канала Рэлея - NLOS (Non Line-of-Sight) канал без прямой видимости
% Вход : L = Количество канальных реализаций
% Выход: H = вектор канальных реализаций
H = (randn(1,L)+j*randn(1,L))/sqrt(2);
endfunction
