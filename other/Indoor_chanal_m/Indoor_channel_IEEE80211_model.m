% Indoor_channel_IEEE80211_model.m
% экспоненциальная модель для представления внутренних каналов 2,4 ГГц
clear, clf, close all
scale=1e-9;     % nano
Ts=50*scale;    % период выборки Sampling time
t_rms=25*scale; % среднеквадратичный разброс задержки RMS delay spread
num_ch=10000;   % кол-во каналов Number of channels
N=128;          % размер БПФ FFT size
PDP=IEEE802_11_model(t_rms,Ts);
for k=1:length(PDP)
h(:,k) = Ray_model(num_ch).'*sqrt(PDP(k));
avg_pow_h(k)= mean(h(:,k).*conj(h(:,k)));
end
H=fft(h(1,:),N);
subplot(221)
stem([0:length(PDP)-1],PDP,'bo'), hold on,
stem([0:length(PDP)-1],avg_pow_h,'r.');
xlabel('channel tap index, p'), ylabel('Average Channel Power[linear]');
title('IEEE 802.11 Model, \sigma_\tau=25ns, T_S=50ns'); grid on;
legend('Ideal','Simulation'); axis([-1 7 0 1]);
subplot(222)
plot([-N/2+1:N/2]/N/Ts/1e6,10*log10(H.*conj(H)),'k-');
xlabel('Frequency[MHz]'), ylabel('Channel power[dB]'); grid on;
title('Frequency response, \sigma_\tau=25ns, T_S=50ns');
%
