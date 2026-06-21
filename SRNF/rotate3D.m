function qnew=rotate3D(q,Ot)

[n,t,d]=size(q);

for i=1:n
    for j=1:t
        qnew(i,j,:)=Ot*squeeze(q(i,j,:));
    end
end