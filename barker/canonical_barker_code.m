function [B] = canonical_barker_code(len, ref, rev)
    b2 = [1, 1;
              1, -1];
    b3 = [1, 1, -1];
    b4 = [1, 1, -1, 1; 
              1, 1, 1, -1];
    b5 = [1, 1, 1, -1, 1];
    b7 = [1, 1, 1, -1, -1, 1, -1];
    b11 = [1, 1, 1, -1, -1, -1, 1, -1, -1, 1, -1];
    b13 = [1, 1, 1, 1, 1, -1, -1, 1, 1, -1, 1, -1, 1];
    
    B = zeros(1, len);
    if (len == 2)
        B = b2;
    elseif (len == 3)
        B = b3;
    elseif (len == 4)
        B = b4;
    elseif (len == 5)
        B = b5;
    elseif (len == 7)
        B = b7;
    elseif (len == 11)
        B = b11;
    else
        B = b13;
    endif
    
    if ( ref == true & rev == true )
        B = reverse(reflect(B));
    elseif ( ref == true & rev == false )
        B = reflect(B);
    elseif ( ref == false & rev == true )
        B = reverse(B);
    endif
endfunction

function [rev_B] = reverse(B)
    rev_B = -1*B;
endfunction

function [ref_B] = reflect(B)
    L = length(B);
    ref_B = zeros(1, L);
    if ( mod(L, 2) == 0 )
        for i = 1:(L/2)
            ref_B(i) = B(L+1-i);
            ref_B(L+1-i) = B(i);
        endfor
    else
        ref_B( 1 + (L-1)/2 ) = B( 1 + (L-1)/2 );
        for i = 1:((L-1)/2)
            ref_B(i) = B(L+1-i);
            ref_B(L+1-i) = B(i);
        endfor
    endif
endfunction