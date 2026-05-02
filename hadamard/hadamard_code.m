function [ H ] = hadamard_code(len)
    if len == 2
        H2 = [1, 1, 1, -1];
        H = reshape(H2, 2, 2);
    else
        H_ = hadamard_code(len/2);
        H = [ H_, H_; H_, -1*H_ ];
    endif
end