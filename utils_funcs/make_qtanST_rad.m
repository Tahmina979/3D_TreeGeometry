function Q = make_qtanST_rad(q0,qsurf0,surf0,qnormx0, qnormy0, in_px0, in_py0, q, qsurf,surf,qnormx,qnormy,in_px,in_py, sk,b00, beta0_rad, beta_rad)

if nargin<4
    Q.b00_startP = [0;0;0:0];
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
Q.q = q;
Q.qsurf=qsurf;
Q.surf = surf;
Q.qnormx=qnormx;
Q.qnormy=qnormy;
Q.in_px=in_px;
Q.in_py=in_py;

Q.beta_rad = beta_rad;
Q.sk = sk;

Q.K_sideNum = numel(q);

[Q.dimension,Q.T0_pointNum] = size(q0);

Q.t_paras = linspace(0,1,Q.T0_pointNum);

Q.s = cumtrapz( Q.t_paras, sum(Q.q0.^2,1), 2);
Q.s = Q.s + linspace(0, 1e-4, length(Q.s)); % prevent Q.s to be zero vector
Q.len0 = Q.s(end);
Q.s = Q.s/Q.len0;

Q.tk_sideLocs = interp1(Q.s,Q.t_paras, Q.sk);

Q.tk_sideLocs(isnan(Q.tk_sideLocs))=1;

Q.T_sidePointNums = zeros(1, Q.K_sideNum);
Q.len = zeros(1,Q.K_sideNum);
for k=1:Q.K_sideNum
    Q.T_sidePointNums(k) = size(Q.q{k}, 2);
    t = linspace(0, 1, Q.T_sidePointNums(k));
    Q.len(k) = trapz( t, sum(Q.q{k}.^2,1), 2);
end

Q = orderfields(Q,{'t_paras','s','q0','qsurf0', 'surf0','qnormx0','qnormy0','in_px0','in_py0','T0_pointNum','len0','K_sideNum','q','qsurf','surf','qnormx','qnormy','in_px','in_py','T_sidePointNums',...
    'len','tk_sideLocs','sk','dimension','b00_startP', 'beta0_rad', 'beta_rad'});