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


alpha_1 = sqrt(EVals_s(1));
alpha_2 = sqrt(EVals_s(2));
alpha_3 = sqrt(EVals_s(3));
 
%randomization, change the range in rand to get different number of samples
Digit1=(rand(1, 5)-0.5)*5;
Digit2=(rand(1, 5)-0.5)*5;
Digit3=(rand(1, 5)-0.5)*5;
rand_num = size(Digit1, 2);

rand_sampleX = cell(1, rand_num);
rand_sampleQ = cell(1, rand_num);
rand_sample = cell(1, rand_num);

for i=1:rand_num
    
    rand_sampleX{i} = Digit1(i)*alpha_1 * eigenVectors_s(:,1) + Digit2(i)*alpha_2 * eigenVectors_s(:,2) + Digit3(i)*alpha_3 * eigenVectors_s(:,3) + Mu_s;
    rand_sampleQ{i} = unflattenCompTree_4layers_rad(rand_sampleX{i}, lam_m, lam_s, lam_p, setq_Align_Ready{1});

    rand_sample{i} = qCompTree_to_CompTree_rad_4layers(rand_sampleQ{i});
end
save_obj(rand_sample);

render(rand_sample); %plotting modes