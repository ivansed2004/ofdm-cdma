## Copyright (C) 2024
## This program is free software
## Author:  <vlsa@amd64comp>
## Created: 2024-05-11

function PL = PL_free (fc,d,Gt,Gr)
% Модель потерь [дБ] на трассе в свободном пространстве
% Вх.параметры: fc -- несущая частота [Hz]
% d -- расстояние между базовой станцией и мобильной станцией [m]
% Gt и Gr -- усиление передающей и приемной аннтены
% выход: PL -- затухание [dB]
lamda = 3e8/fc; tmp = lamda./(4*pi*d);
if nargin>2, tmp = tmp*sqrt(Gt); endif
if nargin>3, tmp = tmp*sqrt(Gr); endif
PL = -20*log10(tmp); % осн.ф-ла
endfunction
