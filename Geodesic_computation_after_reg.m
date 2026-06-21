clc;
clear;
%close all;

lam_m = 1; 
lam_s = 1;
lam_p = 1;
addpath('utils_data','SRNF','utils_draw','utils_funcs',"utils_statModels","OpenCurvesRn","RenderOBJ/func_render/","RenderOBJ/func_other/","RenderOBJ/");

stp1 = 9;
data_path1= 'NeuroData/Free_3D_tree1/'; %Can change the sample
[all_qCompTrees1, all_compTrees1] = load_botanTrees_rad(data_path1);
[q1]=stack_branch(all_qCompTrees1{1});
Q1=all_qCompTrees1{1};


data_path2= 'NeuroData/Free_3D_tree4/'; %Can change the sample
[all_qCompTrees2, all_compTrees2] = load_botanTrees_rad(data_path2);
setq{2}=all_qCompTrees2{1};
[q2]=stack_branch(all_qCompTrees2{1});
Q2=all_qCompTrees2{1};


[q1_new,q2_new]=equalizesize(q1,q2);
%[Q2,Q1]=ProcrustesAlign(q2_new,q1_new,Q2,Q1);

tic
[G,Q1p, Q2p] = ReparamPerm_qCompTrees_rad_4layers_v2(Q1, Q2, lam_m, lam_s, lam_p);
toc

t1=tic
[A10, qA10,time_for_tangent] = GeodComplexTreesPrespace_rad_4layers(Q1p,Q2p,stp1);


save_obj(A10);

t{1}=A10{1}; % source
t{2}=A10{9}; %target

ball_correspondence(t); %visualize pointiwse correspondence before registration

render_geod(A10); %plot geodesics