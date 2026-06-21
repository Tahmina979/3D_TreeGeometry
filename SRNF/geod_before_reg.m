clc
clear
addpath('utils_data','SRNF','utils_draw','utils_funcs',"utils_statModels","OpenCurvesRn");

lam_m = 1; 
lam_s = 1;
lam_p = 1;
setq= cell(1, 2);

data_path5= 'NeuroData/Sample3_2/'; %Can change the sample
[all_qCompTrees1, all_compTrees1] = load_botanTrees_rad(data_path5);
save_obj(all_compTrees1);
fd
%a{1}=alfl_compTrees5{1};
setq{1}=all_qCompTrees1{1};
data_path5= 'NeuroData/BS07a_new_8_max_max/'; %Can change the sample
[all_qCompTrees2, all_compTrees5] = load_botanTrees_rad(data_path5);
setq{2}=all_qCompTrees2{1};

Q = CompatMultiMax_rad_4layers(setq);

Q1p=Q{1};
Q2p=Q{2};

stp=9
[A10, qA10,time_for_tangent] = GeodComplexTreesPrespace_rad_4layers(Q1p,Q2p,stp);
%save_obj(A10);