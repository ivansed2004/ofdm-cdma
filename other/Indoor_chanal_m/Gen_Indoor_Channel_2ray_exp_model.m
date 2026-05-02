% Gen_Indoor_Channel_2ray_exp_model.m
% Обобщенные модели радиоканалов внутри помещения
% 2-х лучевая и экспоненциальная
clear, clf, close all
scale=1e-9;     % nano
Ts=10*scale;    % период выборки Sampling time
t_rms=30*scale; % среднеквадратичный разброс задержки RMS delay spread
num_ch=10000;   % кол-во каналов Number of channel
% 2-х лучевая модель
pow_2=[0.5 0.5];
delay_2=[0 t_rms*2]/scale;
H_2 = [Ray_model(num_ch); Ray_model(num_ch)].'*diag(sqrt(pow_2));
avg_pow_h_2 = mean(H_2.*conj(H_2));
subplot(221)
stem(delay_2,pow_2,'bo','linewidth',2), hold on, stem(delay_2,avg_pow_h_2,'r.','linewidth',1.5);
xlabel('Delay[ns]'), ylabel('Channel Power[linear]');
title('2-ray Model'); grid on;
legend('Ideal','Simulation'); axis([-10 140 0 0.7]);
% Экспоненциальная модель
pow_e=exp_PDP(t_rms,Ts); delay_e=[0:length(pow_e)-1]*Ts/scale;
for i=1:length(pow_e)
H_e(:,i)=Ray_model(num_ch).'*sqrt(pow_e(i));
end
avg_pow_h_e = mean(H_e.*conj(H_e));
subplot(222)
stem(delay_e,pow_e,'bo','linewidth',2), hold on, stem(delay_e,avg_pow_h_e,'r.','linewidth',1.5);
xlabel('Delay[ns]'), ylabel('Channel Power[linear]');
title('Exponential Model'); axis([-10 140 0 0.7]);
legend('Ideal','Simulation'); grid on;
