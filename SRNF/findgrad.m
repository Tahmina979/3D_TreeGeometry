function [dfdu, dfdv] = findgrad(f)

[n,t,d] = size(f);

for i=1:d
    [dfdu(:,:,i), dfdv(:,:,i)] = gradient(f(:,:,i),1/(n-1),2*pi/(n-1));
end