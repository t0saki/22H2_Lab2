function s = testsig_mod(t)
    % Generate signal for Lab 2 ex 6

    s = (0 <= t & t < (1/2)) .* exp(1.5 * t) .* cos(32 * pi * t) ...
    + ((3/4) <= t & t < (7/8)) .* cos(96 * pi * t);
