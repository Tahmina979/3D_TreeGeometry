function Q = make_qtanCompTree_rad_4layers(q0,qsurf0,surf0,qnormx0,qnormy0,in_px0,in_py0,q_children,sk,b00, beta0_rad, beta_rad)

if nargin<4
    Q.b00_startP = [0;0;0;0];
else
    Q.b00_startP = b00;
end

Q.q0 = q0;
Q.qsurf0=qsurf0;
Q.surf0=surf0;
Q.qnormx0=qnormx0;
Q.qnormy0=qnormy0;
Q.in_px0=in_px0;
Q.in_py0=in_py0;

Q.beta0_rad = beta0_rad;
Q.q_children = q_children;
Q.beta_rad = beta_rad;
% avoid sk to be negative
sk(sk<0) = 0;
Q.sk = sk;

Q.K_sideNum = numel(q_children);
[Q.dimension,Q.T0_pointNum] = size(q0);

Q.t_paras = linspace(0,1,Q.T0_pointNum);

Q.s = cumtrapz( Q.t_paras, sum(Q.q0.^2,1), 2);

Q.len0 = Q.s(end);

Q.s = Q.s/Q.len0;

Q.tk_sideLocs = interp1(Q.s,Q.t_paras, Q.sk);
Q.tk_sideLocs(isnan(Q.tk_sideLocs))=1;
 

Q.T_sidePointNums = zeros(1, Q.K_sideNum);
Q.len = zeros(1, Q.K_sideNum);

for k=1:Q.K_sideNum
    Q.q{k} = Q.q_children{k}.q0;
    Q.qsurf{k}=Q.q_children{k}.qsurf0;
    Q.surf{k}=Q.q_children{k}.surf0;
     Q.qnormx{k}=Q.q_children{k}.qnormx;
      Q.qnormy{k}=Q.q_children{k}.qnormy;
       Q.in_px{k}=Q.q_children{k}.in_px;
        Q.in_py{k}=Q.q_children{k}.in_py;
    Q.T_sidePointNums(k) = size(Q.q{k}, 2);
    t = linspace(0, 1, Q.T_sidePointNums(k));
    Q.len(k) = trapz( t, sum(Q.q{k}.^2,1), 2);
end

Q = orderfields(Q,{'t_paras','s','q0','qsurf0','surf0','qnormx0','qnormy0','in_px0','in_py0','T0_pointNum','len0', 'K_sideNum','q','qsurf','surf','qnormx','qnormy','in_px','in_py','T_sidePointNums','len', ...
    'tk_sideLocs','sk','dimension','b00_startP', 'beta0_rad', 'beta_rad','q_children'});

