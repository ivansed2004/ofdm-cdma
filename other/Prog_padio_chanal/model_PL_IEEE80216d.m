% model_PL_IEEE80216d.m
%
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
clear, clf, clc, close all
fc=900e6; htx=[30 30]; hrx=[2 10]; distance=[1:1000];
for k=1:2
y_IEEE16d(k,:)=PL_IEEE80216d(fc,distance,'A',htx(k),hrx(k),'atnt');
y_MIEEE16d(k,:)=PL_IEEE80216d(fc,distance,'A',htx(k),hrx(k),'atnt', 'mod');
end
subplot(121), semilogx(distance,y_IEEE16d(1,:),'b:','linewidth',2.5)
hold on, semilogx(distance,y_IEEE16d(2,:),'m-','linewidth',1.5)
grid on, axis([1 1000 10 150])
title(['IEEE 802.16d Path-loss Model, f_c=',num2str(fc/1e6),'MHz'])
xlabel('Distance[m]'), ylabel('Pathloss[dB]')
legend('h_{Tx}=30m, h_{Rx}=2m','h_{Tx}=30m, h_{Rx}=10m')
subplot(122), semilogx(distance,y_MIEEE16d(1,:),'b:','linewidth',2.5)
hold on, semilogx(distance,y_MIEEE16d(2,:),'m-','linewidth',1.5)
grid on, axis([1 1000 10 150])
title(['Modified IEEE 802.16d Path-loss Model, f_c=', num2str(fc/1e6), 'MHz'])
xlabel('Distance[m]'), ylabel('Pathloss[dB]')
legend('h_{Tx}=30m, h_{Rx}=2m','h_{Tx}=30m, h_{Rx}=10m')
%

