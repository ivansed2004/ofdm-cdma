% model_Ray_Ric_channel.m
% оценка характера распределения сигнала в точке приема для радиоканала
% level -- это количество интервалов в гистограмме
clear, clf, close all
N=250000; level=30; K_dB=[-40 0 6 15];
gss=['k-s'; 'b-o'; 'g-^'; 'm-^'; 'r-^'];
% Модель Рэлея - NLOS (Non Line-of-Sight) канал без прямой видимости
% для чистой модели брать sigma (дисперсия) = 9 (распред. Рэлея)
Rayleigh_ch=Ray_model(N);
[temp,x]=hist(abs(Rayleigh_ch(1,:)),level);
plot(x,temp/1e4,gss(1,:)), hold on
% Модель Райса - LOS (Line-of-Sight) канал с прямой видимостью
% для модели LOS с затуханием >15dB брать sigma (дисперсия) = 3 (норм.распр.)
% для сложных моделей внести в пр-му затухания и посмотреть на хар-р распред.
% меняется от Рэлея - Хи-квадрат - нормальное (Гауссово)
for i=1:length(K_dB);
Rician_ch(i,:) = Ric_model(K_dB(i),N);
[temp x] = hist(abs(Rician_ch(i,:)),level);
plot(x,temp/1e4,gss(i+1,:))
grid on
end
xlabel('x'), ylabel('Occurrence')
legend('Rayleigh','Rician, K=-40dB','Rician, K=0dB','Rician, K=6dB','Rician, K=15dB')
%

