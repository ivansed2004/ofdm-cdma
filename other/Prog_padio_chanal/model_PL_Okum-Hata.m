% model_PL_Okum-Hata.m  Модель потерь на трассе Окимура-Хата усоверш.
% расчет затуханий на радиотрассе по усоверш. экспериментальной модели
% с учетом высот аннтен и зон покрытия
clear, clf, close all
fc=1.2e9; htx=20; hrx=2; distance=[1:2:31].^2;
y_urban=PL_Hata(fc,distance,htx,hrx,'urban');
y_suburban=PL_Hata(fc,distance,htx,hrx,'suburban');
y_open=PL_Hata(fc,distance,htx,hrx,'open');
semilogx(distance,y_urban,'m-s', distance,y_suburban,'k-o', distance,
y_open,'b-^')
title(['Okumura-Hata PL model, f_c=',num2str(fc/1e6),'MHz'])
xlabel('Distance[m]'), ylabel('Path loss[dB]')
legend('urban','suburban','open area'), grid on, axis([1 1000 10 110])
%
