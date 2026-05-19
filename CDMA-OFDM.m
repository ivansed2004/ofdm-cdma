% ======================== МОДЕЛЬ CDMA+OFDM =======================
pkg load communications;
pkg load signal;
clc;
close all;
clear all;

graphics_toolkit("fltk");

addpath('gold');
addpath('hadamard');

% ======================== Параметры модели =======================
% 1. Общее количество бит
nBit = 20000;
% 2. Количество уникальных символов данных
M = 4;
% 3. Количество бит на символ
k = log2(M);
nSym = ceil(nBit / k);
% 4. Индекс OFDM и кол-во поднесущих=(FM/4 -1)
FM = 64;
kF = log2(FM);
% 5. Количество каналов (= количеству потоков)
channels = 4;
% 6. Полином, порождающий ПСП
% старшая степень полинома
pd = 6;
% степени полинома с единичным коэффициентом
polynom = [pd, 1];
% 7. Коэффициент децимации
dec = 5;
% 8. Коэффициент расширения спектра
sf = 2^polynom(1) - 1;

% ================= Подготовка данных для передачи ================
% Формирование исходной битовой последовательности данных
bit_data = randi([0, 1], 1, nBit); bit_data = [bit_data, zeros(1, nSym*k-nBit)];
bit_matrix = reshape(bit_data, k, nSym);
% Формирование исходной символьной последовательности данных
weights = 2.^(k-1:-1:0);
data = weights * bit_matrix;

%% Формирование базиса быстрого преобразования Уолша
walsh_basis = hadamard_code(channels);

% Отношение сигнал/шум (dB)
pSN = -25:1:-9;

%% Матрица кодов Голда, задаваемая в соответствии со след. параметрами:
%% 1. Степенью полинома, формирующего регистр сдвига
%% 2. Коэффициентами при степенях полинома, начиная со старшей степени
%% 3. Коэффициентом децимации
G = gold_code( pd, polynom, dec );

% Подсчет ошибок
pSNsize = length(pSN);
SymErrors = zeros(1, pSNsize);
BitErrors = zeros(1, pSNsize);

% ===================== Передатчик (CDMA+OFDM) ====================
% Расширяющие коды Голда, сгруппированные по каналам
spreading_code = reshape( G(1:M*channels, :), [channels, M, sf] );
% Замена 0 на 1, 1 на -1
spreading_code = 1 - 2*spreading_code;

% Количество итераций, необходимых для передачи символов по всем каналам
dd = ceil(length(data) / channels);
% Заполнение нулями в случае нехватки символов данных
ch_data = [ data, zeros(1, channels*dd-length(data)) ];
% Исходные данные, сгруппированные по каналам
ch_data = reshape( ch_data, dd, channels ).';
% Те же данные, представленные в соответствующих кодах
spr_ch_data = zeros(channels, dd, sf);
% Алгоритм заполнения тензора spr_ch_data
for i = 1:1:channels
    for j = 1:1:dd
        sym = ch_data(i, j);
        spr_ch_data(i, j, :) = spreading_code(i, sym+1, :);
    end
end

% Тензор с коэффициетами ОБПУ
ifwt_output = zeros(channels, sf, dd);
for i = 1:1:dd
    sl = squeeze(spr_ch_data(:, i, :));
    ifwt_output(:, :, i) = (walsh_basis * sl) / channels;
end

% Набор вещественных данных
real_d = ifwt_output(:).';
% Набор комплексных данных (преобразование Гильберта)
d = hilbert(real_d);

% -------------------- Формирование OFDM-кадра --------------------
% Готовим матрицу data к OFDM. Используем технологию ACO-OFDM;
iDF=FM/4-1; datOFDM=[]; % iDF - число поднесущих
Jdat = 0; bdf = [];
padding = 0;
if mod(length(d), iDF) != 0
    Jdat=ceil(length(d) / iDF);
    padding = iDF-mod((length(d)),iDF);
    bdf=[d,zeros(1,(padding))];
elseif
    Jdat = length(d) / iDF;
    bdf = d;
endif
bdfr=reshape(bdf,iDF,Jdat);
for jfl=1:Jdat;
  ZagM=zeros(FM,1);
  Frfldat=bdfr(1:iDF,jfl);
  for ifm=2:2:(iDF*2)+1;
      ZagM(ifm,1)=Frfldat(ifm/2,1);
      ZagM(FM-ifm+2,1)=conj(Frfldat(ifm/2,1));
  endfor
  datOFDM=[datOFDM ZagM];
end
Sof=ifft(datOFDM,FM);

%формируем и приклеиваем CyclicPrefix (CP)
Sd0f=(-4).*ones(1,Jdat); S1of=[Sd0f;Sof;Sd0f];
s=reshape(Sof,1,FM*Jdat); psmim=abs(max(s));% без СР
snss=floor(20*log10(rms(s)));
s11=s.+psmim+2;% фрейм без СР
s1z=reshape(S1of,1,(FM+2)*Jdat); S11z=s1z.+psmim+0.5;% фрейм плюс СР
% =================================================================

for p = 1:1:pSNsize
  % ========================= Канал AWGN ==========================
  z=awgn(s11,pSN(p),snss);% помеха
  ZkanWithawgn=real(z)*cos(2*pi)+imag(z)*sin(2*pi);
  ZkanWithoutAwgn=real(s11)*cos(2*pi)+imag(s11)*sin(2*pi);
  Zs1kan=real(S11z)*cos(2*pi)+imag(S11z)*sin(2*pi);% ОЧРК с СР
  Zzs1kan=awgn(Zs1kan,pSN(p),snss-6);% помеха к ОЧРК с СР

  % ===================== Приемник (CDMA+OFDM) ====================
  yZkan=buffer(Zzs1kan,(FM+2));
  ySkan=yZkan(2:(FM+1),:);
  yRd=fft(ySkan,FM);
  yiRDF=size(yRd);
  yRskF=yRd(2:2:FM,:);
  yZRskF=yRskF(1:iDF,:);
  ybdf1=reshape(yZRskF,1,iDF*yiRDF(2));
  ysr=ybdf1;
  dyCap = real(ysr); dyCap = dyCap(1:length(dyCap)-padding);

  % Коэффициенты БПУ с белым шумом
  ifwt_output_awgn = reshape( dyCap, [channels, sf, dd] );
  % Обратное БПУ с зашумленными коэффициентами (значения чипов + белый шум)
  fwt_output_awgn = zeros(channels, sf, dd);
  for i = 1:1:dd
      sl = squeeze(ifwt_output_awgn(:, :, i));
      % Прямое БПУ для восстановления исходных чипов
      fwt_output_awgn(:, :, i) = (walsh_basis * sl);
  endfor

  % Расчет ошибок (оценка наибольшего правдоподобия)
  symE = 0;
  bitE = 0;
  for i = 1:1:channels
      for j = 1:1:dd
          sym = 0;
          true_sym = 0;
          R = 0;
          for m = 1:1:M
              % Нахождение корреляции между принятой и опорной последовательностью
              Rs = rec_corr( squeeze(spreading_code(i, m, :)), squeeze(fwt_output_awgn(i, :, j)) );
              if (Rs > R)
                  R = Rs;
                  sym = m-1;
                  true_sym = ch_data(i, j);
              endif
          endfor
          if (sym != true_sym)
              symE = symE + 1;
              bitE = bitE + sum( xor(bitget(sym, 1:k), bitget(true_sym, 1:k)) );
          endif
      endfor
  endfor

  SymErrors(p) = symE;
  BitErrors(p) = bitE;
endfor
% =================================================================

% ============ Сохранение данных и построение графиков ============
dlmwrite('symerrors.csv', SymErrors(1, :)./nSym, '-append', 'delimiter', ';');
dlmwrite('biterrors.csv', BitErrors(1, :)./nBit, '-append', 'delimiter', ';');

fig1 = figure(); plot( pSN, SymErrors(1, :)./nSym, 'g', 'linewidth', 2 );
xlabel('SNR (dB)'); ylabel('SymError'); title('Символьные ошибки, SER');
grid on;
set(gca, 'FontSize', 25, 'yscale', 'log');

fig2 = figure(); plot( pSN, BitErrors(1, :)./nBit, 'g', 'linewidth', 2 );
xlabel('SNR (dB)'); ylabel('BitError'); title('Битовые ошибки, BER');
grid on;
set(gca, 'FontSize', 25, 'yscale', 'log');
