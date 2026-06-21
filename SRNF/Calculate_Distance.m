function H = Calculate_Distance(q1,q2)

tmp = q1-q2;
[a1,a2,a3] = size(tmp);
H = sqrt(sum(sum(sum(tmp.*tmp)))*2*pi/(a2-1)^2);