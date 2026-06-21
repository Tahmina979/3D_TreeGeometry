function [A, qA,time_s] = GeodSimpleTreesPrespace_rad(Q1, Q2, geo_param,time_s, start_origin, weights)

if nargin < 6,
    weights = [1, 1, 1]; 
end

if nargin<5
    start_origin = true;
end

lam_m = weights(1);
lam_s = weights(2);
lam_p = weights(3); 

% if Q1.T0 ~= Q2.T0
%     error('Incompatible main branch discretizations.');
% end
% 
% K = min(Q1.K , Q2.K);
% 
% if any(Q1.T(1:K) ~= Q2.T(1:K))
%     error('Incompatible side branch discretizations.');
% end

if size(geo_param)==1
    stp = geo_param;
    R   = linspace(0,1,stp);
else
    R   = geo_param;
    stp = numel(R);
end

qA = cell(1,stp);
A  = cell(1,stp);

% endpoints of L2-prespace trees
if Q1.K_sideNum < Q2.K_sideNum
    qA{1} = AddZeroBranches(Q2,Q1);
    qA{stp} = Q2;
else
    qA{1}   = Q1;
    qA{stp} = Q2;   %AddZeroBranches(Q1,Q2);
end

if start_origin
    qA{1}.b00_startP   = zeros(Q1.dimension,1);
    qA{end}.b00_startP = zeros(Q1.dimension,1);
end
%[qA{1}.surf0]=norm_local_rot(qA{1}.surf0,qA{stp}.surf0);

% these values will be the same across the whole geod
K  = qA{1}.K_sideNum;
T0 = qA{1}.T0_pointNum;
T  = qA{1}.T_sidePointNums;
t  = qA{1}.t_paras;

% % compute endpoints of bp positions on
% % relative arc-length parameterizations of main
% t = linspace(0,1,T0);
% s = cumtrapz( t, sum(qA{1}.q0.^2,1) ) / qA{1}.len0;
% sk1 = s(qA{1}.bp);
% s = cumtrapz( t, sum(qA{end}.q0.^2,1) ) / qA{end}.len0;
% sk2 = s(qA{end}.bp);

% [qA{1}.sk,qA{end}.sk]
% [numel(qA{1}.sk),numel(qA{end}.sk)]
% [qA{1}.K,qA{end}.K]

for i=1:stp
    r = R(i);
    
%     %% ============ Updated at Feb.29th ====
%     dist = acos(InnerProd_Q(qA{1}.q0, qA{stp}.q0));
%     ss = dist*r;
%     q0 = (sin(dist - ss)*qA{1}.q0 ...
%                         + sin(ss)*qA{stp}.q0)/sin(dist);
    %%% =====================

    %%% main branch: q0,s,len0
    q0 = qA{1}.q0 + r * (qA{stp}.q0 - qA{1}.q0); %  (1-r)*qA{1}.q0 + r*qA{stp}.q0;
    surf0=qA{1}.surf0 + r * (qA{stp}.surf0 - qA{1}.surf0);
    srnf0=qA{1}.srnf0 + r * (qA{stp}.srnf0 - qA{1}.srnf0);
    isAllZeroq1 = all(qA{1}.surf0(:) == 0);
    isAllZeroq2 = all(qA{stp}.surf0(:) == 0);
    
    t1=tic;
    [Q1_surf,Lx1,Ly1]=surface_to_tangent(qA{1}.surf0);
    [Q2_surf,Lx2,Ly2]=surface_to_tangent(qA{stp}.surf0);

    if isAllZeroq1
      Q1_surf= zeros(size(qA{1}.surf0,1),size(qA{1}.surf0,2),6);
    end
    if isAllZeroq2
      Q2_surf= zeros(size(qA{stp}.surf0,1),size(qA{stp}.surf0,2),6);
    end
    t2=toc(t1);
    time_s=time_s+t2;

    qsurf0=(1-r)*Q1_surf+r*Q2_surf;
    qnormx0=(1-r)*Lx1+r*Lx2;
    qnormy0=(1-r)*Ly1+r*Ly2;
    in_px0=(1-r)*qA{1}.surf0(:,1,:)+r*qA{stp}.surf0(:,1,:);
    in_py0=(1-r)*qA{1}.surf0(1,:,:)+r*qA{stp}.surf0(1,:,:);
    
    s  = cumtrapz(t, sum(q0.^2,1));
    s = s + linspace(0, 1e-4, length(s));
    len0 = s(end);
    if len0 ~= 0
        s = s/s(end);
    end
    beta0_rad = (1-r)*qA{1}.beta0_rad + r*qA{stp}.beta0_rad;
    sk = qA{end}.sk;%qA{1}.sk + lam_p * r * (qA{end}.sk - qA{1}.sk); %  (1-r)*qA{1}.sk + r*qA{end}.sk;
    
    tk = interp1(s,t,sk);
    %%% side branches: q,len
    q = cell(1,K);
   
    surf=cell(1,K);
    srnf=cell(1,K);
    qsurf=cell(1,K);
    qnormx=cell(1,K);
    qnormy=cell(1,K);
    in_px=cell(1,K);
    in_py=cell(1,K);
    len = zeros(1,K);
    beta_rad = cell(1, K);
    for j=1:K
        if size(qA{1}.q{j},2)~= size(qA{stp}.q{j},2)
            tmp_gam    = DPQ_difflen(qA{1}.q{j}, qA{stp}.q{j});
            qA{1}.beta_rad{j} = interp1(linspace(0, 1, size(qA{1}.q{j}, 2)), ...
                                        qA{1}.beta_rad{j}, tmp_gam);
           qA{1}.q{j} = GammaActionQ(qA{1}.q{j}, tmp_gam);     % --- here we do again the re-para to make it safe ---
        %    q{j}       = qA{1}.q{j} + lam_s * r * (qA{stp}.q{j} - qA{1}.q{j}) ; % (1-r)*qA{1}.q{j} + r*qA{stp}.q{j};
        %else
        %    q{j} = (1-r)*qA{1}.q{j} + r*qA{stp}.q{j};
        end  
        

%       %%%================== Added at Feb.9th: sin interpolation ===========
%         dist = acos(InnerProd_Q(qA{1}.q{j}, qA{stp}.q{j}));
%         ss = dist*r;
%         q{j} = (sin(dist - ss)*qA{1}.q{j} ...
%                             + sin(ss)*qA{stp}.q{j})/sin(dist);

        q{j} = (1-r)*qA{1}.q{j} + r*qA{stp}.q{j};
        %[qA{1}.surf{j}]=norm_local_rot(qA{1}.surf{j},qA{stp}.surf{j});
        surf{j} = (1-r)*qA{1}.surf{j} + r*qA{stp}.surf{j};
        srnf{j} = (1-r)*qA{1}.srnf{j} + r*qA{stp}.srnf{j};
        isAllZeroq1 = all(qA{1}.surf{j}(:) == 0);
        isAllZeroq2 = all(qA{stp}.surf{j}(:) == 0);
        t1=tic;
        [Q1_surf,Lx1,Ly1]=surface_to_tangent(qA{1}.surf{j});
        [Q2_surf,Lx2,Ly2]=surface_to_tangent(qA{stp}.surf{j});

        if isAllZeroq1
          Q1_surf= zeros(size(qA{1}.surf{j},1),size(qA{1}.surf{j},2),6);
        end
        if isAllZeroq2
          Q2_surf= zeros(size(qA{stp}.surf{j},1),size(qA{stp}.surf{j},2),6);
        end
        t2=toc(t1);
        time_s=time_s+t2;
        qsurf{j}=(1-r)*Q1_surf+r*Q2_surf;
        qnormx{j}=(1-r)*Lx1+r*Lx2;
        qnormy{j}=(1-r)*Ly1+r*Ly2;

        in_px{j}=(1-r)*qA{1}.surf{j}(:,1,:)+r*qA{stp}.surf{j}(:,1,:);
        in_py{j}=(1-r)*qA{1}.surf{j}(1,:,:)+r*qA{stp}.surf{j}(1,:,:);
            
            
        
%         len(j) = trapz(sum(q{j}.^2,1))/(T(j)-1);
        %%%===================
%         q{j}   = qA{1}.q{j} + lam_s * r * (qA{stp}.q{j} - qA{1}.q{j}) ; % (1-r)*qA{1}.q{j} + r*qA{stp}.q{j};
        beta_rad{j} = (1-r)*qA{1}.beta_rad{j} + r*qA{stp}.beta_rad{j};
     
        T(j) = size(qA{1}.q{j}, 2);
        len(j) = trapz(sum(q{j}.^2,1))/(T(j)-1);
    end
    
    %%% branch points -- interpolate sk over arc-length
  
%     if s(end) == 0
%         tk = sk;
%     else
%         tk = interp1(s,t,sk);
%     end
%     tk = sk;
%     tk = sk;
%     s = cumtrapz( t, sum(q0.^2,1) ) / len0;
%     bp = round( interp1(s,1:T0,sk) );
    
    b00 = (1-r)*qA{1}.b00_startP + r*qA{stp}.b00_startP;        %% what is this?
    
    qA{i} = struct('t_paras',t, 's',s, 'surf0',surf0,'srnf0',srnf0,'q0',q0, 'qsurf0',qsurf0,'qnormx0',qnormx0,'qnormy0',qnormy0,'in_px0',in_px0,'in_py0',in_py0,'T0_pointNum',T0, 'len0',len0,...
         'K_sideNum',K, 'q',{q},'surf', {surf},'srnf',{srnf},'qsurf',{qsurf},'qnormx',{qnormx},'qnormy',{qnormy},'in_px',{in_px},'in_py',{in_py},'T_sidePointNums',T, 'len',len, 'tk_sideLocs',tk, 'sk',sk,... 
        'dimension',3, 'b00_startP',b00, 'beta0_rad', {beta0_rad}, 'beta_rad', {beta_rad});
end

% convert to AC-space (original trees)
% for i=1:stp
%     A{i} = qSimpleTree_to_SimpleTree(qA{i});
% end

% --- rewritten by me ---
% A{stp} = qSimpleTree_to_SismpleTree(Q2);

