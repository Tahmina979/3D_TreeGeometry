function w = findphistar(q2,b)

[a1,a2,a3,a4] = size(b);

for j=1:a4
    [dbxdu(:,:,j),temp] = gradient(b(:,:,1,j),1/(a1-1));
    [temp,dbydv(:,:,j)] = gradient(b(:,:,2,j),1/(a1-1),2*pi/(a2-1));
    divb(:,:,j) = dbxdu(:,:,j) + dbydv(:,:,j);
end

[dq2du, dq2dv] = findgrad(q2);

for k=1:a4
    for j=1:3
        expr11(:,:,j,k) = divb(:,:,k).*q2(:,:,j);
        expr21(:,:,j,k) = dq2du(:,:,j).*b(:,:,1,k)+dq2dv(:,:,j).*b(:,:,2,k);
    end
end

for k=1:a4
    for j=1:3
        w(:,:,j,k) = 0.5*expr11(:,:,j,k)+expr21(:,:,j,k);
    end
end