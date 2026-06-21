function [Q1,Q2n] = ProcrustesAlign(q1,q2,Q1,Q2)

Ot = optimal_rot_surf1(q1,q2);

Q2.surf0=rotate3D(Q2.surf0,Ot);
Q2.q0=rotate3Dq(Q2.q0,Ot);
        
  for i=1: numel(Q2.q_children)

   
    Q2.q_children{i}.surf0=rotate3D(Q2.q_children{i}.surf0,Ot);
    Q2.q_children{i}.q0=rotate3Dq(Q2.q_children{i}.q0,Ot);

    
   
    for j=1: numel(Q2.q_children{i}.q_children)
            Q2.q_children{i}.q_children{j}.surf0=rotate3D(Q2.q_children{i}.q_children{j}.surf0,Ot);
            Q2.q_children{i}.q_children{j}.q0=rotate3Dq(Q2.q_children{i}.q_children{j}.q0,Ot); 
            

            for k=1: numel(Q2.q_children{i}.q_children{j}.q)
                   Q2.q_children{i}.q_children{j}.surf{k}=rotate3D(Q2.q_children{i}.q_children{j}.surf{k},Ot); 
                    Q2.q_children{i}.q_children{j}.q{k}=rotate3Dq(Q2.q_children{i}.q_children{j}.q{k},Ot); 
            end
            
    end
  end

Q2n=Q2;
end
    