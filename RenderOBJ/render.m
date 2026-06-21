function render(A)

    N =numel(A);
    
    figure('Color','w');
    hold on;
    
    % Load the first mesh to determine a reference size
    m1 = MESH_IO.read_shape(['./1.obj']);
    V = m1.surface.VERT;
    F1 = m1.surface.TRIV;
    
    % Calculate the bounding box of the reference mesh
    bb_ref = [min(V); max(V)];
    widthX_ref = bb_ref(2,1) - bb_ref(1,1);
    widthY_ref = bb_ref(2,2) - bb_ref(1,2); % Add Y dimension
    widthZ_ref = bb_ref(2,3) - bb_ref(1,3); % Add Z dimension
    
    % Determine the maximum dimension of the reference mesh
    max_dim_ref = max([widthX_ref, widthY_ref, widthZ_ref]);
    
    for i = 1:N
        m1 = MESH_IO.read_shape(['./',num2str(i),'.obj']);
        %m1 = MESH_IO.read_shape(['mean.obj']);
        V1 = m1.surface.VERT;
        F1 = m1.surface.TRIV;
    
        % Calculate the bounding box of the current mesh
        bb = [min(V1); max(V1)];
        widthX = bb(2,1) - bb(1,1);
        widthY = bb(2,2) - bb(1,2); % Add Y dimension
        widthZ = bb(2,3) - bb(1,3); % Add Z dimension
    
        % Determine the maximum dimension of the current mesh
        max_dim = max([widthX, widthY, widthZ]);
    
        % Calculate the scaling factor
        scale_factor = max_dim_ref / max_dim;
    
        % Apply the scaling to the vertices
        V1_scaled = V1 * scale_factor;
    
        % Shift the mesh
        if i == 1
            shiftX = 0;
        end
        V1_shift = V1_scaled;
        V1_shift(:,1) = V1_shift(:,1) + shiftX;
    
        % Place meshes side-by-side
        margin = 0.05 * widthX_ref;  % Use widthX_ref
        shiftX = i*0.5*widthX_ref;% + i * margin; % Use widthX_ref, adjust as you need
        
        V1_shift(:,1) = V1_shift(:,1) + i * widthX_ref + i * margin;
    
        c = [0.2 0.2 0.2];
        p2 = patch('Faces',F1,'Vertices',V1_shift,'FaceColor',c,'EdgeColor','none');
    
        axis equal off
    
    end
    
    light('Position',[0 0 1], 'Style','infinite');
    lighting phong;
    view(2);
end