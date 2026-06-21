function ball_correspondence(CT1)
 %% Plot meshes
    figure('Color','w'); hold on; axis equal;
    CT=CT1{1};
    M=CT.surf0;
    X = M(:,:,1);
    X(:,31,1)=M(:,1,1);
    Y = M(:,:,2);
    Y(:,31,1)=M(:,1,2);
    Z = M(:,:,3);
    Z(:,31,1)=M(:,1,3);
    [F1,V1] = surf2patch(X, Y, Z, 'triangles');
    CT2=CT1{2};
    M=CT2.surf0;
    X = M(:,:,1);
    X(:,31,1)=M(:,1,1);
    Y = M(:,:,2);
    Y(:,31,1)=M(:,1,2);
    Z = M(:,:,3);
    Z(:,31,1)=M(:,1,3);
    [F2,V2] = surf2patch(X, Y, Z, 'triangles');
    
   bb1 = [min(V1); max(V1)];
    widthX = bb1(2,1) - bb1(1,1);
    margin =  7* widthX;
    shiftX = widthX + margin;
        
    V2_shift = V2; 
    V2_shift(:,1) = V2_shift(:,1) + shiftX;
    % Example correspondences (1-to-1)
    size(V1,1)
    corr_idx = [randi([150 250], 1, 10) randi([650 750], 1, 10) randi([300 400], 1, 5) randi([500 600], 1, 5)];     % first 20 vertices correspond
    assignin('base', 'corr_idx', corr_idx);

    % Colors for spheres
    colors = jet(length(corr_idx));
    
   
    
    p1 = trisurf(F1, V1(:,1), V1(:,2), V1(:,3), ...
        'FaceColor',[0.6 0.6 0.6],'EdgeColor','none','FaceAlpha',0.9);
    
    p2 = trisurf(F2, V2_shift(:,1), V2_shift(:,2), V2_shift(:,3), ...
        'FaceColor',[0.6 0.6 0.6],'EdgeColor','none','FaceAlpha',0.9);
    
   
    
    %% Plot spheres at corresponding vertices
    [sx, sy, sz] = sphere(20);   % sphere resolution
    radius = 0.015;;
    
    for i = 1:length(corr_idx)
        idx = corr_idx(i);
    
        % Sphere on mesh 1
        surf( radius*sx + V1(idx,1), ...
              radius*sy + V1(idx,2), ...
              radius*sz + V1(idx,3), ...
              'FaceColor', colors(i,:), 'EdgeColor','none' );
    
        % Sphere on mesh 2
        surf( radius*sx + V2_shift(idx,1), ...
              radius*sy + V2_shift(idx,2), ...
              radius*sz + V2_shift(idx,3), ...
              'FaceColor', colors(i,:), 'EdgeColor','none' );
    end
    
    %% Draw correspondence lines
    for i = 1:length(corr_idx)
        idx = corr_idx(i);
    
        plot3( [V1(idx,1), V2_shift(idx,1)], ...
               [V1(idx,2), V2_shift(idx,2)], ...
               [V1(idx,3), V2_shift(idx,3)], ...
               'Color', colors(i,:), 'LineWidth', 2 );
    end


  
    for i_c=1: numel(CT.beta_children)

    clear X Y Z
    M=CT.beta_children{i_c}.surf0;
    isAllZero1 = all(M(:) == 0);
    

    
    X = M(:,:,1);
    X(:,31,1)=M(:,1,1);
    Y = M(:,:,2);
    Y(:,31,1)=M(:,1,2);
    Z = M(:,:,3);
    Z(:,31,1)=M(:,1,3);
    [F1,V1 ] = surf2patch(X, Y, Z, 'triangles');
    
    clear X Y Z
    M=CT2.beta_children{i_c}.surf0;
    isAllZero2 = all(M(:) == 0);

    
    X = M(:,:,1);
    X(:,31,1)=M(:,1,1);
    Y = M(:,:,2);
    Y(:,31,1)=M(:,1,2);
    Z = M(:,:,3);
    Z(:,31,1)=M(:,1,3);
    [F2,V2 ] = surf2patch(X, Y, Z, 'triangles');
    
   
        
    V2_shift = V2; 
    V2_shift(:,1) = V2_shift(:,1) + shiftX;
    % Example correspondences (1-to-1)
    size(V1,1)
    corr_idx1 =  randi([1 size(V1,1)], 1, 5);      % first 20 vertices correspond
    assignin('base', 'corr_idx1', corr_idx1);

    % Colors for spheres
    colors = jet(length(corr_idx1));
   
    
    p1 = trisurf(F1, V1(:,1), V1(:,2), V1(:,3), ...
        'FaceColor',[0.6 0.6 0.6],'EdgeColor','none','FaceAlpha',0.9);
    
    p2 = trisurf(F2, V2_shift(:,1), V2_shift(:,2), V2_shift(:,3), ...
        'FaceColor',[0.6 0.6 0.6],'EdgeColor','none','FaceAlpha',0.9);
    
    if isAllZero1 || isAllZero2
        print('enter')
        continue;
    end
    
    %% Plot spheres at corresponding vertices
    [sx, sy, sz] = sphere(20);   % sphere resolution
    radius = 0.015;;
    
    for i = 1:length(corr_idx1)
        idx = corr_idx1(i);
    
        % Sphere on mesh 1
        surf( radius*sx + V1(idx,1), ...
              radius*sy + V1(idx,2), ...
              radius*sz + V1(idx,3), ...
              'FaceColor', colors(i,:), 'EdgeColor','none' );
    
        % Sphere on mesh 2
        surf( radius*sx + V2_shift(idx,1), ...
              radius*sy + V2_shift(idx,2), ...
              radius*sz + V2_shift(idx,3), ...
              'FaceColor', colors(i,:), 'EdgeColor','none' );
    end
    
    %% Draw correspondence lines
    for i = 1:length(corr_idx1)
        idx = corr_idx1(i);
    
        plot3( [V1(idx,1), V2_shift(idx,1)], ...
               [V1(idx,2), V2_shift(idx,2)], ...
               [V1(idx,3), V2_shift(idx,3)], ...
               'Color', colors(i,:), 'LineWidth', 2 );
    end
   
    for j=1:numel(CT.beta_children{i_c}.beta_children)
            M=CT.beta_children{i_c}.beta_children{j}.surf0;
            X = M(:,:,1);
            X(:,31,1)=M(:,1,1);
            Y = M(:,:,2);
            Y(:,31,1)=M(:,1,2);
            Z = M(:,:,3);
            Z(:,31,1)=M(:,1,3);
            [F1, V1] = surf2patch(X, Y, Z, 'triangles');   

            M=CT2.beta_children{i_c}.beta_children{j}.surf0;
            X = M(:,:,1);
            X(:,31,1)=M(:,1,1);
            Y = M(:,:,2);
            Y(:,31,1)=M(:,1,2);
            Z = M(:,:,3);
            Z(:,31,1)=M(:,1,3);
            [F2, V2] = surf2patch(X, Y, Z, 'triangles');   
            
        
            V2_shift = V2; 
            V2_shift(:,1) = V2_shift(:,1) + shiftX;
            %{
            % Example correspondences (1-to-1)
            size(V1,1)
            corr_idx2 =  randi([1 size(V1,1)], 1, 5);      % first 20 vertices correspond
            assignin('base', 'corr_idx2', corr_idx2);
        
            % Colors for spheres
            colors = jet(length(corr_idx2));
         
            
            p1 = trisurf(F1, V1(:,1), V1(:,2), V1(:,3), ...
                'FaceColor',[0.5 0.5 0.5],'EdgeColor','none','FaceAlpha',0.9);
            
            p2 = trisurf(F2, V2_shift(:,1), V2_shift(:,2), V2_shift(:,3), ...
                'FaceColor',[0.5 0.5 0.5],'EdgeColor','none','FaceAlpha',0.9);
            
           
            
            %% Plot spheres at corresponding vertices
            [sx, sy, sz] = sphere(20);   % sphere resolution
            radius = 0.015;
            
            for i = 1:length(corr_idx2)
                idx = corr_idx2(i);
            
                % Sphere on mesh 1
                surf( radius*sx + V1(idx,1), ...
                      radius*sy + V1(idx,2), ...
                      radius*sz + V1(idx,3), ...
                      'FaceColor', colors(i,:), 'EdgeColor','none' );
            
                % Sphere on mesh 2
                surf( radius*sx + V2_shift(idx,1), ...
                      radius*sy + V2_shift(idx,2), ...
                      radius*sz + V2_shift(idx,3), ...
                      'FaceColor', colors(i,:), 'EdgeColor','none' );
            end
            
            %% Draw correspondence lines
            for i = 1:length(corr_idx2)
                idx = corr_idx2(i);
            
                plot3( [V1(idx,1), V2_shift(idx,1)], ...
                       [V1(idx,2), V2_shift(idx,2)], ...
                       [V1(idx,3), V2_shift(idx,3)], ...
                       'Color', colors(i,:), 'LineWidth', 2 );
            end
            %}
            for k=1:numel(CT.beta_children{i_c}.beta_children{j}.beta)
                    M=CT.beta_children{i_c}.beta_children{j}.surf{k}; %or CT.beta_children{i}.beta_children{j}.beta_children{k}.surf0
                    X = M(:,:,1);
                    X(:,31,1)=M(:,1,1);
                    Y = M(:,:,2);
                    Y(:,31,1)=M(:,1,2);
                    Z = M(:,:,3);
                    Z(:,31,1)=M(:,1,3);
                    [F1,V1] = surf2patch(X, Y, Z, 'triangles');
               
                    M=CT2.beta_children{i_c}.beta_children{j}.surf{k}; %or CT.beta_children{i}.beta_children{j}.beta_children{k}.surf0
                    X = M(:,:,1);
                    X(:,31,1)=M(:,1,1);
                    Y = M(:,:,2);
                    Y(:,31,1)=M(:,1,2);
                    Z = M(:,:,3);
                    Z(:,31,1)=M(:,1,3);
                    [F2,V2] = surf2patch(X, Y, Z, 'triangles');
                    
                     
        
                    V2_shift = V2; 
                    V2_shift(:,1) = V2_shift(:,1) + shiftX;
                    %{
                        % Example correspondences (1-to-1)
                        size(V1,1)
                        corr_idx3 =  randi([1 size(V1,1)], 1, 5);      % first 20 vertices correspond
                        assignin('base', 'corr_idx3', corr_idx3);
                    
                        % Colors for spheres
                        colors = jet(length(corr_idx3));
                        
                       
                        
                        p1 = trisurf(F1, V1(:,1), V1(:,2), V1(:,3), ...
                            'FaceColor',[0.5 0.5 0.5],'EdgeColor','none','FaceAlpha',0.9);
                        
                        p2 = trisurf(F2, V2_shift(:,1), V2_shift(:,2), V2_shift(:,3), ...
                            'FaceColor',[0.5 0.5 0.5],'EdgeColor','none','FaceAlpha',0.9);
                        
                       
                        
                        %% Plot spheres at corresponding vertices
                        [sx, sy, sz] = sphere(20);   % sphere resolution
                        radius = 0.015;;
                        
                        for i = 1:length(corr_idx3)
                            idx = corr_idx3(i);
                        
                            % Sphere on mesh 1
                            surf( radius*sx + V1(idx,1), ...
                                  radius*sy + V1(idx,2), ...
                                  radius*sz + V1(idx,3), ...
                                  'FaceColor', colors(i,:), 'EdgeColor','none' );
                        
                            % Sphere on mesh 2
                            surf( radius*sx + V2_shift(idx,1), ...
                                  radius*sy + V2_shift(idx,2), ...
                                  radius*sz + V2_shift(idx,3), ...
                                  'FaceColor', colors(i,:), 'EdgeColor','none' );
                        end
                        
                        %% Draw correspondence lines
                        for i = 1:length(corr_idx3)
                            idx = corr_idx3(i);
                        
                            plot3( [V1(idx,1), V2_shift(idx,1)], ...
                                   [V1(idx,2), V2_shift(idx,2)], ...
                                   [V1(idx,3), V2_shift(idx,3)], ...
                                   'Color', colors(i,:), 'LineWidth', 2 );
                        end
                    %}
                     end
                    
            end


    end
hold off
axis off
 lighting gouraud; camlight headlight;

end
