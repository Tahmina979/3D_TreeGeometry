function [M]=stack_branch(CT)
    
    M=CT.srnf0;
        
  for i=1: numel(CT.q_children)

   
    M1=CT.q_children{i}.srnf0;

    M=cat(1,M,M1);
   
    for j=1: numel(CT.q_children{i}.q_children)
            M2=CT.q_children{i}.q_children{j}.srnf0;
            M=cat(1,M,M2);

            for k=1: numel(CT.q_children{i}.q_children{j}.q)
                    M3=CT.q_children{i}.q_children{j}.srnf{k}; 
                                                               
                    M=cat(1,M,M3);
            
            end
            
    end
  end
