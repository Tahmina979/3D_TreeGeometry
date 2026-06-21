function [Q, locator_qs0,locator_qs1]= unflattenSimpleTree_rad(qsX,lam_m, lam_s, lam_p, refQ, locator_qs0)

% qX = zeros(n,p);
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
locator_qs1 = locator_qs1 + numel(refQ.q);


sk = qsX(locator_qs0:locator_qs1 -1)/sqrt(lam_p);
sk(sk<0) = 0;

locator_qs0 = locator_qs1;
locator_qs1=locator_qs1+(T0*d);
q0 = reshape(qsX(locator_qs0:locator_qs1 -1),[d,T0]);

% make simple tree
q = cell(1, length(refQ.q));
qsurf=cell(1, length(refQ.srnf));
surf=cell(1, length(refQ.surf));
qnormx=cell(1, length(refQ.q));
qnormy=cell(1, length(refQ.q));
in_px=cell(1, length(refQ.q));
in_py=cell(1, length(refQ.q));


Q = make_qtanST_rad(q0, qsurf0,qsurf0(:,:,1:3),qnormx0, qnormy0, inpx0, inpy0, q, qsurf,surf,qnormx,qnormy,in_px,in_py,sk,[0; 0 ;0], beta0_rad, refQ.beta_rad);

% unflatten subtrees

locator_qs0=locator_qs1;

for k=1: numel(refQ.q)

    T0 = size(refQ.q{k}, 2);
    
    ds=d*T0*T0;
   
    locator_qs1=locator_qs0+2*ds;

   
    rad=zeros(1,T0);
    
    
    Q.qsurf{k}=reshape(qsX(locator_qs0:locator_qs1 -1), [T0, T0, 2*d]);
    Q.surf{k}= Q.qsurf{k}(:,:,1:3);
  
    locator_qs0 = locator_qs1;
    locator_qs1=locator_qs1+(T0*T0);
    Q.qnormx{k} = reshape(qsX(locator_qs0:locator_qs1 -1),[T0,T0]);
    
    locator_qs0 = locator_qs1;
    locator_qs1=locator_qs1+(T0*T0);
    Q.qnormy{k} = reshape(qsX(locator_qs0:locator_qs1 -1),[T0,T0]);
    
    locator_qs0 = locator_qs1;
    locator_qs1=locator_qs1+(T0*d);
    Q.in_px{k} = reshape(qsX(locator_qs0:locator_qs1 -1),[T0,d]);
    
    locator_qs0 = locator_qs1;
    locator_qs1=locator_qs1+(T0*d);
    Q.in_py{k} = reshape(qsX(locator_qs0:locator_qs1 -1),[T0,d]);

    locator_qs0 = locator_qs1;
    locator_qs1=locator_qs1+(T0*d);
    Q.q{k} = reshape(qsX(locator_qs0:locator_qs1 -1),[d,T0]);
  
    Q.beta_rad{k} = rad;
    
   
    locator_qs0=locator_qs1;
    
end

            
end

