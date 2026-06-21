function[new_surf]=global_reparm(surf1,surf2,q1,q2)
    isAllZero1 = all(surf1(:) == 0);
    isAllZero2 = all(surf2(:) == 0);
    if isAllZero1 || isAllZero2
        new_surf=surf1;
        return;
    end
    n = size(surf1, 2); % Get the size of the second dimension
    
    fp2=reshape(surf2(1,1,:),1,3);
    fp1=reshape(surf1(1,:,:),30,3);

    for i=1:size(surf1,2)
        dist(i)= sqrt(sum((fp1(i,:) - fp2).^2));
    end
    [~,index]=min(dist);
    
    if index~=1

        new_surf=surf1(:, [index:30,1:index-1], :);
        surf1=new_surf;
    end

    dist1=Calculate_Distance(surf1,surf2);

    reversed_surf1=surf1(:, end:-1:1, :);
    dist2=Calculate_Distance(reversed_surf1,surf2);
    
    
   if dist2<dist1
        surf1=reversed_surf1;
        %r_surf1=q1(:, end:-1:1, :);
        %q1=r_surf1;   
    end
    new_surf=surf1;
    
    %{
    dist(1)=Calculate_Distance(surf1,surf2);
    shifted_surf = surf1;
    for i=2:size(surf1,1)
        shifted_surf1 = shifted_surf(:, [end, 1:end-1], :);
        shifted_surf=shifted_surf1;
        %[Anew,normal_new,multfactnew,sqrtmultfactnew] = area_surf(shifted_surf);
        %q1 = surface_to_q(normal_new,sqrtmultfactnew);
        dist(i)=Calculate_Distance(shifted_surf,surf2);
    end
    [~,index]=min(dist);
    
   
    %rotate cylinder
    n = size(surf1, 2); % Get the size of the second dimension
    
    % Use modulo to handle shifts larger than the array size
    i = mod(index, n);
    
    % Create an index vector to shift the array
    index_vector = [n-i+1:n, 1:n-i];
    new_surf=surf1(:, index_vector, :);
    
    %}
end