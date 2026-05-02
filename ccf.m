function [R, lag, ccfmax] = ccf( s1, s2 )
    ls1 = length(s1);
    ls2 = length(s2);
    lag = -ls2:1:ls1;
    R = zeros( 1, length(lag) );
    for j = 1:length(lag)
        Rs = 0;
        l = lag(j);
        for i = 0:ls1-1
            if ( (i-l+1) <= 0 || (i-l+1) > ls2 )
                Rs = Rs + 0;
            else
                Rs = Rs + s1(i+1)*s2(i-l+1);
            endif
        endfor
        R(j) = Rs / ls1;
    endfor
    
    ccfmax = 0;
    for k = 1:length(R)
        if ( R(k) > ccfmax )
            ccfmax = R(k);
        endif
    endfor
    
endfunction