function myJPEG(fn)
    origional_I = imread(fn);

    figure(0);
    % show the origional image
    imshow(origional_I);
    origional_size = size(origional_I);

    % filling the edges with black to meet multiples of 8
    % to keep the whole image in 8x8 blocks
    I = padarray(origional_I, [8 - mod(origional_size(1), 8), 8 - mod(origional_size(2), 8)], 'post');
    % imshow(I);

    % preparing to divide the image into 8x8 blocks

    % get the size of blocks
    [m, n] = size(I);
    m = m / 8;
    n = n / 8;

    % storing the blocks in a array
    blocks = zeros(m, n, 8, 8);

    for i = 1:m

        for j = 1:n
            % get the block, and store it in the array
            blocks(i, j, :, :) = I((i - 1) * 8 + 1:i * 8, (j - 1) * 8 + 1:j * 8);
        end

    end

    % show the first two block
    disp(squeeze(blocks(1, 1, :, :)));
    disp(squeeze(blocks(1, 2, :, :)));

    % level shift by subtracting 128 from each pixel
    blocks = blocks - 128;

    % show the first two levelled off blocks
    disp(squeeze(blocks(1, 1, :, :)));
    disp(squeeze(blocks(1, 2, :, :)));

    % apply DCT to each block
    dct_blocks = zeros(m, n, 8, 8);

    for i = 1:m

        for j = 1:n
            % apply DCT
            dct_blocks(i, j, :, :) = dct2(squeeze(blocks(i, j, :, :)));
        end

    end

    % show the first two DCT blocks
    disp(squeeze(dct_blocks(1, 1, :, :)));
    disp(squeeze(dct_blocks(1, 2, :, :)));

    % quantization
    Qstd = [16 11 10 16 24 40 51 61; 12 12 14 19 26 58 60 55; 14 13 16 24 40 57 69 56; 14 17 22 29 51 87 80 62; 18 22 37 56 68 109 103 77; 24 35 55 64 81 104 113 92; 49 64 78 87 103 121 120 101; 72 92 95 98 112 100 103 99];
    % set quantization factors
    factor_low = 0.42;
    factor_high = 2;

    % create quantization matrix
    Qlow = round(Qstd * factor_low);
    Qhigh = round(Qstd * factor_high);

    % print the quantization matrix
    disp(Qlow);
    disp(Qhigh);

    % quantize the DCT blocks
    quantized_blocks_std = zeros(m, n, 8, 8);
    quantized_blocks_low = zeros(m, n, 8, 8);
    quantized_blocks_high = zeros(m, n, 8, 8);

    for i = 1:m

        for j = 1:n
            % quantize by dividing by the quantization matrix
            quantized_blocks_std(i, j, :, :) = round(squeeze(dct_blocks(i, j, :, :)) ./ Qstd);
            quantized_blocks_low(i, j, :, :) = round(squeeze(dct_blocks(i, j, :, :)) ./ Qlow);
            quantized_blocks_high(i, j, :, :) = round(squeeze(dct_blocks(i, j, :, :)) ./ Qhigh);
        end

    end

    % show the first two quantized blocks
    disp('standard quantization');
    disp(squeeze(quantized_blocks_std(1, 1, :, :)));
    disp(squeeze(quantized_blocks_std(1, 2, :, :)));
    disp('low quantization');
    disp(squeeze(quantized_blocks_low(1, 1, :, :)));
    disp(squeeze(quantized_blocks_low(1, 2, :, :)));
    disp('high quantization');
    disp(squeeze(quantized_blocks_high(1, 1, :, :)));
    disp(squeeze(quantized_blocks_high(1, 2, :, :)));

    % decompression
    blocks_std = zeros(m, n, 8, 8);
    blocks_low = zeros(m, n, 8, 8);
    blocks_high = zeros(m, n, 8, 8);

    for i = 1:m

        for j = 1:n
            % dequantize by multiplying by the quantization matrix
            blocks_std(i, j, :, :) = squeeze(quantized_blocks_std(i, j, :, :)) .* Qstd;
            blocks_low(i, j, :, :) = squeeze(quantized_blocks_low(i, j, :, :)) .* Qlow;
            blocks_high(i, j, :, :) = squeeze(quantized_blocks_high(i, j, :, :)) .* Qhigh;
        end

    end

    % show the first two dequantized blocks
    disp('standard dequantization');
    disp(squeeze(blocks_std(1, 1, :, :)));
    disp(squeeze(blocks_std(1, 2, :, :)));
    disp('low dequantization');
    disp(squeeze(blocks_low(1, 1, :, :)));
    disp(squeeze(blocks_low(1, 2, :, :)));
    disp('high dequantization');
    disp(squeeze(blocks_high(1, 1, :, :)));
    disp(squeeze(blocks_high(1, 2, :, :)));

    % apply inverse DCT to each block
    idct_blocks_std = zeros(m, n, 8, 8);
    idct_blocks_low = zeros(m, n, 8, 8);
    idct_blocks_high = zeros(m, n, 8, 8);

    for i = 1:m

        for j = 1:n
            % apply inverse DCT and add 128
            idct_blocks_std(i, j, :, :) = round(idct2(squeeze(blocks_std(i, j, :, :)))) + 128;
            idct_blocks_low(i, j, :, :) = round(idct2(squeeze(blocks_low(i, j, :, :)))) + 128;
            idct_blocks_high(i, j, :, :) = round(idct2(squeeze(blocks_high(i, j, :, :)))) + 128;
        end

    end

    % show the first two inverse DCT blocks
    disp('standard inverse DCT');
    disp(squeeze(idct_blocks_std(1, 1, :, :)));
    disp(squeeze(idct_blocks_std(1, 2, :, :)));
    disp('low inverse DCT');
    disp(squeeze(idct_blocks_low(1, 1, :, :)));
    disp(squeeze(idct_blocks_low(1, 2, :, :)));
    disp('high inverse DCT');
    disp(squeeze(idct_blocks_high(1, 1, :, :)));
    disp(squeeze(idct_blocks_high(1, 2, :, :)));

    % reconstruct the image
    image_std = zeros(m * 8, n * 8);
    image_low = zeros(m * 8, n * 8);
    image_high = zeros(m * 8, n * 8);

    for i = 1:m

        for j = 1:n
            % combine the blocks from the blocks array
            image_std((i - 1) * 8 + 1:i * 8, (j - 1) * 8 + 1:j * 8) = squeeze(idct_blocks_std(i, j, :, :));
            image_low((i - 1) * 8 + 1:i * 8, (j - 1) * 8 + 1:j * 8) = squeeze(idct_blocks_low(i, j, :, :));
            image_high((i - 1) * 8 + 1:i * 8, (j - 1) * 8 + 1:j * 8) = squeeze(idct_blocks_high(i, j, :, :));
        end

    end

    % crop the image to the original size
    % the processed image is padded with blacks to fit the blocks
    image_std = image_std(1:origional_size(1), 1:origional_size(2));
    image_low = image_low(1:origional_size(1), 1:origional_size(2));
    image_high = image_high(1:origional_size(1), 1:origional_size(2));

    % show the images

    % original image
    % show image and its partial view
    figure(1);
    sgtitle('original image');
    subplot(1, 2, 1);
    imshow(I);
    subplot(1, 2, 2);
    % show the middle part of the image to see the details
    imshow(I(round(origional_size(1) * 0.25):round(origional_size(1) * 0.75), round(origional_size(2) * 0.25):round(origional_size(2) * 0.75)));

    % standard quantization
    figure(2);
    sgtitle('standard quantization image');
    subplot(1, 2, 1)
    imshow(uint8(image_std));
    subplot(1, 2, 2)
    imshow(uint8(image_std(round(origional_size(1) * 0.25):round(origional_size(1) * 0.75), round(origional_size(2) * 0.25):round(origional_size(2) * 0.75))));

    % low quantization
    figure(3);
    sgtitle('low quantization image');
    subplot(1, 2, 1)
    imshow(uint8(image_low));
    subplot(1, 2, 2)
    imshow(uint8(image_low(round(origional_size(1) * 0.25):round(origional_size(1) * 0.75), round(origional_size(2) * 0.25):round(origional_size(2) * 0.75))));

    % high quantization
    figure(4);
    sgtitle('high quantization image');
    subplot(1, 2, 1)
    imshow(uint8(image_high));
    subplot(1, 2, 2)
    imshow(uint8(image_high(round(origional_size(1) * 0.25):round(origional_size(1) * 0.75), round(origional_size(2) * 0.25):round(origional_size(2) * 0.75))));

    % the quality can be easily seen from the partial view of the images
end
