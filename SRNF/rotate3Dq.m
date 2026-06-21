function qnew=rotate3Dq(q,Ot)

[n,d]=size(q);

for i=1:d
    
        qnew(:,i)=Ot*squeeze(q(:,i));

end