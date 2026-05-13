pkg load communications;
pkg load signal;
clc;
close all;
clear all;

graphics_toolkit("fltk");

addpath('gold');
addpath('hadamard');

nBit = 20000;
% Ввод параметров модуляции
M=4; % число символов в канале ПД
k=log2(M); % число бит на один символ
nSym = ceil(nBit / k); %число символов данных
%
FM=64;%задать порядок OFDM символа и кол-во поднесущих=(FM/4 -1)
kF=log2(FM);

% формирование исходной битовой последовательности данных
bit_data = randi([0, 1], 1, nBit); bit_data = [bit_data, zeros(1, nSym*k-nBit)];
bit_matrix = reshape(bit_data, k, nSym);
% формирование исходной символьной последовательности данных
weights = 2.^(k-1:-1:0);
data = weights * bit_matrix;

%% формирование базиса быстрого преобразования Уолша
channels = 4;
walsh_basis = hadamard_code(channels);

% спецификация кодов Голда
##spec = {
##  {4, [1], 7};
##  {5, [2], 9};
##  {6, [1], 11}
##  {7, [1], 13}
##  {8, [4, 3, 1], 33}
##};

pSN = -25:1:0; # SNR (dB)

% подсчет ошибок
pSNsize = length(pSN);
SymErrors = zeros(1, pSNsize);
BitErrors = zeros(1, pSNsize);

%% Generation Matrix (G)
G = gold_code(8, [4, 3, 1], 33);

sf = size(G)(2); % коэффициент расширения (DSSS) / число чипов на символ
cbr = sf / k; % chip to bit ratio (сколько в среднем чипов приходится на бит в пределах одного символа)
nChip = nSym*sf; % общее число чипов, передаваемых в СПД

%-----------------Transmitter (CDMA-OFDM)--------------------
spreading_code = reshape( G(1:M*channels, :), [channels, M, sf] ); % расширяющие коды
spreading_code = 1 - 2*spreading_code;

dd = ceil(length(data) / channels);
ch_data = [ data, zeros(1, channels*dd-length(data)) ]; % заполнение нулями для в случае нехватки символов данных
ch_data = reshape( ch_data, dd, channels ).'; % исходные данные, сгруппированные по каналам
spr_ch_data = zeros(channels, dd, sf); % те же данные, представленные в соответствующих кодах

% алгоритм заполнения тензора spr_ch_data
for i = 1:1:channels
    for j = 1:1:dd
        sym = ch_data(i, j);
        spr_ch_data(i, j, :) = spreading_code(i, sym+1, :);
    end
end

ifwt_output = zeros(channels, sf, dd); % тензор с коэффициетами ОБПУ
for i = 1:1:dd
    sl = squeeze(spr_ch_data(:, i, :));
    ifwt_output(:, :, i) = (walsh_basis * sl) / channels;
end

% набор вещественных данных
real_d = ifwt_output(:).';
% набор комплексных данных (преобразование Гильберта)
d = hilbert(real_d);

% ================================ %

%Готовим матрицу data к OFDM, Используем технологию ACO-OFDM;
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
%
Sof=ifft(datOFDM,FM);

%формируем и приклеиваем CyclicPrefix (CP)
Sd0f=(-4).*ones(1,Jdat); S1of=[Sd0f;Sof;Sd0f];
%
s=reshape(Sof,1,FM*Jdat); psmim=abs(max(s));% без СР
snss=floor(20*log10(rms(s)));
s11=s.+psmim+2;% фрейм без СР
s1z=reshape(S1of,1,(FM+2)*Jdat); S11z=s1z.+psmim+0.5;% фрейм плюс СР

for p = 1:1:pSNsize
  %-------------- Channel ----------------
  z=awgn(s11,pSN(p),snss);% помеха
  ZkanWithawgn=real(z)*cos(2*pi)+imag(z)*sin(2*pi);
  ZkanWithoutAwgn=real(s11)*cos(2*pi)+imag(s11)*sin(2*pi);
  Zs1kan=real(S11z)*cos(2*pi)+imag(S11z)*sin(2*pi);% ОЧРК с СР
  Zzs1kan=awgn(Zs1kan,pSN(p),snss-6);% помеха к ОЧРК с СР
  %-------------- Receiver ----------------
  yZkan=buffer(Zzs1kan,(FM+2));
  ySkan=yZkan(2:(FM+1),:);
  %yCkan
  yRd=fft(ySkan,FM);
  yiRDF=size(yRd);
  yRskF=yRd(2:2:FM,:);
  yZRskF=yRskF(1:iDF,:);
  ybdf1=reshape(yZRskF,1,iDF*yiRDF(2));
  ysr=ybdf1;
  dyCap = real(ysr); dyCap = dyCap(1:length(dyCap)-padding);

  % коэффициенты БПУ + белый гауссов шум
  ifwt_output_awgn = reshape( dyCap, [channels, sf, dd] );
  % обратное БПУ с зашумленными коэффициентами (значения чипов + белый гауссов шум)
  fwt_output_awgn = zeros(channels, sf, dd);
  for i = 1:1:dd
      sl = squeeze(ifwt_output_awgn(:, :, i));
      fwt_output_awgn(:, :, i) = (walsh_basis * sl);
  endfor

  % расчет ошибок (оценка наибольшего правдоподобия)
  symE = 0;
  bitE = 0;
  for i = 1:1:channels
      for j = 1:1:dd
          sym = 0;
          true_sym = 0;
          R = 0;
          for m = 1:1:M
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
