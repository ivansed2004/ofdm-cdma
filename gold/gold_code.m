function [G] = gold_code( n, polynomial, d );
    init = zeros(1, n); init(1) = 1;
    ms1 = lfsr_sequence( init, polynomial );
    ms2 = decimation( ms1, d );
    L = length( ms1 );
    G = zeros(L+2, L);
    G(1, :) = ms1; G(2, :) = ms2;
    G(3, :) = xor(ms1, ms2);
    for i = 4:L+2
        G(i, :) = xor( shift( G(i-1, :), i-3 ), ms2 );
    endfor
endfunction

function [sh_sequence] = shift( m_sequence, i )
    sequence = m_sequence;
    L = length(sequence);
    sh_sequence = zeros(1, L);
    sh_sequence(L) = sequence(1);
    for i = 2:L
        sh_sequence(i-1) = sequence(i);
    endfor
endfunction

function [dec_sequence] = decimation( m_sequence, d )
    sequence = m_sequence;
    L = length(sequence);
    dec_sequence = zeros(1, L);
    for i = 1:L
        dec_sequence(i) = sequence( mod((i-1)*d, L)+1 );
    endfor
endfunction

function [m_sequence] = lfsr_sequence( init, polynomial )
    m = length(init);
    register = init;
    m_sequence = zeros(1, (2^m - 1));
    N = length(register);

    for i = 1:(2^m - 1)
        output_bit = register(N);
        m_sequence(i) = output_bit;

        feedback = 0;
        for t = polynomial
            feedback = xor(feedback, register(t));
        endfor

        register = [feedback, register(1:N-1)];
    endfor
endfunction