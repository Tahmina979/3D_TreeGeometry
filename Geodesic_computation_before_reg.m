clc
clear

lam_m = 1; 
lam_s = 1;
lam_p = 1;

addpath('utils_data','SRNF','utils_draw','utils_funcs',"utils_statModels","OpenCurvesRn","RenderOBJ/func_render/","RenderOBJ/func_other/","RenderOBJ/");

setq= cell(1, 2);

data_path1= 'NeuroData/Free_3D_tree1/'; %Can change the sample
[all_qCompTrees1, all_compTrees1] = load_botanTrees_rad(data_path1);
setq{1}=all_qCompTrees1{1};

data_path2= 'NeuroData/Free_3D_tree4/'; %Can change the sample
[all_qCompTrees2, all_compTrees2] = load_botanTrees_rad(data_path2);
setq{2}=all_qCompTrees2{1};

Q = CompatMultiMax_rad_4layers(setq);



Q1p=Q{1};
Q2p=Q{2};

stp=9
[A10, qA10,time_for_tangent] = GeodComplexTreesPrespace_rad_4layers(Q1p,Q2p,stp);
save_obj(A10);

t{1}=A10{1}; % source
t{2}=A10{9}; %target

ball_correspondence(t); %visualize pointiwse correspondence before registration

render_geod(A10); %plot geodesics