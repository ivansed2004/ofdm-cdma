function [Rs] = rec_corr( r, s )
    len = length( r );
    R = 0;
    for i = 1:1:len
        #R = R + xor( r(i), s(i) )
        R = R + r(i)*s(i);
    endfor
    #Rs = (len - R) / len;
    Rs = R / len;
endfunction