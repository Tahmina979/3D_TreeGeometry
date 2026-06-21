function save_obj(CT1)
for geod=1:numel(CT1)
    CT=CT1{geod};
    M=CT.surf0;
    X = M(:,:,1);
    X(:,31,1)=M(:,1,1);
    Y = M(:,:,2);
    Y(:,31,1)=M(:,1,2);
    Z = M(:,:,3);
    Z(:,31,1)=M(:,1,3);
    [CT.beta0_face,CT.beta0_vertex] = surf2patch(X, Y, Z, 'triangles');
      
  for i=1: numel(CT.beta_children)

    clear X Y Z
    M=CT.beta_children{i}.surf0;
    X = M(:,:,1);
    X(:,31,1)=M(:,1,1);
    Y = M(:,:,2);
    Y(:,31,1)=M(:,1,2);
    Z = M(:,:,3);
    Z(:,31,1)=M(:,1,3);
    [CT.beta_children{i}.beta0_face,CT.beta_children{i}.beta0_vertex ] = surf2patch(X, Y, Z, 'triangles');
    
    for j=1: numel(CT.beta_children{i}.beta_children)
            M=CT.beta_children{i}.beta_children{j}.surf0;
            X = M(:,:,1);
            X(:,31,1)=M(:,1,1);
            Y = M(:,:,2);
            Y(:,31,1)=M(:,1,2);
            Z = M(:,:,3);
            Z(:,31,1)=M(:,1,3);
            [CT.beta_children{i}.beta_children{j}.beta0_face, CT.beta_children{i}.beta_children{j}.beta0_vertex] = surf2patch(X, Y, Z, 'triangles');   
                                                                    
            for k=1: numel(CT.beta_children{i}.beta_children{j}.beta)%_children)
                    M=CT.beta_children{i}.beta_children{j}.surf{k}; %or CT.beta_children{i}.beta_children{j}.beta_children{k}.surf0
                    X = M(:,:,1);
                    X(:,31,1)=M(:,1,1);
                    Y = M(:,:,2);
                    Y(:,31,1)=M(:,1,2);
                    Z = M(:,:,3);
                    Z(:,31,1)=M(:,1,3);
                    [CT.beta_children{i}.beta_children{j}.beta_face{k},CT.beta_children{i}.beta_children{j}.beta_vertex{k}] = ...
                                                                surf2patch(X, Y, Z, 'triangles');
               
            
            end
            
    end
  end

   


Face = [];
Vertex = [];

cur_idx = 0;
Vertex = [Vertex; CT.beta0_vertex];
Face = [Face; CT.beta0_face];
cur_idx = cur_idx + size(Vertex, 1);

% 2nd layer
for i=1: numel(CT.beta_children)
    
    Vertex = [Vertex; CT.beta_children{i}.beta0_vertex];
    new_face = CT.beta_children{i}.beta0_face + cur_idx;
    Face = [Face; new_face];
    cur_idx = cur_idx + size(CT.beta_children{i}.beta0_vertex, 1);
    
    if numel(find(isnan(Vertex))) >0
        %break;
    end
        
end

% 3rd layer
for i=1: numel(CT.beta_children)
    for j=1: numel(CT.beta_children{i}.beta_children)

        Vertex = [Vertex; CT.beta_children{i}.beta_children{j}.beta0_vertex];
        new_face = CT.beta_children{i}.beta_children{j}.beta0_face + cur_idx;
        Face = [Face; new_face];
        cur_idx = cur_idx + size(CT.beta_children{i}.beta_children{j}.beta0_vertex, 1);
    end
end

% 4th layer
for i=1: numel(CT.beta_children)
    for j=1: numel(CT.beta_children{i}.beta_children)
        for k= 1: numel(CT.beta_children{i}.beta_children{j}.beta)

            Vertex = [Vertex; CT.beta_children{i}.beta_children{j}.beta_vertex{k}];
            new_face = CT.beta_children{i}.beta_children{j}.beta_face{k} + cur_idx;
            Face = [Face; new_face];
            cur_idx = cur_idx + size(CT.beta_children{i}.beta_children{j}.beta_vertex{k}, 1);
        end
    end
end

filename = sprintf('%d.obj', geod);
%%
fp_a = fopen(filename, 'w');
fprintf(fp_a, ['# V ',num2str(size(Vertex, 1)), '\n']);
fprintf(fp_a, ['# F ',num2str(size(Face, 1)), '\n']);
for i=1: size(Vertex, 1)
    fprintf(fp_a, 'v ');
    fprintf(fp_a, '%f %f %f\n', Vertex(i, :) );%+ [move_x, move_y, move_z]);
end

for i=1: size(Face, 1)
    fprintf(fp_a, 'f ');
    fprintf(fp_a, '%d %d %d\n', Face(i, :));
end
end

end
