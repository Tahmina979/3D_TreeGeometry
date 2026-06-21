function [qX,sX,qsX] = flattenQCompTree_4layers_rad(qCompTree_4Ls, lam_m, lam_s, lam_p)

% qX = zeros(n,p);
d = 3;
locator_s= 0;
locator_e = 0;

locator_s = 1;
locator_s0=1;
locator_qs0=1;
T0 = qCompTree_4Ls.T0_pointNum;
dj = d*T0 + T0;
ds=d*T0*T0;
locator_e = locator_s + dj;
locator_s1=locator_s0+ds;
locator_qs1=locator_s0+2*ds;


% store trunk
Q0_and_Rad= [sqrt(lam_m)*qCompTree_4Ls.q0; qCompTree_4Ls.beta0_rad];
qX(locator_s:locator_e -1) = reshape(Q0_and_Rad, [1, dj])/(T0-1);
sX(locator_s0:locator_s1-1) = reshape(qCompTree_4Ls.surf0,[1,ds]);

isAllZeroq1 = all(qCompTree_4Ls.surf0(:) == 0);   
if isAllZeroq1
      Q1_surf= zeros(T0,T0,6);
      Lx1=zeros(T0,T0);
      Ly1=zeros(T0,T0);
else
    [Q1_surf,Lx1,Ly1]=surface_to_tangent(qCompTree_4Ls.surf0);
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
qsX(locator_qs0:locator_qs1-1) = reshape(qCompTree_4Ls.surf0(:,1,:),[1,T0*d]);

locator_qs0 = locator_qs1;
locator_qs1=locator_qs1+(T0*d);
qsX(locator_qs0:locator_qs1-1) = reshape(qCompTree_4Ls.surf0(1,:,:),[1,T0*d]);

    
fprintf('%d-', locator_e-locator_s);
% store subtree position
locator_s0 = locator_s1;
locator_s1 = locator_s1 + numel(qCompTree_4Ls.q_children);

locator_qs0 = locator_qs1;
locator_qs1 = locator_qs1 + numel(qCompTree_4Ls.q_children);

locator_s = locator_e;
locator_e = locator_s + numel(qCompTree_4Ls.q_children);

qX(locator_s:locator_e -1) = sqrt(lam_p)*qCompTree_4Ls.sk(1:end);
sX(locator_s0:locator_s1 -1) = sqrt(lam_p)*qCompTree_4Ls.sk(1:end);
qsX(locator_qs0:locator_qs1 -1) = sqrt(lam_p)*qCompTree_4Ls.sk(1:end);

%getting medial axis
locator_qs0 = locator_qs1;
locator_qs1 = locator_qs1 + (T0*d);
qsX(locator_qs0:locator_qs1-1) = reshape(qCompTree_4Ls.q0,[1,T0*d]);

% flatten subtrees
locator_s = locator_e;
locator_s0 = locator_s1;
locator_qs0 = locator_qs1;

for k=1: numel(qCompTree_4Ls.q_children)

    
    [qX,sX,qsX] = flattenQCompTree_3layers_rad(qCompTree_4Ls.q_children{k}, lam_m, lam_s, lam_p, qX, sX, qsX, locator_s,locator_s0,locator_qs0);

    locator_s =length(qX)+1;
    locator_s0 =length(sX)+1;
    locator_qs0 =length(qsX)+1;
%     locator_e = locator_s+ numel(qX_children);
% 
%     qX(locator_s:locator_e-1) = qX_children;
%     
%     fprintf('%d-', locator_e-locator_s);
end

fprintf('\n');

            
end

