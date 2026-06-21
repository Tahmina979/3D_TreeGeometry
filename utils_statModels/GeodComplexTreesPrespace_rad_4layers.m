function [A, qA,time_s] = GeodComplexTreesPrespace_rad_4layers(Q1, Q2, geo_param)

time_s=0.0;
[~,qA,time_s] = GeodSimpleTreesPrespace_rad(Q1, Q2, geo_param,time_s);
for i=1: numel(qA)
    qA{i}.q_children = cell(1, numel(Q1.q_children));
end


for i=1: numel(Q1.q_children)
    [~,qA_children,time_s] = GeodComplexTreesPrespace_rad_3layers(Q1.q_children{i}, Q2.q_children{i}, geo_param,time_s);
    for j = 1: numel(qA_children)
        qA{j}.q_children{i} = qA_children{j};
    end
end



% convert to AC-space (original trees)
A = cell(1, numel(qA));
stp = geo_param;
for i=1:numel(qA)
    A{i} = qCompTree_to_CompTree_rad_4layers(qA{i});
    
end
