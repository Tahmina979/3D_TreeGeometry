function [gamnew] = updategam(gamupdate,gamid,eps)

[a1,a2,a3] = size(gamid);

for k=1:a3
    gamnew(:,:,k) = gamid(:,:,k) + eps.*gamupdate(:,:,k);
end