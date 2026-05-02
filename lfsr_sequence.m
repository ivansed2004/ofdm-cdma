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
