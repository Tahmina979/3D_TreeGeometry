function Fnew = Apply_Gamma_Surf(F,gam,n)

n=n-1;
u = [0:n]/(n);
U = repmat(u,n+1,1);

v = 2*pi*[0:n]'/(n);
V = repmat(v,1,n+1);


Fnew(:,:,1) = interp2(U,V,F(:,:,1),gam(:,:,1),gam(:,:,2),'spline');
Fnew(:,:,2) = interp2(U,V,F(:,:,2),gam(:,:,1),gam(:,:,2),'spline');
Fnew(:,:,3) = interp2(U,V,F(:,:,3),gam(:,:,1),gam(:,:,2),'spline');