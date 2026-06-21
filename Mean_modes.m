clc
clear
close all;

lam_m = 1; 
lam_s = 1;
lam_p = 1;

addpath('utils_data','SRNF','utils_draw','utils_funcs',"utils_statModels","OpenCurvesRn","RenderOBJ/func_render/","RenderOBJ/func_other/","RenderOBJ");

ctree=load('Set4/Set4_registered.mat'); % pre-registered trees, you can get your set from registration.m

setq_Align_Ready=ctree.setq_Align_Ready;

% Flatten
qX = [];
sX = [];
qsX = [];
for i = 1: numel(setq_Align_Ready)
    [qX(i, :),sX(i,:),qsX(i,:)] = flattenQCompTree_4layers_rad(setq_Align_Ready{i}, lam_m, lam_s, lam_p);
end

[Mu_s, eigenVectors_s, EVals_s] = performEigenAnalysis(qsX(1:end,:)');

q_PC1{1} = unflattenCompTree_4layers_rad(Mu_s, lam_m, lam_s, lam_p, setq_Align_Ready{1});
A{1}=qCompTree_to_CompTree_rad_4layers(q_PC1{1});


save_obj(A);

render(A); %plotting mean

alpha_1 = sqrt(EVals_s(1));
alpha_2 = sqrt(EVals_s(2));
alpha_3 = sqrt(EVals_s(3));
 
%modes

Range=1.5; Step=0.5;

std=[-1.5,-1.0,-0.5,0,0.5,1.0,1.5];

alpha_1_vec = -Range*alpha_1: (Step*alpha_1): Range*alpha_1; %Take alpha_2 to see the variations in the second princiapal direction and so on.

mode_length= numel(alpha_1_vec);

tic
for i=1:mode_length
    qX_PC1{i} = alpha_1_vec(i)*eigenVectors_s(:,1) + Mu_s; %eigenVectors_s(:,2) to see the variations in the second princiapal direction and so on.
    q_PC1{i} = unflattenCompTree_4layers_rad(qX_PC1{i}, lam_m, lam_s, lam_p, setq_Align_Ready{1});
    A{i}=qCompTree_to_CompTree_rad_4layers(q_PC1{i});
end

save_obj(A);

render(A); %plotting modes in first principal direction