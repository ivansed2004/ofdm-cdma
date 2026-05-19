% Функция для генерации кодов Голда
function [G] = gold_code( n, poly, d );
    init = zeros(1, n); init(end) = 1;
    ms1 = lfsr_sequence( init, poly );
    ms2 = decimation( ms1, d );
    L = length( ms1 );
    G = zeros(L+2, L);
    G(1, :) = ms1; G(2, :) = ms2;
    G(3, :) = xor(ms1, ms2);
    for i = 4:L+2
        G(i, :) = xor( shift(ms1, i-3), ms2 );
    endfor
endfunction

% Функция для циклического сдвига последовательности seq на величину sh
function [sh_seq] = shift( seq, sh )
    n = length(seq);
    sh = mod(sh, n);
    sh_seq = [seq(sh+1:end), seq(1:sh)];
endfunction

% Функция для децимации (прореживания) последовательности m_sequence с коэффициентом d
function [dec_seq] = decimation( m_sequence, d )
    sequence = m_sequence;
    L = length(sequence);
    dec_seq = zeros(1, L);
    for i = 1:L
        dec_seq(i) = sequence( mod((i-1)*d, L)+1 );
    endfor
endfunction

% Функция для генерации ПСП по заданному полиному РСЛОС
function [m_seq] = lfsr_sequence( init, poly )
    n = length(init);
    reg = init;
    m_seq = zeros(1, 2^n-1);
    for i = 1:(2^n-1)
        m_seq(i) = reg(end);
        feedback = 0;
        for k = 1:length(poly)
            feedback = xor(feedback, reg(poly(k)));
        end
        reg = [feedback, reg(1:end-1)];
    end
endfunction
