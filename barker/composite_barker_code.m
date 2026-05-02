function [B] = composite_barker_code(len1, ref1, rev1, len2, ref2, rev2)
    bc1 = canonical_barker_code(len1, ref1, rev1);
    bc2 = canonical_barker_code(len2, ref2, rev2);
    if ( ref1 == true & rev1 == true )
        b1 = reverse(reflect(bc1));
    elseif ( ref1 == true & rev1 == false )
        b1 = reflect(bc1);
    elseif ( ref1 == false & rev1 == true )
        b1 = reverse(bc1);
    endif
    if ( ref2 == true & rev2 == true )
        b2 = reverse(reflect(bc2));
    elseif ( ref2 == true & rev2 == false )
        b2 = reflect(bc2);
    elseif ( ref2 == false & rev2 == true )
        b2 = reverse(bc2);
    endif
    B = kron(bc1, bc2);
endfunction

function [rev_B] = reverse(B)
    rev_B = -1*B;
endfunction

function [ref_B] = reflect(B)
    L = length(B);
    ref_B = zeros(1, L);
    if ( mod(L, 2) == 0)
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