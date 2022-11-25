N = 2^12;
t = 0:1 / N:1 - 1 / N;
threshold = 0.42;

s = testsig_mod(t);

figure(1);
plot(t, s);
title('Original Signal');

compressed = compress_mod(s, threshold);

figure(2);
dwt4 = dwt_haar(s, 4);
plot(t, dwt4);
title('DWT4 Signal');

figure(3);
plot(t, compressed);
title('DWT4 After Thresholding');

figure(4);
uncompressed = uncompress_mod(compressed);
plot(t, uncompressed);
title('Reconstructed Signal');

figure(5);
plot(t, s - uncompressed);
title('Difference Between Original and Reconstructed Signal');
