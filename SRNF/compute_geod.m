clc;
clear;
%close all;

lam_m = 1; 
lam_s = 1;
lam_p = 1;
addpath('utils_data','SRNF','utils_draw',"OpenCurvesRn",'utils_funcs',"utils_statModels");

stp1 = 7;
%{
Q1_reg=load('S4_1to_T1_5L4.mat');
Q2_reg=load('S4_1to_T1_5L4T.mat');

Q1p=Q1_reg.Q1p;
Q2p=Q2_reg.Q2p;
%}
data_path5= 'NeuroData/BS07a_new_1_max_max/'; %Can change the sample
[all_qCompTrees5, all_compTrees5] = load_botanTrees_rad(data_path5);



[q1]=stack_branch(all_qCompTrees5{1});
Q1=all_qCompTrees5{1};

data_path5= 'NeuroData/BS07a_new_8_max_max/';%Can change the sample
[all_qCompTrees5, all_compTrees5] = load_botanTrees_rad(data_path5);

[q2]=stack_branch(all_qCompTrees5{1});
Q2=all_qCompTrees5{1};
%{
[q1_new,q2_new]=equalizesize(q1,q2);

[Q2,Q1]=ProcrustesAlign(q2_new,q1_new,Q2,Q1);
%}
tic
[G,Q1p, Q2p] = ReparamPerm_qCompTrees_rad_4layers_v2(Q1, Q2, lam_m, lam_s, lam_p);
toc

t1=tic
[A10, qA10,time_for_tangent] = GeodComplexTreesPrespace_rad_4layers(Q1p,Q2p,stp1);

elaspes_time=toc(t1)-time_for_tangent

%save_obj(A10)