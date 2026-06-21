function [gam, E]=cacl_dist_last_layer(srnf1,srnf2)
[n,n,d]=size(srnf1);
u = linspace(0, n, n)/(n);
U = repmat(u,n,1);
v = 2*pi*linspace(0, n, n)'/(n);
V = repmat(v,1,n);    

gam(:,:,1)=U;
gam(:,:,2)=V;

E=Calculate_Distance(srnf1,srnf2);
end