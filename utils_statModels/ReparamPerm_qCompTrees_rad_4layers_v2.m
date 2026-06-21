% Algorithm 2 in paper
function [G,qCompTree_4Ls1p, qCompTree_4Ls2] = ReparamPerm_qCompTrees_rad_4layers_v2(qCompTree_4Ls1,qCompTree_4Ls2, lam_m,lam_s,lam_p)

% Pad minor trees
[qCompTree_4Ls1, qCompTree_4Ls2] = CompatMax_rad_4layers(qCompTree_4Ls1, qCompTree_4Ls2);


%%%%% MATCH SIDES %%%%% 
K1 = qCompTree_4Ls1.K_sideNum;
K2 = qCompTree_4Ls2.K_sideNum;

s1k = qCompTree_4Ls1.sk;
s2k = qCompTree_4Ls2.sk;

% build matching energy and side-branch reparameterization matrices
%% Ducun's method

% --- Energy matrix computation ---
gam_side_all = cell(K1,K2);

E = zeros(K1, K2);

for i=1:K1
    fprintf('%d...',i);
    for j=1:K2

        [G, ~] = ReparamPerm_qCompTrees_rad_3layers_v2(qCompTree_4Ls1.q_children{i}, ...
                                                        qCompTree_4Ls2.q_children{j}, lam_m, lam_s, lam_p);
        Eside = sqrt(G.E);
      
        E(i,j) = lam_s*Eside + lam_p*(s1k(i)-s2k(j)).^2;
    end
 
end

%% optimize assignment, Compute correspondence
% a = tic;
[Mvec,Efin] = munkres(E);

% get list of matched pairs and unmatched from munkres output
matched = zeros(0,2);

gam_side = cell(1,0);

for i=1:K1
    matched = [matched; i,Mvec(i)];
end


%%

[qCompTree_4Ls1p.surf0]=global_reparm(qCompTree_4Ls1.surf0,qCompTree_4Ls2.surf0,qCompTree_4Ls1.srnf0,qCompTree_4Ls2.srnf0);

[Anew,normal_new,multfactnew,sqrtmultfactnew] = area_surf(qCompTree_4Ls1p.surf0);
qCompTree_4Ls1p.srnf0 = surface_to_q(normal_new,sqrtmultfactnew);

% q0 q-curve diff
[gam0, Emain] = DPQ_difflen(qCompTree_4Ls1p.srnf0, qCompTree_4Ls2.srnf0,qCompTree_4Ls1p.surf0, qCompTree_4Ls2.surf0);  % --- DPQ_difflen computes the difference between two q-space branch.

Etotal = lam_m* Emain + Efin;

G = struct('E',Etotal, 'gam0',gam0, 'matched',matched);

%%%%% TRANSFORM qCompTree_4Ls1 %%%%%
%%% q0, t

qCompTree_4Ls1p.q0 = qCompTree_4Ls1.q0;

qCompTree_4Ls1p.surf0=Apply_Gamma_Surf(qCompTree_4Ls1p.surf0,gam0,size(qCompTree_4Ls1p.surf0,1));

[Anew,normal_new,multfactnew,sqrtmultfactnew] = area_surf(qCompTree_4Ls1p.surf0);
qCompTree_4Ls1p.srnf0 = surface_to_q(normal_new,sqrtmultfactnew);


qCompTree_4Ls1p.t_paras = qCompTree_4Ls1.t_paras;

qCompTree_4Ls1p.beta0_rad =  qCompTree_4Ls1.beta0_rad;

%% s, len0
qCompTree_4Ls1p.s = qCompTree_4Ls1.s;
qCompTree_4Ls1p.len0 = qCompTree_4Ls1p.s(end);

%if qCompTree_4Ls1p.len0 == 0
    %qCompTree_4Ls1p.s = qCompTree_4Ls1p.t_paras*0.00001;
%else
   % qCompTree_4Ls1p.s = qCompTree_4Ls1p.s/qCompTree_4Ls1p.len0;
%end



m = size(matched,1);
K = m;

%%% qi -- order is [((order of q2)), unmatched1] and q_children
qCompTree_4Ls1p.q = cell(1,K);
qCompTree_4Ls1p.q_children = cell(1, K);
qCompTree_4Ls1p.beta_rad = cell(1, K);
qCompTree_4Ls1p.surf= cell(1, K);
qCompTree_4Ls1p.srnf= cell(1, K);

for i=1:m
   
    qCompTree_4Ls1p.q_children{matched(i,2)} = qCompTree_4Ls1.q_children{matched(i,1)}; 

    qCompTree_4Ls1p.q_children{matched(i,2)}.q0 = qCompTree_4Ls1.q{matched(i,1)};
    qCompTree_4Ls1p.q_children{matched(i,2)}.surf0=qCompTree_4Ls1.surf{matched(i,1)};
    qCompTree_4Ls1p.q_children{matched(i,2)}.srnf0=qCompTree_4Ls1.srnf{matched(i,1)};

    qCompTree_4Ls1p.q{matched(i,2)} = qCompTree_4Ls1.q{matched(i,1)};
    qCompTree_4Ls1p.surf{matched(i,2)} = qCompTree_4Ls1.surf{matched(i,1)};
    qCompTree_4Ls1p.srnf{matched(i,2)} = qCompTree_4Ls1.srnf{matched(i,1)}; 

    qCompTree_4Ls1p.beta_rad{matched(i,2)} = qCompTree_4Ls1.beta_rad{matched(i,1)};
                                            
end


%%% tk, sk
qCompTree_4Ls1p.tk_sideLocs = qCompTree_4Ls1.tk_sideLocs;%zeros(1,K);
qCompTree_4Ls1p.sk = zeros(1,K);

% matched,unmatched1 just get updated by gam0
tk1p = qCompTree_4Ls1p.tk_sideLocs;%interp1(G.gam0, qCompTree_4Ls1p.t_paras, qCompTree_4Ls1.tk_sideLocs);
sk1p = interp1(qCompTree_4Ls1p.t_paras, qCompTree_4Ls1p.s, tk1p);

for i=1:m
    qCompTree_4Ls1p.tk_sideLocs(matched(i,2)) = tk1p(matched(i,1)');
    qCompTree_4Ls1p.sk(matched(i,2)) = sk1p(matched(i,1)');
end

%%% K
qCompTree_4Ls1p.K_sideNum = K;

%%% T0
qCompTree_4Ls1p.T0_pointNum = qCompTree_4Ls2.T0_pointNum;

%%% T
qCompTree_4Ls1p.T_sidePointNums = [];
for i=1:K
    qCompTree_4Ls1p.T_sidePointNums(i) = size(qCompTree_4Ls1p.q{i},2);
end

%%% len
% qCompTree_4Ls1p.len = zeros(1,K);
qCompTree_4Ls1p.len = [];
for k=1:K
    qCompTree_4Ls1p.len(k) = trapz( sum(qCompTree_4Ls1p.q{k}.^2,1) / (qCompTree_4Ls1p.T_sidePointNums(k)-1) );
end

%%% d
qCompTree_4Ls1p.dimension = qCompTree_4Ls1.dimension;

%%% b00
qCompTree_4Ls1p.b00_startP = qCompTree_4Ls1.b00_startP;

% if isfield(qCompTree_4Ls1p, 'q_children') == 0
%     qCompTree_4Ls1p.q_children = cell(1, 0);
% end
qCompTree_4Ls1p = orderfields(qCompTree_4Ls1p, ...
    {'t_paras','s','q0','srnf0','surf0','T0_pointNum','len0','K_sideNum','q','srnf','surf','T_sidePointNums','len','tk_sideLocs','sk','dimension','b00_startP','q_children', 'beta0_rad', 'beta_rad'});

%% --- Do the matching of layer 2 and layer 3 ---

% ---
for i = 1: numel(qCompTree_4Ls1p.q_children)
    
   [~, qCompTree_4Ls1p.q_children{i}, qCompTree_4Ls2.q_children{i}] = ...
                           ReparamPerm_qCompTrees_rad_3layers_v2(qCompTree_4Ls1p.q_children{i}, qCompTree_4Ls2.q_children{i}, ...
                                                                lam_m,lam_s,lam_p);
    
    % Reset q and beta_rad                                                          
    [qCompTree_4Ls1p, qCompTree_4Ls2] = ResetqCompTree_q_and_beta_rad(qCompTree_4Ls1p, qCompTree_4Ls2);
                            
end




end

