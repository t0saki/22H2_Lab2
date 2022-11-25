function y = compress_mod(x, threshold)
    % Compress signal using some function
    % transformed signal values below threshold will be removed
    %
    % DO SOMETHING TO THE SIGNAL HERE
    fx = dwt_haar(x, 4);
    % DONE

    % Keep only sufficiently large values of fx
    y = fx .* (abs(fx) >= threshold);

    % Done
