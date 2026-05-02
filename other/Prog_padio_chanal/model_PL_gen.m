% model_PL_gen.m
% расчет затуханий на радиотрассах в своб.пр-ве и с затенением (классика по ур-ю радиолокации)
% Вх.параметры: fc -- несущая частота [Hz]
% distance -- расстояние между базовой станцией и мобильной станцией [m]
% d0 -- эталонное (базовое) расстояние, когда потери = потерям в своб.пр-ве [m]
% n -- коэф.потерь по мере увеличения препятствий (равен 2 -когда своб.пр-во,
% 2.7–3.5 -когда сотовая радиосвязь в городских условиях,
% 3–5 -когда городская сотовая радиосвязь из зоны сложной тени,
% 1.6–1.8 -когда зона прямой видимости, но рядом в зоне есть здания,
% 4–6 -когда на трассе препятствие в виде высотного здания,
% 2–3 -когда на трассе препятствие в виде пром.зоны (завод или пром.предприятие).
% sigma -- дисперсия (рассеяние) [dB]
clear, clf, close all,
fc=1.2e9; d0=100; sigma=3; distance=[1:2:31].^2; % sigma=3 (для норм.распред.)
Gt=[1 1 0.5]; Gr=[1 0.5 0.5]; Exp=[2 3 6]; % Exp -- vector n (коэф.потерь по препятствиям)
for k=1:3
y_Free(k,:)=PL_free(fc,distance,Gt(k),Gr(k));
y_logdist(k,:)=PL_logdist_or_norm(fc,distance,d0,Exp(k));,
y_lognorm(k,:)=PL_logdist_or_norm(fc,distance,d0,Exp(1),sigma);
end
%
subplot(131), semilogx(distance,y_Free(1,:),'b-o', distance, y_Free(2,:),
'k-^', distance,y_Free(3,:),'m-s'), grid on, axis([1 1000 30 110]),
title(['Free Path-loss Model, f_c=',num2str(fc/1e6),'MHz'])
xlabel('Distance[m]'), ylabel('Path loss[dB]')
legend('G_t=1, G_r=1','G_t=1, G_r=0.5','G_t=0.5, G_r=0.5');
subplot(132)
semilogx(distance,y_logdist(1,:),'b-o', distance, y_logdist(2,:),'k-^',
distance,y_logdist(3,:),'m-s'), grid on, axis([1 1000 30 110]),
title(['Log-distance Path-loss Model, f_c=',num2str(fc/1e6),'MHz'])
xlabel('Distance[m]'), ylabel('Path loss[dB]')
legend('n=2','n=3','n=6');
subplot(133), semilogx(distance,y_lognorm(1,:),'b-o', distance, y_lognorm
(2,:),'k-^', distance,y_lognorm(3,:),'m-s')
grid on, axis([1 1000 30 110]),  legend('path 1','path 2','path 3');
title(['Log-normal Path-loss Model, f_c=',num2str(fc/1e6),'MHz,', ' \sigma=', num2str(sigma), 'dB, n=2'])
xlabel('Distance[m]'), ylabel('Path loss[dB]')


