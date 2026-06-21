function [Q, locator_qs0,locator_qs1]= unflattenCompTree_3layers_rad(qsX,lam_m, lam_s, lam_p, refQ, locator_qs0)


d = 3;

T0 = refQ.T0_pointNum;

ds=d*T0*T0;

locator_qs1=locator_qs0+2*ds;


beta0_rad=zeros(1,T0);
%mapping from tangent to original
%surf0 = reshape(sX(locator_qs0:locator_qs1 -1),[T0,T0,d]);
qsurf0 = reshape(qsX(locator_qs0:locator_qs1 -1),[T0,T0,2*d]);

locator_qs0 = locator_qs1;
locator_qs1=locator_qs1+(T0*T0);
qnormx0 = reshape(qsX(locator_qs0:locator_qs1 -1),[T0,T0]);

locator_qs0 = locator_qs1;
locator_qs1=locator_qs1+(T0*T0);
qnormy0 = reshape(qsX(locator_qs0:locator_qs1 -1),[T0,T0]);

locator_qs0 = locator_qs1;
locator_qs1=locator_qs1+(T0*d);
inpx0 = reshape(qsX(locator_qs0:locator_qs1 -1),[T0,d]);

locator_qs0 = locator_qs1;
locator_qs1=locator_qs1+(T0*d);
inpy0 = reshape(qsX(locator_qs0:locator_qs1 -1),[T0,d]);


% store subtree position
locator_qs0 = locator_qs1;
locator_qs1 = locator_qs1 + numel(refQ.q_children);


sk = qsX(locator_qs0:locator_qs1 -1)/sqrt(lam_p);
% Force sk to be non-negtative
sk(sk<0) = 0;

locator_qs0 = locator_qs1;
locator_qs1=locator_qs1+(T0*d);
q0 = reshape(qsX(locator_qs0:locator_qs1 -1),[d,T0]);
% Make 3 layers tree
% q_children_ST = cell(1, length(refQ.q_children));

q_children_ST = repmat({struct('q0', [],'qsurf0',[],'surf0',[],'qnormx',[],'qnormy',[],'in_px',[],'in_py',[])}, 1, length(refQ.q_children));


Q = make_qtanCompTree_rad_3layers(q0, qsurf0,qsurf0(:,:,1:3), qnormx0,qnormy0,inpx0,inpy0,q_children_ST, sk, [0; 0 ;0], ...
                                beta0_rad, refQ.beta_rad);


% unflatten subtrees

locator_qs0=locator_qs1;

for k=1: numel(Q.q_children)

    [Q.q_children{k}, locator_qs0,locator_qs1] = unflattenSimpleTree_rad(qsX,lam_m, lam_s, lam_p, ...
                                                                      refQ.q_children{k}, locator_qs0);
    
    Q.q{k} = Q.q_children{k}.q0;
    Q.qsurf{k}=Q.q_children{k}.qsurf0;
    Q.surf{k}=Q.q_children{k}.surf0;
     Q.qnormx{k}=Q.q_children{k}.qnormx0;
      Q.qnormy{k}=Q.q_children{k}.qnormy0;
       Q.in_px{k}=Q.q_children{k}.in_px0;
        Q.in_py{k}=Q.q_children{k}.in_py0;

  
        %Q.beta{k} = Q.q_children{k}.beta0_rad;
 


end


            
end

