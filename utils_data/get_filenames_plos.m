function fnames = get_filenames_plos(fpath)

% fnames = ls(fpath);
files_structs = dir([fpath, '*.txt']);

fnames = cell(numel(files_structs), 1);
for i=1: numel(files_structs)
    fnames{i} = files_structs(i).name;
end

fnames = sort(fnames);