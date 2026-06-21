function [Q1p,Q2p] = CompatMax_rad(Q1,Q2)


%%% main branch
T0_pointNum = max(Q1.T0_pointNum, Q2.T0_pointNum);
t = linspace(0,1,T0_pointNum);

% q0
if Q1.T0_pointNum<T0_pointNum
    q0_1 = interp1(Q1.t_paras,Q1.q0', t)'; 
    beta0_rad_1 = interp1(Q1.t_paras, Q1.beta0_rad, t);
    if isnan(q0_1(:, T0_pointNum))
        q0_1(:,T0_pointNum)=Q1.q0(:,Q1.T0_pointNum);
        beta0_rad_1(T0_pointNum)=Q1.beta0_rad(Q1.T0_pointNum);
       
    end
    q0_2 = Q2.q0;
    beta0_rad_2 = Q2.beta0_rad;
elseif Q2.T0_pointNum<T0_pointNum
    q0_1 = Q1.q0;
    beta0_rad_1 = Q1.beta0_rad;
    
    q0_2 = interp1(Q2.t_paras,Q2.q0', t)';
    beta0_rad_2 = interp1(Q2.t_paras, Q2.beta0_rad, t);
     if isnan(q0_2(:, T0_pointNum))
        q0_2(:,T0_pointNum)=Q2.q0(:,Q2.T0_pointNum);
        beta0_rad_2(T0_pointNum)=Q2.beta0_rad(Q2.T0_pointNum);
       
    end
else
    q0_1 = Q1.q0; 
    srnf0_1=Q1.srnf0;
    surf0_1=Q1.surf0;
    beta0_rad_1 = Q1.beta0_rad;
    q0_2 = Q2.q0; 
    srnf0_2 = Q2.srnf0;
    surf0_2=Q2.surf0;
    beta0_rad_2 = Q2.beta0_rad;
end

%%% side branches
Km = min(Q1.K_sideNum,Q2.K_sideNum);
K = max(Q1.K_sideNum,Q2.K_sideNum);


T = max( Q1.T_sidePointNums(1:Km), Q2.T_sidePointNums(1:Km) );
if Q1.K_sideNum>Km
    T = [T, Q1.T_sidePointNums(Km+1:end)];
elseif Q2.K_sideNum>Km
    T = [T, Q2.T_sidePointNums(Km+1:end)];
end

% beta rad
beta_rad_1 = Q1.beta_rad;
beta_rad_2 = Q2.beta_rad;
if Q1.K_sideNum<K
    beta_rad_1 = [beta_rad_1, beta_rad_2(Km+1:K)];
elseif Q2.K_sideNum<K
    beta_rad_2 = [beta_rad_2, beta_rad_1(Km+1:K)];
end


% q
q_1 = cell(1,K);
q_2 = cell(1,K);
srnf_1 = cell(1,K);
surf_1 = cell(1,K);
srnf_2 = cell(1,K);
surf_2 = cell(1,K);
for k=1:Km
%     T1 = Q1.T_sidePointNums(k); T2 = Q2.T_sidePointNums(k);
    T1 = size(Q1.q{k}, 2); T2 = size(Q2.q{k}, 2); maxT=max(T1, T2);
    tau = linspace(0,1,maxT);
    if T1 < maxT
        disp('here')
        q_1{k} = interp1( linspace(0,1,T1),Q1.q{k}', tau )';
        beta_rad_1{k} = interp1(linspace(0,1,T1), Q1.beta_rad{k}, tau);
        q_2{k} = Q2.q{k};
    elseif T2 < maxT
        q_1{k} = Q1.q{k};
        q_2{k} = interp1( linspace(0,1,T2), Q2.q{k}', tau )';
        beta_rad_2{k} = interp1(linspace(0,1,T2), Q2.beta_rad{k}, tau);
    else
        q_1{k} = Q1.q{k};
        srnf_1{k}=Q1.srnf{k};
        surf_1{k}=Q1.surf{k};
        q_2{k} = Q2.q{k};
        srnf_2{k}=Q2.srnf{k};
        surf_2{k}=Q2.surf{k};
    end
end

if Q1.K_sideNum<K
    for k=Km+1:K
        Q1.dimension = 3;
        q_1{k} = zeros(Q1.dimension,size(Q2.q{k}, 2));
        srnf_1{k}=zeros(size(Q2.srnf{k},1),size(Q2.srnf{k},2),size(Q2.srnf{k},3));
        surf_1{k}=zeros(size(Q2.surf{k},1),size(Q2.surf{k},2),size(Q2.surf{k},3));
        q_2{k} = Q2.q{k};
        srnf_2{k}=Q2.srnf{k};
        surf_2{k}=Q2.surf{k};
    end
elseif Q2.K_sideNum<K
    for k=Km+1:K
        q_1{k} = Q1.q{k};
        srnf_1{k} = Q1.srnf{k};
        surf_1{k} = Q1.surf{k};
        Q2.dimension=3;
        q_2{k} = zeros(Q2.dimension,size(Q1.q{k}, 2));
        srnf_2{k}=zeros(size(Q1.srnf{k},1),size(Q1.srnf{k},2),size(Q1.srnf{k},3));
        surf_2{k}=zeros(size(Q1.surf{k},1),size(Q1.surf{k},2),size(Q1.surf{k},3));
    end
end

% sk
sk_1 = Q1.sk;
sk_2= Q2.sk;
if Q1.K_sideNum<K
    sk_1 = [sk_1, sk_2(Km+1:K)];
elseif Q2.K_sideNum<K

    sk_2 = [sk_2, sk_1(Km+1:K)];
end

% make return values
Q1p = make_qST_rad(q0_1,srnf0_1,surf0_1, q_1, srnf_1, surf_1, sk_1,Q1.b00_startP, beta0_rad_1, beta_rad_1);
Q2p = make_qST_rad(q0_2,srnf0_2,surf0_2, q_2, srnf_2, surf_2, sk_2,Q2.b00_startP, beta0_rad_2, beta_rad_2);

end