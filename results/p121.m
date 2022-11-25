% Test
s = [3, 7, -2, -4, 2, 6, 1, -1];
dwts = dwt_haar(s, 2);

% a
length_s = norm(s);
length_dwts = norm(dwts);
disp('Length of s:');
disp(length_s);
disp('Length of dwts:');
disp(length_dwts);

if length_s - length_dwts < 1e-4
    disp('Length of s and dwts are equal');
else
    disp('Length of s and dwts are not equal');
end

% c
s1 = dwt_haar(s, 1);
w1 = (1 / sqrt(2)) * [1 1 0 0 0 0 0 0
                0 0 1 1 0 0 0 0
                0 0 0 0 1 1 0 0
                0 0 0 0 0 0 1 1
                1 -1 0 0 0 0 0 0
                0 0 1 -1 0 0 0 0
                0 0 0 0 1 -1 0 0
                0 0 0 0 0 0 1 -1];
s_mat = w1 * s';
s_mat = s_mat';
disp('dwt_haar func:');
disp(s1);
disp('matrix:');
disp(s_mat);
