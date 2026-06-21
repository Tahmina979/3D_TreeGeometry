function [all_source_tree,all_target_tree] = load_plosTrees_geod_dis(data_path)

source_path=strcat( data_path,'source/');
target_path=strcat( data_path,'target/');

txt_files_source = get_filenames_plos(source_path)
txt_files_target = get_filenames_plos(target_path)
tree_num = numel(txt_files_source);

all_source_tree=zeros(1,91797); % define with static value
all_target_tree=zeros(1,91797);
%read the registered source
for i=1:tree_num
    
    data = zeros(0,3);
    file = fopen(strcat(source_path, txt_files_source{i}));

while(~feof(file))
    fline = fgetl(file);
  
    %if fline(1) == '#'
        %continue;
    %end    
    A = sscanf(fline, '%f %f %f');
    data = [data, A'];
end

fclose(file);

all_source_tree(i,1:size(data,2))=data;
end
%read the registered target 
tree_num = numel(txt_files_target);
for i=1:tree_num
    
    data = zeros(0,3);
    file = fopen(strcat(target_path, txt_files_target{i}));

while(~feof(file))
    fline = fgetl(file);
  
    %if fline(1) == '#'
        %continue;
    %end    
    A = sscanf(fline, '%f %f %f');
    data = [data, A'];
end

fclose(file);

all_target_tree(i,1:size(data,2))=data;
end
end