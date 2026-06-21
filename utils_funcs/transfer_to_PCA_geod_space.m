function [Mu,eigenVector, EVals,tree_pca,used_qCompTrees_Ready,qX,lambda]=transfer_to_PCA_geod_space(aligned_q_tree_1,aligned_q_tree_2,num_within_seq1,num_within_seq2)
lam_m = 1; 
lam_s = 1;
lam_p = 1;

tNum=num_within_seq1+num_within_seq2;
used_qCompTrees=cell(1,tNum);

for i=1:num_within_seq1

  used_qCompTrees{i}=aligned_q_tree_1{i};
  
end

p=num_within_seq1+1; p_end=tNum;

for i=p:p_end

  used_qCompTrees{i}=aligned_q_tree_2{i-p+1};

end

[used_qCompTrees_Ready] = CompatMultiMax_rad_4layers(used_qCompTrees);

qX = [];

for i = 1:tNum
   qX(i, :) = flattenQCompTree_4layers_rad(used_qCompTrees_Ready{i}, lam_m, lam_s, lam_p);
   [transformed_data(i,:), lambda(i)]=yeoJohnson(qX(i,:));
end
qXT= transformed_data';
%qXT=qX';

[Mu,eigenVector, EVals] = performEigenAnalysis(qXT);


for i=1:tNum

    sample{i}=qXT(:,i)-Mu;

    tree_pca(i,:)=sample{i}'* eigenVector;

end
end
