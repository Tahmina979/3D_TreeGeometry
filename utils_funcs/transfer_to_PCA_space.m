function [Mu,eigenVector, EVals,tree_pca,used_qCompTrees_Ready,qX,lambda]=transfer_to_PCA_space(ctree_1,ctree_2,ctree_5,ctree_6,ctree_7,ctree_10,num_within_seq1,num_within_seq2,num_within_seq5,num_within_seq6,num_within_seq7,num_within_seq10)
lam_m = 1; 
lam_s = 1;
lam_p = 1;

tNum=num_within_seq1+num_within_seq2+ num_within_seq5+num_within_seq6+num_within_seq7+ num_within_seq10;
used_qCompTrees=cell(1,tNum);

for i=1:num_within_seq1

  used_qCompTrees{i}=ctree_1{1,i};
end

p=num_within_seq1+1; p_end=num_within_seq1+num_within_seq2;

for i=p:p_end

  used_qCompTrees{i}=ctree_2{1,i-p+1};

end
p=p_end+1; p_end=p_end+num_within_seq5;
for i=p:p_end

    used_qCompTrees{i}=ctree_5{i-p+1};
end

p=p_end+1; p_end=p_end+num_within_seq6;
for i=p:p_end
  used_qCompTrees{i}=ctree_6{i-p+1};
end

p=p_end+1; p_end=p_end+num_within_seq7;
for i=p:p_end
  used_qCompTrees{i}=ctree_7{i-p+1};
end

p=p_end+1; p_end=p_end+num_within_seq10;
for i=p:p_end
  used_qCompTrees{i}=ctree_10{i-p+1};
end

[used_qCompTrees_Ready] = CompatMultiMax_rad_4layers(used_qCompTrees);


 
for i=1:tNum
   used_CompTrees_Ready{i}= qCompTree_to_CompTree_rad_4layers(used_qCompTrees_Ready{i});
end


qX = [];

for i = 1:tNum
 
   qX(i, :) = flattenQCompTree_4layers_rad(used_qCompTrees_Ready{i}, lam_m, lam_s, lam_p);
   [transformed_data(i,:), lambda(i)]=yeoJohnson(qX(i,:));
end
qXT= transformed_data';

%qXT= qX';

[Mu,eigenVector, EVals] = performEigenAnalysis(qXT);

for i=1:tNum

sample{i}=qXT(:,i)-Mu;

tree_pca(i,:)=sample{i}'* eigenVector;

end

end