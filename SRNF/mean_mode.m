alpha_1 = sqrt(EVals_s(1));
alpha_2 = sqrt(EVals_s(2));
alpha_3 = sqrt(EVals_s(3));
 

Digit1=(rand(1, 20)-0.5)*5;
Digit2=(rand(1, 20)-0.5)*5;
Digit3=(rand(1, 20)-0.5)*5;
rand_num = size(Digit1, 2);

rand_sampleX = cell(1, rand_num);
rand_sampleQ = cell(1, rand_num);
rand_sample = cell(1, rand_num);

for i=1:rand_num
    
    rand_sampleX{i} = Digit1(i)*alpha_1 * eigenVectors_s(:,1) + Digit2(i)*alpha_2 * eigenVectors_s(:,2) + Digit3(i)*alpha_3 * eigenVectors_s(:,3) + Mu_s;
    rand_sampleQ{i} = unflattenCompTree_4layers_rad(rand_sampleX{i}, lam_m, lam_s, lam_p, setq_Align_Ready{1});

    rand_sample{i} = qCompTree_to_CompTree_rad_4layers(rand_sampleQ{i});
end


%modes

Range=1.5; Step=0.03797;%0.5;

%std=[-1.5,-1.0,-0.5,0,0.5,1.0,1.5];
std = linspace(-1.5, 1.5, 80);
alpha_1_vec = -Range*alpha_1: (Step*alpha_1): Range*alpha_1; %Take alpha_2 to see the variations in the second princiapal direction and so on.

mode_length= numel(alpha_1_vec);

tic
for i=1:mode_length
    qX_PC1{i} = alpha_1_vec(i)*eigenVectors_s(:,1) + Mu_s;
    q_PC1{i} = unflattenCompTree_4layers_rad(qX_PC1{i}, lam_m, lam_s, lam_p, setq_Align_Ready{1});
    A{i}=qCompTree_to_CompTree_rad_4layers(q_PC1{i});
end
