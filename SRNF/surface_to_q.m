function q = surface_to_q(f,sqrtn)

[n,t,d] = size(f);

for i=1:n
    for j=1:n
        if sqrtn(i,j)~=0
            q(i,j,:) = (1/sqrtn(i,j))*f(i,j,:); %sqrtn(i,j)
        else
            sqrtn(i,j)=0.0001;
            q(i,j,:) = (1/sqrtn(i,j))*f(i,j,:);
        end

    end
end