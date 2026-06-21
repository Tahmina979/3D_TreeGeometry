function [gam, E] = DPQ_difflen(srnf1,srnf2,surf1,surf2,t1,t2)

[n,n,d]=size(srnf1);

N=5;
M=7;

[b,U,V] = formbasisidcylinder(N,M,n);

%gamma 
gamid(:,:,1)=U;
gamid(:,:,2)=V;



eps=0.01;

[gam, E] = ReparamSurf(srnf1,srnf2,surf1,surf2,n,b,gamid,80,eps);


end