function [b,U,V] = formbasisidcylinder(N,M,n)

n=n-1;
u = [0:n]/(n);
U = repmat(u,n+1,1);
v = 2*pi*[0:n]'/(n);
V = repmat(v,1,n+1);
idx = 1;
b = zeros(n+1,n+1,2,N*(M+2)*8);
n=n+1;
m=n;


for s=1:N
    for s1=1:M
        b(:,:,1,idx) = ((cos(2*pi*s*U)-1).*(cos(s1*V)-1))/(pi*sqrt(s*s1));
        b(:,:,2,idx) = zeros(m,n);
        b(:,:,1,idx+1) = ((cos(2*pi*s*U)-1).*sin(s1*V))/(pi*sqrt(s*s1));
        b(:,:,2,idx+1) = zeros(m,n);
        b(:,:,1,idx+2) = (sin(2*pi*s*U).*sin(s1*V))/(pi*sqrt(s*s1));
        b(:,:,2,idx+2) = zeros(m,n);
        b(:,:,1,idx+3) = (sin(2*pi*s*U).*(cos(s1*V)-1))/(pi*sqrt(s*s1));
        b(:,:,2,idx+3) = zeros(m,n);
        b(:,:,1,idx+4) = b(:,:,2,idx);
        b(:,:,2,idx+4) = b(:,:,1,idx);
        b(:,:,1,idx+5) = b(:,:,2,idx+1);
        b(:,:,2,idx+5) = b(:,:,1,idx+1);
        b(:,:,1,idx+6) = b(:,:,2,idx+2);
        b(:,:,2,idx+6) = b(:,:,1,idx+2);
        b(:,:,1,idx+7) = b(:,:,2,idx+3);
        b(:,:,2,idx+7) = b(:,:,1,idx+3);
        idx=idx+8;
    end
end

for s=1:N
    b(:,:,1,idx) = (cos(2*pi*s*U)-1)/(sqrt(pi)*sqrt(s));
    b(:,:,2,idx) = zeros(m,n);
    b(:,:,1,idx+2) = sin(2*pi*s*U)/(sqrt(pi)*sqrt(s));
    b(:,:,2,idx+2) = zeros(m,n);
    b(:,:,1,idx+3) = b(:,:,2,idx);
    b(:,:,2,idx+3) = b(:,:,1,idx);
    b(:,:,1,idx+4) = b(:,:,2,idx+1);
    b(:,:,2,idx+4) = b(:,:,1,idx+1);
    idx = idx+5;
    b(:,:,1,idx) = (cos(2*pi*s*U)-1).*(V)/(2*pi*sqrt(pi)*sqrt(s));
    b(:,:,2,idx) = zeros(m,n);
    b(:,:,1,idx+2) = sin(2*pi*s*U).*(V)/(2*pi*sqrt(pi)*sqrt(s));
    b(:,:,2,idx+2) = zeros(m,n);
    b(:,:,1,idx+3) = (cos(2*pi*s*U)-1).*(2*pi-V)/(2*pi*sqrt(pi)*sqrt(s));
    b(:,:,2,idx+3) = zeros(m,n);
    b(:,:,1,idx+4) = sin(2*pi*s*U).*(2*pi-V)/(2*pi*sqrt(pi)*sqrt(s));
    b(:,:,2,idx+4) = zeros(m,n);
    idx = idx+5;
end

for s1=1:M
    b(:,:,2,idx) = U.*sin(s1*V)/(sqrt(pi)*sqrt(s1));
    b(:,:,1,idx) = zeros(m,n);
    b(:,:,2,idx+1) = (1-U).*sin(s1*V)/(sqrt(pi)*sqrt(s1));
    b(:,:,1,idx+1) = zeros(m,n);
    b(:,:,2,idx+2) = U.*(cos(s1*V)-1)/(sqrt(pi)*sqrt(s1));
    b(:,:,1,idx+2) = zeros(m,n);
    b(:,:,2,idx+3) = (1-U).*(cos(s1*V)-1)/(sqrt(pi)*sqrt(s1));
    b(:,:,1,idx+3) = zeros(m,n);
    idx = idx+4;
end

b(:,:,2,idx) = U;
b(:,:,1,idx) = zeros(m,n);
b(:,:,2,idx+1) = 1-U;
b(:,:,1,idx+1) = zeros(m,n);

end
