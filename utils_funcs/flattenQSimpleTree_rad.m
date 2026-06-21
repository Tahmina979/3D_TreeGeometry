function [qX,sX,qsX] = flattenQSimpleTree_rad(qSimpleTree, lam_m, lam_s, lam_p, qX, sX,qsX,locator_s,locator_s0,locator_qs0)


% qX = zeros(n,p);
d = 3;
locator_e = 0;
locator_s1 = 0;

T0 = qSimpleTree.T0_pointNum;
dj = d*T0 + T0;
ds=d*T0*T0;
locator_e = locator_s + dj;
locator_s1=locator_s0+ds;
locator_qs1=locator_qs0+2*ds;

% store trunk
Q0_and_Rad= [sqrt(lam_m)*qSimpleTree.q0; qSimpleTree.beta0_rad];
qX(locator_s:locator_e -1) = reshape(Q0_and_Rad, [1, dj])/(T0-1);
sX(locator_s0:locator_s1-1) = reshape(qSimpleTree.surf0,[1,ds]);

isAllZeroq1 = all(qSimpleTree.surf0(:) == 0);   
if isAllZeroq1
      Q1_surf= zeros(T0,T0,6);
      Lx1=zeros(T0,T0);
      Ly1=zeros(T0,T0);
else
    [Q1_surf,Lx1,Ly1]=surface_to_tangent(qSimpleTree.surf0);
end

qsX(locator_qs0:locator_qs1-1) = reshape(Q1_surf,[1,2*ds]);

   
fprintf('%d-', locator_e-locator_s);

%store initial position for surface reconstruction
locator_qs0 = locator_qs1;
locator_qs1=locator_qs1+(T0*T0);
qsX(locator_qs0:locator_qs1-1) = reshape(Lx1,[1,T0*T0]);

locator_qs0 = locator_qs1;
locator_qs1=locator_qs1+(T0*T0);
qsX(locator_qs0:locator_qs1-1) = reshape(Ly1,[1,T0*T0]);

locator_qs0 = locator_qs1;
locator_qs1=locator_qs1+(T0*d);
qsX(locator_qs0:locator_qs1-1) = reshape(qSimpleTree.surf0(:,1,:),[1,T0*d]);

locator_qs0 = locator_qs1;
locator_qs1=locator_qs1+(T0*d);
qsX(locator_qs0:locator_qs1-1) = reshape(qSimpleTree.surf0(1,:,:),[1,T0*d]);

% store subtree position
locator_s0 = locator_s1;
locator_s1 = locator_s1 + numel(qSimpleTree.q);

locator_qs0 = locator_qs1;
locator_qs1 = locator_qs1 + numel(qSimpleTree.q);

locator_s = locator_e;
locator_e = locator_s + numel(qSimpleTree.q);

qX(locator_s:locator_e -1) = sqrt(lam_p)*qSimpleTree.sk(1:end);
sX(locator_s0:locator_s1 -1) = sqrt(lam_p)*qSimpleTree.sk(1:end);
qsX(locator_qs0:locator_qs1 -1) = sqrt(lam_p)*qSimpleTree.sk(1:end);

%getting medial axis
locator_qs0 = locator_qs1;
locator_qs1 = locator_qs1 + (T0*d);
qsX(locator_qs0:locator_qs1-1) = reshape(qSimpleTree.q0,[1,T0*d]);

% flatten subtrees
locator_s = locator_e;
locator_s0 = locator_s1;
locator_qs0 = locator_qs1;

for k=1: numel(qSimpleTree.q)

    T0 = size(qSimpleTree.q{k}, 2);
    dj = d*T0 +T0;
    ds=d*T0*T0;
    locator_e = locator_s + dj;
    locator_s1=locator_s0+ds;
    locator_qs1=locator_qs0+2*ds;

    % store trunk
    Qk_and_Rad= [sqrt(lam_s)*qSimpleTree.q{k}; qSimpleTree.beta_rad{k}];
    qX(locator_s:locator_e -1) = reshape(Qk_and_Rad, [1, dj])/(T0-1);
    sX(locator_s0:locator_s1-1) = reshape(qSimpleTree.surf{k},[1,ds]);


    isAllZeroq1 = all(qSimpleTree.surf{k}(:) == 0);   
    if isAllZeroq1
          Q1_surf= zeros(T0,T0,6);
          Lx1=zeros(T0,T0);
          Ly1=zeros(T0,T0);
    else
        [Q1_surf,Lx1,Ly1]=surface_to_tangent(qSimpleTree.surf{k});
    end
    
    qsX(locator_qs0:locator_qs1-1) = reshape(Q1_surf,[1,2*ds]);
    
       
    fprintf('%d-', locator_e-locator_s);
    
    %store initial position for surface reconstruction
    locator_qs0 = locator_qs1;
    locator_qs1=locator_qs1+(T0*T0);
    qsX(locator_qs0:locator_qs1-1) = reshape(Lx1,[1,T0*T0]);
    
    locator_qs0 = locator_qs1;
    locator_qs1=locator_qs1+(T0*T0);
    qsX(locator_qs0:locator_qs1-1) = reshape(Ly1,[1,T0*T0]);
    
    locator_qs0 = locator_qs1;
    locator_qs1=locator_qs1+(T0*d);
    qsX(locator_qs0:locator_qs1-1) = reshape(qSimpleTree.surf{k}(:,1,:),[1,T0*d]);
    
    locator_qs0 = locator_qs1;
    locator_qs1=locator_qs1+(T0*d);
    qsX(locator_qs0:locator_qs1-1) = reshape(qSimpleTree.surf{k}(1,:,:),[1,T0*d]);
   
    %getting medial axis
    locator_qs0 = locator_qs1;
    locator_qs1 = locator_qs1 + (T0*d);
    qsX(locator_qs0:locator_qs1-1) = reshape(qSimpleTree.q{k},[1,T0*d]);

    locator_s = length(qX)+1;
    locator_s0 = length(sX)+1;
    locator_qs0 = length(qsX)+1;

end




end