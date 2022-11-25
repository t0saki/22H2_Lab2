function myJPEG(fn)
    I = imread(fn);
    % imshow(I);
    origional_size = size(I);

    % filling the edges with black to meet multiples of 8
    I = padarray(I, [8 - mod(origional_size(1), 8), 8 - mod(origional_size(2), 8)], 'post');
    % imshow(I);

    % preparing to divide the image into 8x8 blocks

    [m, n] = size(I);
    m = m / 8;
    n = n / 8;

    % storing the blocks in a array
    blocks = zeros(m, n, 8, 8);

    for i = 1:m

        for j = 1:n
            % get the block
            blocks(i, j, :, :) = I((i - 1) * 8 + 1:i * 8, (j - 1) * 8 + 1:j * 8);
        end

    end

    % show the first two block
    % disp(squeeze(blocks(1, 1, :, :)));
    % disp(squeeze(blocks(1, 2, :, :)));

    % level shift by subtracting 128 from each pixel
    blocks = blocks - 128;

    % show the first two levelled off blocks
    % disp(squeeze(blocks(1, 1, :, :)));
    % disp(squeeze(blocks(1, 2, :, :)));

    % apply DCT to each block
    dct_blocks = zeros(m, n, 8, 8);

    for i = 1:m

        for j = 1:n
            % apply DCT
            dct_blocks(i, j, :, :) = dct2(squeeze(blocks(i, j, :, :)));
        end

    end

    % show the first two DCT blocks
    % disp(squeeze(dct_blocks(1, 1, :, :)));
    % disp(squeeze(dct_blocks(1, 2, :, :)));

    % quantization
    Qstd = [16 11 10 16 24 40 51 61; 12 12 14 19 26 58 60 55; 14 13 16 24 40 57 69 56; 14 17 22 29 51 87 80 62; 18 22 37 56 68 109 103 77; 24 35 55 64 81 104 113 92; 49 64 78 87 103 121 120 101; 72 92 95 98 112 100 103 99];

end
