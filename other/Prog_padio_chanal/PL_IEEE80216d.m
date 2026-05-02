## Copyright (C) 2024
## This program is free software
## Author:  <vlsa@amd64comp>
## Created: 2024-05-12

function PL = PL_IEEE80216d (fc,d,type,htx,hrx,corr_fact,mod)
% модель IEEE 802.16d
% Вх.параметры: fc -- несущая частота [Hz]
% d -- расстояние между базовой станцией и мобильной станцией [m]
% type -- выбрать 'A', 'B', или 'C'
% htx -- высота аннтены передатчика [m]
% hrx -- высота аннтены приемника [m]
% corr_fact -- для затененной радиотрассы указать модель 'ATNT' (классика)
% или 'OKUMURA' (Окумура-Хата), для прямой видимости указать 'NO'
% mod -- указать 'MOD' для усовершенствованной модели IEEE 802.16d
% Вых.параметр: PL -- затухание на радиотрассе [dB]
Mod='UNMOD';
if nargin>6, Mod=upper(mod); endif
 if nargin==6&&corr_fact(1)=='m', Mod='MOD'; corr_fact='NO';
 elseif nargin<6, corr_fact='NO';
  if nargin==5&&hrx(1)=='m', Mod='MOD'; hrx=2;
  elseif nargin<5, hrx=2;
   if nargin==4&&htx(1)=='m', Mod='MOD'; htx=30;
   elseif nargin<4, htx=30;
    if nargin==3&&type(1)=='m', Mod='MOD'; type='A';
    elseif nargin<3, type='A';
    endif
   endif
  endif
 endif
%
d0 = 100;
Type = upper(type);
if Type~='A'&& Type~='B'&&Type~='C'
disp('Error: The selected type is not supported'); return;
endif
switch upper(corr_fact)
  case 'ATNT', PLf=6*log10(fc/2e9); % ф-ла(1.13)
               PLh=-10.8*log10(hrx/2); % ф-ла(1.14)
  case 'OKUMURA', PLf=6*log10(fc/2e9); % ф-ла(1.13)
       if hrx<=3, PLh=-10*log10(hrx/3); % ф-ла(1.15)
             else PLh=-20*log10(hrx/3);
       endif
  case 'NO', PLf=0; PLh=0;
endswitch
if Type=='A', a=4.6; b=0.0075; c=12.6; % ф-ла(1.3)
  elseif Type=='B', a=4; b=0.0065; c=17.1;
    else a=3.6; b=0.005; c=20;
endif
lamda=3e8/fc; gamma=a-b*htx+c/htx; d0_pr=d0; % ф-ла(1.12)
if Mod(1)=='M'
   d0_pr=d0*10^-((PLf+PLh)/(10*gamma)); % ф-ла(1.17)
endif
A = 20*log10(4*pi*d0_pr/lamda) + PLf + PLh;
for k=1:length(d)
  if d(k)>d0_pr, PL(k) = A + 10*gamma*log10(d(k)/d0); % ф-ла(1.18)
  else PL(k) = 20*log10(4*pi*d(k)/lamda);
  endif
endfor
endfunction
