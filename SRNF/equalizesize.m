function [array1_padded,array2_padded]=equalizesize(array1,array2)

max_dim=max(size(array1,1),size(array2,1));

desired_rows = max_dim;  

if size(array1,1)<max_dim
    current_rows = size(array1, 1); 
    rows_to_add = desired_rows - current_rows; 
    zero_rows = zeros(rows_to_add, size(array1, 2), size(array1, 3)); 
    array1_padded = cat(1, array1, zero_rows);
    array2_padded=array2;

elseif size(array2,1)<max_dim
    current_rows = size(array2, 1); 
    rows_to_add = desired_rows - current_rows; 
    zero_rows = zeros(rows_to_add, size(array2, 2), size(array2, 3)); 
    array2_padded = cat(1, array2, zero_rows);
    array1_padded=array1;
else
    array1_padded=array1;
    array2_padded=array2;
end
end