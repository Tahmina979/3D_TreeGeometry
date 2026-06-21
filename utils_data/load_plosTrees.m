function [data] = load_plosTrees(data_path) % done for cycle consistacny %[all_tree] = load_plosTrees(data_path)

% --- get the swc files in the data_path ---
% data_path = 'NeuroData/chen/CNG version/';
%cd utils_data/
txt_files = get_filenames_plos(data_path);
tree_num = numel(txt_files);
%all_tree=zeros(9,1000); % define with static value
prev=1;
data = zeros(0,3); % keep here for cycle consistancy
for i=1:tree_num
    
    %data = zeros(0,3);
    file = fopen(strcat( data_path, txt_files{i}));

while(~feof(file))
    fline = fgetl(file);
  
    %if fline(1) == '#'
        %continue;
    %end    
    A = sscanf(fline, '%f %f %f');
    data = [data, A'];
end

fclose(file);

%all_tree(i,1:size(data,2))=data;  % need to comment out if not working
%with cycle consistancy
%all_tree(i,prev:prev+size(data,2)-1)=data;

%prev=prev+size(data,2)+1;

end
end