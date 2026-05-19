% Функция для вычисления корреляции между заданными последовательностями r и s в корреляционном приемнике
function [Rs] = rec_corr( r, s )
    len = length( r );
    R = 0;
    for i = 1:1:len
        R = R + r(i)*s(i);
    endfor
    Rs = R;
endfunction
