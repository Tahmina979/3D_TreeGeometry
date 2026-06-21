clc
clear
close all

addpath('utils_data','SRNF','utils_draw','utils_funcs',"utils_statModels","OpenCurvesRn");

lam_m = 1; 
lam_s = 1;
lam_p = 1;
rootDir = 'Set4/';

d = dir(rootDir);
isSub = [d.isdir] & ~ismember({d.name}, {'.','..'});

subfolders = d(isSub);

for k = 1:numel(subfolders)
    
    folderPath = fullfile(rootDir, subfolders(k).name,'/');
    disp(folderPath)
    [all_qCompTrees, all_compTrees] = load_botanTrees_rad(folderPath);
    all_t{k}=all_compTrees{1};
    Q1=all_qCompTrees{1};
    setq{k}=Q1;
    
end
%save_obj(all_t);



mean{1}=setq{1};
setq_Align = cell(1, numel(setq));
setq_Align{1} = setq{1};
k=2;
tic;
for i = 2: numel(setq)
    
    Q11 = setq{i};
    Q22 = mean{1};
    
    [q1]=stack_branch(setq{i});
    [q2]=stack_branch(mean{1});

    [q1_new,q2_new]=equalizesize(q1,q2);
    [Q22,Q11]=ProcrustesAlign(q2_new,q1_new,Q22,Q11);
    % Q2 to Q1
    [G,Q11p, Q22p] = ReparamPerm_qCompTrees_rad_4layers_v2(Q11, Q22, lam_m, lam_s, lam_p);
    
    stp1 = 3;
    [A10, qA10] = GeodComplexTreesPrespace_rad_4layers(Q11p, Q22p, stp1);
    mean{1} = qA10{2};
    mid{i-1}=A10{2};
 
    setq_Align{k}=mean{1};
    k=k+1;
    setq_Align{k} = Q11p;
    k=k+1;
    %T2 = toc(tm2); fprintf('Loop %d: Geodesic computation - done, timecost:%.4f secs\n',(i-1), T2);

end
save_obj(mid);

save('mid.mat','mid');
toc

setq_Align_Ready = CompatMultiMax_rad_4layers(setq_Align);
save('Set4_registered.mat','setq_Align_Ready');
% Flatten
qX = [];
sX = [];
qsX = [];
for i = 1: numel(setq_Align_Ready)
    [qX(i, :),sX(i,:),qsX(i,:)] = flattenQCompTree_4layers_rad(setq_Align_Ready{i}, lam_m, lam_s, lam_p);
end

[Mu_s, eigenVectors_s, EVals_s] = performEigenAnalysis(qsX(1:end,:)');