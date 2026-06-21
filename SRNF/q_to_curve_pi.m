function p = q_to_curve_pi(q,qnorm)

[n,T] = size(q);
% n = n*2;
%qnorm = zeros(1,T);
for i = 1:T
   % qnorm(i) = norm(q(:,i));
end

p = zeros(n,T);
for i = 1:n
    p(i,:) = [ cumtrapz( q(i,:).*qnorm)* 2*pi/(T-1) ] ;
end

% p = spcrv(p, 3);


%p(:,end) = p(:,1);
return;
end