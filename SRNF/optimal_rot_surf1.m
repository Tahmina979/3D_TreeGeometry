function Ot = optimal_rot_surf1(q1,q2)

[n,t,d]=size(q1);
b=zeros(3,3);

q1bar = squeeze((1/(n*t))*sum(sum(q1,1),2));
q2bar = squeeze((1/(n*t))*sum(sum(q2,1),2));

for i=1:n
    for j=1:t
        a=(squeeze(q1(i,j,:))-q1bar)*(squeeze(q2(i,j,:))-q2bar)';
        b=b+a;
    end
end

A=2*pi*b/((n-1)*(t-1));
%{
[U,S,V] = svd(A);
K=[1,0,0;0,1,0;0,0,-1];
if det(A)> 0
    Ot = U*V';
else
    Ot = U*K*V';
%}
% Compute rotation angle using atan2
angle = atan2(A(1,3) - A(3,1), A(1,1) + A(3,3));

% Construct rotation matrix around the y-axis
Ot = [cos(angle), 0, sin(angle);
      0,          1, 0;
      -sin(angle), 0, cos(angle)];
end