function [Mu,eigenVector, EVals,tree_pca,used_qCompTrees_Ready,qX]=transfer_to_PCA_space_resamp(aligned_q_tree_2,num_within_seq2)
lam_m = 1; 
lam_s = 1;
lam_p = 1;

tNum=num_within_seq2;
used_qCompTrees=cell(1,tNum);

for i=1:num_within_seq2

  used_qCompTrees{i}=aligned_q_tree_2{i};
end


[used_qCompTrees_Ready] = CompatMultiMax_rad_4layers(used_qCompTrees);

qX = [];

for i = 1:tNum
   qX(i, :) = flattenQCompTree_4layers_rad(used_qCompTrees_Ready{i}, lam_m, lam_s, lam_p);
end

qXT= qX';

[Mu,eigenVector, EVals] = performEigenAnalysis(qXT);


for i=1:tNum

    sample{i}=qXT(:,i)-Mu;

    tree_pca(i,:)=sample{i}'* eigenVector;

end
end