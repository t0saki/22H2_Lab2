N = 2^16;
t = 0:1 / N:1 - 1 / N;

s = testsig_mod(t);

figure(1);
plot(t, s);
title('Original Signal');

figure(2);
dwts_1 = dwt_haar(s, 1);
plot(t, dwts_1);
title('DWT 1');

figure(3);
dwts_2 = dwt_haar(s, 2);
plot(t, dwts_2);
title('DWT 2');

figure(4);
dwts_3 = dwt_haar(s, 3);
plot(t, dwts_3);
title('DWT 3');

figure(5);
dwts_4 = dwt_haar(s, 4);
plot(t, dwts_4);
title('DWT 4');
