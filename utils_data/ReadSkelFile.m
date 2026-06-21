function [branch, branch_num] = ReadSkelFile( skelFile, surf_file)

par=load(surf_file);
M=zeros(30,30,3);

fp1 = fopen(skelFile, 'r');
total_levelNum = fscanf(fp1, '%d', [1,1]);

for i = 1:total_levelNum
    
    if i == 1
        M(:,:,:)=par.surf.layer1(1,:,:,:);
        layer_string = fscanf(fp1, '%s', [1,1]);
        layer_id = fscanf(fp1, '%d', [1,1]);                        %layer_id��ָ�ĵڼ���layer.
        branch_num(i) = fscanf(fp1, '%d', [1,1]);
       
        fatherBranch_id = fscanf(fp1, '%d', [1,1]);                       %��������һ���id
        fatherBranch_point_id = fscanf(fp1, '%d', [1,1]);                     %����֦���о���Ľڵ�
        branch_point_num = fscanf(fp1, '%d', [1,1]);                %��¼ÿ�����ӵĵ�ĸ���
        
        branch(i,1).father_branch_id = fatherBranch_id;
        branch(i,1).father_point_id = fatherBranch_point_id;
        
            
            for j = 1 : branch_point_num                     %����ÿ������branch��skeleton������ֵ�Ͷ�Ӧ�İ뾶
                if j==1
                    first_ptx=fscanf(fp1, '%f', [1,1]);
                    first_pty=fscanf(fp1, '%f', [1,1]);
                    first_ptz=fscanf(fp1, '%f', [1,1]);
                    branch(i,1).point(j).x = 0.0,
                    branch(i,1).point(j).y = 0.0;
                    branch(i,1).point(j).z = 0.0;
                    branch(i,1).point(j).r = fscanf(fp1, '%f', [1,1]);
                    continue;
                end
                branch(i,1).point(j).x = (fscanf(fp1, '%f', [1,1])-first_ptx);
                branch(i,1).point(j).y = (fscanf(fp1, '%f', [1,1])-first_pty);
                branch(i,1).point(j).z = (fscanf(fp1, '%f', [1,1])-first_ptz);
                branch(i,1).point(j).r = fscanf(fp1, '%f', [1,1]);
            end
        p = cat(3,first_ptx, first_pty, first_ptz);
        branch(i,1).surf=(M-p);
    end
  
    if i~=1        
        layer_string = fscanf(fp1, '%s', [1,1]);
        layer_id = fscanf(fp1, '%d', [1,1]);                                    %layer_id��ָ�ĵڼ���layer.
        branch_num(i) = fscanf(fp1, '%d', [1,1]);
        
        for k = 1:branch_num(i)
            M=zeros(30,30,3);
            if i==2
                M(:,:,:)=par.surf.layer2(k,:,:,:);
            end
            if i==3
                M(:,:,:)=par.surf.layer3(k,:,:,:);
            end
            if i==4
                M(:,:,:)=par.surf.layer4(k,:,:,:);
            end
            fatherBranch_id = fscanf(fp1, '%d', [1,1]);                              %��������һ���id
            fatherBranch_point_id = fscanf(fp1, '%d', [1,1]);                              %���branch����Ӧ�ĺ�����
            branch_point_num = fscanf(fp1,'%d',[1,1]);                        %��¼ÿ�����ӵĵ�ĸ���
            
            branch(i,k).father_branch_id = fatherBranch_id;
            branch(i,k).father_point_id = fatherBranch_point_id;
            branch(i,k).surf=(M-p);
            for j = 1:branch_point_num                                       %����ÿ������branch��skeleton������ֵ�Ͷ�Ӧ�İ뾶
                branch(i,k).point(j).x = (fscanf(fp1,'%f',[1,1])- first_ptx);
                branch(i,k).point(j).y = (fscanf(fp1,'%f',[1,1])-first_pty);
                branch(i,k).point(j).z = (fscanf(fp1,'%f',[1,1])-first_ptz);
                branch(i,k).point(j).r = (fscanf(fp1,'%f',[1,1]));
            end
        end      
    end
end

% ��branch_numת����������
branch_num = branch_num';
fclose(fp1);
    

end

