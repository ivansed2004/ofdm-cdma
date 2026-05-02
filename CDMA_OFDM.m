pkg load communications;
pkg load signal;
pkg load statistics;
clc;
close all;
clear all;

addpath('gold');
addpath('hadamard');

nBit = 20000;
% Ввод параметров модуляции
M=4; % число символов в канале ПД
k=log2(M); % число бит на один символ
nSym = ceil(nBit / k); %число символов данных
%
FM=64;%задать порядок OFDM символа и кол-во поднесущих=(FM/4-1)
kF=log2(FM);

% формирование исходной битовой последовательности данных
bit_data = randi([0, 1], 1, nBit); bit_data = [bit_data, zeros(1, nSym*k-nBit)];
bit_matrix = reshape(bit_data, k, nSym);
% формирование исходной символьной последовательности данных
weights = 2.^(k-1:-1:0);
data = weights * bit_matrix;

pSN = -25:1:0; # SNR (dB)

% подсчет ошибок
pSNsize = length(pSN);
SymErrors = zeros(1, pSNsize);
BitErrors = zeros(1, pSNsize);

dlmwrite('symerrors.csv', pSN, 'delimiter', ';');
dlmwrite('biterrors.csv', pSN, 'delimiter', ';');

for p = 1:1:pSNsize
    %-----------------Transmitter--------------------
    d=data;
    %
    sk=qaskenco(d,M);%модуляция QASK кодом Грея
    
    %Готовим матрицу data к OFDM, Используем технологию ACO-OFDM;
    iDF=FM/4-1; datOFDM=[]; % iDF - число поднесущих
    Jdat = 0; bdf = [];
    padding = 0;
    if mod(length(d), iDF) != 0
        Jdat=ceil(length(d) / iDF);
        padding = iDF-mod((length(d)),iDF);
        bdf=[sk,zeros(1,(padding))];
    elseif
        Jdat = length(d) / iDF;
        bdf = sk;
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
    %-------------- Channel ----------------
    z=awgn(s11,pSN(p),snss);% помеха
    ZkanWithawgn=real(z)*cos(2*pi)+imag(z)*sin(2*pi);
    ZkanWithoutAwgn=real(s11)*cos(2*pi)+imag(s11)*sin(2*pi);
    Zs1kan=real(S11z)*cos(2*pi)+imag(S11z)*sin(2*pi);% ОЧРК с СР
    Zzs1kan=awgn(Zs1kan,pSN(p),snss-3);% помеха к ОЧРК с СР

    %прием с СР
    yZkan=buffer(Zzs1kan,(FM+2));
    ySkan=yZkan(2:(FM+1),:);
    %yCkan
    yRd=fft(ySkan,FM);
    yiRDF=size(yRd);
    yRskF=yRd(2:2:FM,:);
    yZRskF=yRskF(1:iDF,:);
    ybdf1=reshape(yZRskF,1,iDF*yiRDF(2));
    ysr=ybdf1;
    dyCap=qaskdeco(ysr,M);
    %
    dyCap_bits = de2bi(dyCap, k, 'left-msb'); dyCap_bits = dyCap_bits(1:length(d), :);
    
    symE = 0;
    for yi =1:length(d)
        if (d(yi)!=dyCap(yi))
            symE = symE+1;
        end;
    end;
    SymErrors(p) = symE;
    
    bitmis = (dyCap_bits != bit_matrix');
    bitE = sum(bitmis(:));
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