function x = uncompress_mod(y)
    % Compress signal using some function
    % transformed signal values below threshold will be removed
    %
    % DO OPPPOSITE OF "COMPRESS" TRANSFORM HERE
    x = idwt_haar(y, 4);
    %x = y;
    % Done
