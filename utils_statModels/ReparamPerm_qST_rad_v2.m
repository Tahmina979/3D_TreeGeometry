% Algorithm 2 in paper
function [G,qST1p, qST2] = ReparamPerm_qST_rad_v2(qST1,qST2, lam_m,lam_s,lam_p)
% function [matched,Etotal,E] = ReparamPerm_qST(qST1,qST2, lam_m,lam_s,lam_p)

% pad trees
[qST1, qST2] = CompatMax_rad(qST1, qST2);

%%%%% MATCH SIDES %%%%% 
K1 = qST1.K_sideNum;
K2 = qST2.K_sideNum;

s1k = qST1.sk;
s2k = qST2.sk;

% build matching energy and side-branch reparameterization matrices
% % --- Case1: The matrix E1 is K1 * K2 ---
% K1 is identical to K2 
A1 = tic;
A2 = tic;
gam_side_all = cell(K1,K2);
E = zeros(K1, K2);
for i=1:K1
    %fprintf('%d...',i);
    for j=1:K2
        
        % q-curve diff
        [gam_side_all{i,j}, Eside] = cacl_dist_last_layer(qST1.srnf{i},qST2.srnf{j});% DPQ_difflen(qST1.srnf{i},qST2.srnf{j},qST1.surf{i},qST2.surf{j});
        E(i,j) = lam_s*Eside + lam_p*(s1k(i)-s2k(j)).^2;
    end
end


t1_2 = toc(A2);     % --- t1_2 is the just the time of computing DM ---


% optimize assignment
% A = tic;
[Mvec,Efin] = munkres(E);

% t1_1 = toc(A1);   % --- t1_1 is sum time of computing DM and LA ---
% t1_3 = t1_1 - t1_2;

% disp(['time cost for ', num2str(K1), '*', num2str(K2), 'Matrix-LA is ', ......
%                                                 num2str(t1), '-secondes']);
 
matched = zeros(0,2);

gam_side = cell(1,0);
for i=1:K1
    matched = [matched; i,Mvec(i)];
    gam_side = [gam_side, gam_side_all{i,Mvec(i)}];

end                                                
qST1p = struct;
%fprintf('\nAlign main...\n');
%normalize for global reparameterization, for higher layer where the
%branches are very thin, we can ignore local reparameterization
first_ring=reshape(qST1.surf0(1,:,:),[size(qST1.surf0,1),3]);
center1=mean(first_ring,1);
qST1.surf0=qST1.surf0-reshape(center1,1,1,3);

first_ring=reshape(qST2.surf0(1,:,:),[size(qST2.surf0,1),3]);
center2=mean(first_ring,1);
surf2=qST2.surf0-reshape(center2,1,1,3);

[qST1p.surf0]=global_reparm(qST1.surf0,surf2,qST1.srnf0,qST2.srnf0);
qST1p.surf0=qST1p.surf0+reshape(center1,1,1,3);

isAllZero = all(qST1p.surf0(:) == 0);
if isAllZero
    qST1p.srnf0 = zeros(size(qST1p.surf0,1),size(qST1p.surf0,2),size(qST1p.surf0,3));
else
    [Anew,normal_new,multfactnew,sqrtmultfactnew] = area_surf(qST1p.surf0);
    qST1p.srnf0 = surface_to_q(normal_new,sqrtmultfactnew);
end
% q0 q-curve diff
[gam0, Emain] =  cacl_dist_last_layer(qST1p.srnf0,qST2.srnf0);%DPQ_difflen(qST1.srnf0,qST2.srnf0,qST1.surf0,qST2.surf0);  % --- DPQ_difflen computes the difference between two q-space branch.

Etotal = lam_m*Emain+Efin;


G = struct('E',Etotal, 'gam0',gam0, 'gam',{gam_side}, ...
    'matched',matched);

%%%%% TRANSFORM qST1 %%%%%
%%% q0, t


qST1p.q0 = qST1.q0;
%qST1p.surf0=Apply_Gamma_Surf(qST1.surf0,gam0,size(qST1.surf0,1));


%isAllZero = all(qST1p.surf0(:) == 0);
%if isAllZero
     %qST1p.srnf0 = zeros(size(qST1p.surf0,1),size(qST1p.surf0,2),size(qST1p.surf0,3));
%else
    %[Anew,normal_new,multfactnew,sqrtmultfactnew] = area_surf(qST1p.surf0);
    %qST1p.srnf0 = surface_to_q(normal_new,sqrtmultfactnew);
%end


qST1p.t_paras = qST1.t_paras;
qST1p.beta0_rad = qST1.beta0_rad;

%%% s, len0
qST1p.s = qST1.s;
%qST1p.s = cumtrapz(qST1p.t_paras, sum(qST1p.q0.^2,1) );

%qST1p.s = qST1p.s + linspace(0, 1e-4, length(qST1p.s));
qST1p.len0 = qST1p.s(end);
%qST1p.s = qST1p.s/qST1p.len0;



m = size(matched,1);

K = m;
%%% qi -- order is [((order of q2)), unmatched1]
qST1p.q = cell(1,m);
qST1p.surf = cell(1,m);
qST1p.srnf = cell(1,m);
qST1p.beta_rad = cell(1,m);
for i=1:m
    qST1p.q{matched(i,2)} = qST1.q{matched(i,1)};

    first_ring=reshape(qST1.surf{matched(i,1)}(1,:,:),[size(qST1.surf{matched(i,1)},1),3]);
    center1=mean(first_ring,1);
    qST1.surf{matched(i,1)}=qST1.surf{matched(i,1)}-reshape(center1,1,1,3);
    
    first_ring=reshape(qST2.surf{i}(1,:,:),[size(qST2.surf{i},1),3]);
    center2=mean(first_ring,1);
    surf2=qST2.surf{i}-reshape(center2,1,1,3);

    [qST1p.surf{matched(i,2)}]=global_reparm(qST1.surf{matched(i,1)},surf2,qST1.srnf{matched(i,1)},qST2.srnf{i});
    qST1p.surf{matched(i,2)}=qST1p.surf{matched(i,2)}+reshape(center1,1,1,3);
    
    isAllZero = all(qST1p.surf{matched(i,2)}(:) == 0);
    if isAllZero
        qST1p.srnf{matched(i,2)} = zeros(size(qST1p.surf{matched(i,2)},1),size(qST1p.surf{matched(i,2)},2),size(qST1p.surf{matched(i,2)},3));
    else
        [Anew,normal_new,multfactnew,sqrtmultfactnew] = area_surf(qST1p.surf{matched(i,2)});
        qST1p.srnf{matched(i,2)} = surface_to_q(normal_new,sqrtmultfactnew);
    end
    
    
    
    qST1p.beta_rad{matched(i,2)} = qST1.beta_rad{matched(i,1)};
end

%%% tk, sk
qST1p.tk_sideLocs = qST1.tk_sideLocs;%zeros(1,K);
qST1p.sk = zeros(1,K);

% matched,unmatched1 just get updated by gam0
tk1p = qST1p.tk_sideLocs;%interp1(G.gam0, qST1p.t_paras, qST1.tk_sideLocs);
sk1p = interp1(qST1p.t_paras, qST1p.s, tk1p);
for i=1:m
    qST1p.tk_sideLocs(matched(i,2)) = tk1p(matched(i,1)');
    qST1p.sk(matched(i,2)) = sk1p(matched(i,1)');
end


%%% K
qST1p.K_sideNum = K;

%%% T0
qST1p.T0_pointNum = qST1.T0_pointNum;

%%% T
qST1p.T_sidePointNums = [];
for i=1:K
    qST1p.T_sidePointNums(i) = size(qST1p.q{i},2);
end

%%% len
qST1p.len = zeros(1,K);
for k=1:K
    qST1p.len(k) = trapz( sum(qST1p.q{k}.^2,1) / (qST1p.T_sidePointNums(k)-1) );
end

%%% d
qST1p.dimension = qST1.dimension;

%%% b00
qST1p.b00_startP = qST1.b00_startP;


qST1p = orderfields(qST1p, ...
    {'t_paras','s','q0','surf0','srnf0','T0_pointNum','len0','K_sideNum','q','srnf','surf','T_sidePointNums','len',...
    'tk_sideLocs','sk','dimension','b00_startP','beta0_rad', 'beta_rad'});


end

