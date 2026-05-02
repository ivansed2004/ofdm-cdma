## Copyright (C) 2024
## This program is free software
## Author:  <vlsa@amd64comp>
## Created: 2024-05-11

function PL = PL_Hata (fc,d,htx,hrx,Etype)
% Модель потерь на трассе Окимура-Хата усоверш.
% Вх.параметры: fc -- несущая частота [Hz]
% d -- расстояние между базовой станцией и мобильной станцией [m]
% htx -- высота аннтены передатчика [m]
% hrx -- высота аннтены приемника [m]
% Etype -- тип местности(’urban-город’,’suburban-пригород’,’open area-открытое пр-во’)
% Вых.параметр: PL -- затухание [dB]
if nargin<5, Etype = 'URBAN'; endif
fc=fc/(1e6);
if fc>=150&&fc<=200, C_Rx = 8.29*(log10(1.54*hrx))^2 - 1.1;
elseif fc>200, C_Rx = 3.2*(log10(11.75*hrx))^2 - 4.97; % 1 ф-ла
else C_Rx = 0.8+(1.1*log10(fc)-0.7)*hrx-1.56*log10(fc); % 2 ф-ла
endif
PL=69.55+26.16*log10(fc)-13.82*log10(htx)-C_Rx+(44.9-6.55*log10(htx))*log10(d/1000); % 3 ф-ла
EType = upper(Etype);
if EType(1)=='S', PL = PL-2*(log10(fc/28))^2-5.4; % 4 ф-ла
elseif EType(1)=='O'
PL=PL+(18.33-4.78*log10(fc))*log10(fc)-40.97; % 5 ф-ла
end
endfunction
%
