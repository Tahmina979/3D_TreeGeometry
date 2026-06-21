function [A,A_tmp, A_tmp1,A_tmp2] = area_surf(F)

[n,t,d] = size(F);

for i=1:d
    [dfdu(:,:,i), dfdv(:,:,i)] = gradient(F(:,:,i),1/(n-1),2*pi/(n-1));
    % dfdu corresponds to the gradient in the u direction (top to bottom)
    % dfdv corresponds to the gradient in the v direction (left to right)   
end

for i=1:size(dfdu,1)
    for j=1:size(dfdv,2)
        A_tmp(i,j,:) = cross(dfdu(i,j,:),dfdv(i,j,:));
        A_tmp1(i,j) = norm(squeeze(A_tmp(i,j,:)));
        A_tmp2(i,j) = sqrt(A_tmp1(i,j));
    end
end

A = sum(sum(A_tmp1))*2*pi/((n-1)^2);