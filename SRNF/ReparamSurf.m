function [gamnew, E] = ReparamSurf(q1,q2,F1,F2,n,b,gamid,itermax,eps)
False_exit=0;

H(1) = Calculate_Distance(q1,q2);
isAllZeroq1 = all(q1(:) == 0);
isAllZeroq2 = all(q2(:) == 0);

if isAllZeroq1 || isAllZeroq2
    gamnew = gamid;
    E=H(1);
    return;
end

check_step_size=1;
[a1,a2,a3]=size(q1);

iter=1;
Fnew = q1;%F1;
Hdiff=100;

while (iter<itermax && Hdiff>0.0004)

% Find phistar

w = findphistar(q1,b);

% Find Vector to Project

for j=1:size(q1,3)
    v(:,:,j) = q2(:,:,j)-q1(:,:,j);
end

% Find Update for Gamma

gamupdate = findupdategam(v,w,b);
save_prev_gamid=gamid;
gamnew = updategam(gamupdate,gamid,eps);


% Update Surface

Fnew = Apply_Gamma_Surf(Fnew,gamnew,n);




%Fnew(:,1,:)=Fnew(:,end,:);

%[Anew,normal_new,multfactnew,sqrtmultfactnew] = area_surf(Fnew);
q1 = Fnew;%surface_to_q(normal_new,sqrtmultfactnew);


iter = iter+1;


%Calculate Distance

H(iter) = Calculate_Distance(q1,q2);

if (iter>1)
    if (H(iter)>H(iter-1))
        iter=iter-1;
        %disp('ERROR: The step size is too large')
        E=H(iter);
        gamnew=save_prev_gamid;
        False_exit=1;
        break;
    end
end

if (iter>2)
    Hdiff = (H(iter-2)-H(iter-1))/H(iter-2);
end

end
if False_exit==0
    E=H(iter);
else
    %disp('exiting');
    return
end

end