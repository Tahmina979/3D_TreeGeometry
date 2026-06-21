function [Fxy_r]=tangent_to_surf(Q,qnormx_in,qnormy_in,inpx,inpy)

[n n d]=size(Q);

Fx=zeros(n,n,d/2);
Fx=Q(:,:,1:3);
Fx_r=zeros(n,n,d/2);

Fy=zeros(n,n,d/2);
Fy=Q(:,:,4:6);
Fy_r=zeros(n,n,d/2);

%back from SRVF
for i=1:n
    initial_p=zeros(3,1);
    %initial_p(1,1)=inpx(i,1,1);
    %initial_p(2,1)=inpx(i,1,2);
    %initial_p(3,1)=inpx(i,1,3);

    initial_p(1,1)=inpx(i,1);
    initial_p(2,1)=inpx(i,2);
    initial_p(3,1)=inpx(i,3);
    
    qnormx=qnormx_in(i,:);
    
    q=zeros(n,3);
    q(:,:)=Fx(i,:,:);
    qx=q';
   
    F_r=q_to_curve_pi(qx,qnormx);
    F_r = F_r + repmat(initial_p(:,1), 1, n);
    Fx_r(i,:,:)=F_r';
end


%back from SRVF
for i=1:n
    
    initial_p=zeros(3,1);
    %initial_p(1,1)=inpy(1,i,1);
    %initial_p(2,1)=inpy(1,i,2);
    %initial_p(3,1)=inpy(1,i,3);
    initial_p(1,1)=inpy(i,1);
    initial_p(2,1)=inpy(i,2);
    initial_p(3,1)=inpy(i,3);
    qnormy=qnormy_in(i,:);
    
    q=zeros(n,3);
    q(:,:)=Fy(:,i,:);
    qy=q';
   
    F_r=q_to_curve_n(qy,qnormy);
    F_r = F_r + repmat(initial_p(:,1), 1, n);
    Fy_r(:,i,:)=F_r';
end
%Fx_r(1,:,:)=Fy_r(1,:,:);
% Weighted Averaging

Fxy_r =0.5*Fx_r +0.5*Fy_r;
end