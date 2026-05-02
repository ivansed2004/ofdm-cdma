function [dec_sequence] = decimation( m_sequence, d )
    sequence = m_sequence;
    L = length(sequence);
    dec_sequence = zeros(1, L);
    for i = 1:L
        dec_sequence(i) = sequence( mod((i-1)*d, L)+1 );
    endfor
endfunction
