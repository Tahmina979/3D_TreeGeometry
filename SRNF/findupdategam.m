function gamupdate = findupdategam(v,w,b)

[a1,a2,a3,a4] = size(w);
[a5,a6,a7,a8] = size(b);

for k=1:a4
    innp(k) = 0;
    for j=1:a3
        innp(k) = innp(k) + sum(sum(v(:,:,j).*w(:,:,j,k)));
    end
    innp(k) = 2*pi*innp(k)/(a1-1).^2;
end


gamupdate = zeros(a1,a2,2);
for k=1:a8
        gamupdate(:,:,1) = gamupdate(:,:,1) + innp(k)*b(:,:,1,k);
        gamupdate(:,:,2) = gamupdate(:,:,2) + innp(k)*b(:,:,2,k);
end