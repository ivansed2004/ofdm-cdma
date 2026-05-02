 function [X, Y] = graphics( s, num )
    % 1. Define the Sequence and Parameters
    S = s;
    T_pulse = 0.5; % Duration for each element
    N_samples = 100; % Samples per pulse

    % 2. Create the Pulse Shape
    pulse_shape = ones(1, N_samples);

    % 3. Generate the Function's Amplitude
    Y = kron(S, pulse_shape);

    % 4. Create the Time Vector
    T_total = length(S) * T_pulse;
    N_total = length(Y);
    X = linspace(0, T_total, N_total);

    % 5. Plot the result
    figure(num);
    plot(X, Y, 'b', 'linewidth', 2);
    hold on;
    plot([0, T_total], [0, 0], 'k--');
    hold off;
    xlabel('Time (t)');
    ylabel('Amplitude');
    title('Meander Function from Sequence');
    grid on;
    axis([0 T_total -1.2 1.2]);
    set(gca, 'FontSize', 20);
endfunction