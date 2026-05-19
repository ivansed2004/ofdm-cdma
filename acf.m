% Вычисление АКФ для заданной последовательности s
function [R, lag] = acf( s )
    ls = length(s);
    lag = -ls:1:ls;
    R = zeros( 1, length(lag) );
    for j = 1:length(lag)
        Rs = 0;
        l = lag(j);
        for i = 0:ls-1
            if ( (i-l+1) <= 0 || (i-l+1) > ls )
                Rs = Rs + 0;
            else
                Rs = Rs + s(i+1)*s(i-l+1);
            endif
        endfor
        R(j) = Rs;
    endfor
endfunction
