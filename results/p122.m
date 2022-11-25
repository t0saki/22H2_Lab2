s = [3, 7, -2, -4, 2, 6, 1, -1];
dwts = dwt_haar(s, 2);
idwts = idwt_haar(dwts, 2);
disp(s);
disp(idwts);
