function ST = qST_to_ST_rad(qST, l)

ST = qST;
% ST = rmfield(qST, {'q','q0','b00','len','len0','s','sk'});

ST.beta0 = q_to_curve(qST.q0) + repmat(qST.b00_startP, 1, size(qST.q0, 2));
isAllZeroq1 = all(qST.qsurf0(:) == 0);
if isAllZeroq1
    ST.surf0=qST.qsurf0(:,:,1:3);  %having half zeros
else
    %ST.surf0 = tangent_to_surf(qST.qsurf0,qST.qnormx0,qST.qnormy0,qST.in_px0,qST.in_py0);
     %Adding for testing
            first_ring1=qST.in_py0;%qST.surf0(1,:,:);
            first_ring=reshape(first_ring1,[size(ST.surf0,1),3]);
            center=mean(first_ring,1);
            bifurc=qST.b00_startP';
            trans_vec=bifurc-center;
            first_ring_trans=first_ring+trans_vec;
            inpy=first_ring_trans;
            inpx1=reshape(qST.in_px0,[size(ST.surf0,1),3]);
            inpx=inpx1+trans_vec;
           % for t=1:30
            ST.surf0=tangent_to_surf(qST.qsurf0,qST.qnormx0,qST.qnormy0,inpx,inpy);%(t,:,:) = reshape(qST.surf0(t,:,:),[30,3])+trans_vec;%
            %end
end
if l==3
    %ST.beta0
end

if isempty(ST.tk_sideLocs) == 0
    for surf=1:size(ST.surf0,1)
        ring=reshape(ST.surf0(surf,:,:),[size(ST.surf0,1),3]);
        cent=mean(ring,1);
        ST.beta0(:,surf)=cent';       
    end
        
    betak0 = interp1(ST.t_paras, ST.beta0', ST.tk_sideLocs)';

else
    betak0 = [];
end

ST.beta = cell(1,ST.K_sideNum);
ST.surf = cell(1,ST.K_sideNum);

for k=1:ST.K_sideNum
    isAllZeroq1 = all(qST.qsurf{k}(:) == 0);
    if isempty(qST.q{k})
        ST.beta{k} = [0, 0, 0]'+ repmat(betak0(:,k), 1, size(qST.q{k}, 2));
    else
        ST.beta{k} = q_to_curve(qST.q{k});   % --- now the starting point of ST.beta{k} is at the orgin.
        ST.beta{k} = ST.beta{k} + repmat(betak0(:,k), 1, size(qST.q{k}, 2));
       
        if isAllZeroq1
            ST.surf{k}=qST.qsurf{k}(:,:,1:3);
        else
            %ST.surf{k}=tangent_to_surf(qST.qsurf{k},qST.qnormx{k},qST.qnormy{k},qST.in_px{k},qST.in_py{k});
            %Adding for testing
            first_ring1=qST.in_py{k};
           
            first_ring=reshape(first_ring1,[size(qST.qsurf{k},1),3]);
         
            center=mean(first_ring,1);
            bifurc=betak0(:,k)';
            trans_vec=bifurc-center;
            first_ring_trans=first_ring+trans_vec;
            inpy=first_ring_trans;
            inpx1=reshape(qST.in_px{k},[size(qST.qsurf{k},1),3]);
            inpx=inpx1+trans_vec;
            %for t=1:30
            ST.surf{k}=tangent_to_surf(qST.qsurf{k},qST.qnormx{k},qST.qnormy{k},inpx,inpy);%(t,:,:) =reshape(qST.surf{k}(t,:,:),[30,3])+trans_vec;%
            %end
            end
    end

    


% ST = orderfields(ST, {'t','beta0','T0','K','beta','T','tk','d'});

end
end