## Copyright (C) 2024
## This program is free software
## Author:  <vlsa@amd64comp>
## Created: 2024-05-26

function PDP=IEEE802_11_model(sigma_t,Ts)
% IEEE 802.11 генератор PDP модели канала
% Input:
% sigma_t --- RMS delay spread
% Ts --- Sampling time
% Output:
% PDP --- Power delay profile
lmax = ceil(10*sigma_t/Ts); % Eq.(2.6)
sigma02=(1-exp(-Ts/sigma_t))/(1-exp(-(lmax+1)*Ts/sigma_t)); % Eq.(2.9)
l=0:lmax; PDP = sigma02*exp(-l*Ts/sigma_t); % Eq.(2.8)
endfunction
