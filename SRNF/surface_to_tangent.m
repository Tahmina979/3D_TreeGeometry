function [Q,Lx,Ly]=surface_to_tangent(F)
[n n d]=size(F);
Q=zeros(n,n,6);
%for x component (left to right)
Fx=zeros(n,n,d);


%to_SRVF
for i=1:n
    f=zeros(n,3);
    f(:,:)=F(i,:,:);
    fx=f';
    [q,Lx(i,:)]=curve_to_q_pi(fx);
    Fx(i,:,:)=q';
end
%for y component (top to bottom)
Fy=zeros(n,n,d);
Fy_r=zeros(n,n,d);

%to SRVF
for i=1:n
    f=zeros(n,3);
    f(:,:)=F(:,i,:);
    fy=f';
    [q,Ly(i,:)]=curve_to_q_n(fy);
    Fy(:,i,:)=q';
end

Q(:,:,1:3)=Fx;
Q(:,:,4:6)=Fy;

end