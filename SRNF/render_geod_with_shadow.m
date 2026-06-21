clc;
N =7;
figure('Color','w'); 
hold on;

% Read the first mesh to define width and margin
m1 = MESH_IO.read_shape(['geodn_on_neuron/1.obj']);
V  = m1.surface.VERT;
F1 = m1.surface.TRIV;

% Base width & margin (from the first mesh)
bb1    = [min(V); max(V)];
widthX = bb1(2,1) - bb1(1,1);
margin = 0.5 * widthX;

shiftX = 0;  % initialize horizontal placement

% ---- Lighting (for the visible mesh shading only) ----
% We'll use a directional "sun" later only for projection math (not a MATLAB light)
sceneLight = [ 0.6, -0.8, -0.5 ];  % +X (right) and -Z (down) → right-sided shadow on ground
sceneLight = sceneLight / norm(sceneLight); % normalize (optional but clean)

for i = 1:N
    m = MESH_IO.read_shape(['geodn_on_neuron/',num2str(i),'.obj']);
    V1 = m.surface.VERT;
    F1 = m.surface.TRIV;

    % ---- Place meshes side-by-side (shift in +X) ----
    V1_shift = V1;
    V1_shift(:,1) = V1_shift(:,1) + shiftX;

    % Ensure vertices are 3D
    if size(V1_shift,2) == 2
        V1_shift = [V1_shift, zeros(size(V1_shift,1),1)];
    end

    % ---- Ground plane at the lowest Z of THIS mesh ----
    
    yPlane = min(V1_shift(:,2));

    % Angle phi is in the XZ-plane: 0° = +X, 90° = +Z, 180° = -X, -90° = -Z
    phi_deg = 60;        % try -20, -30, -45 to push “back” along -Z or +Z as you desire
    phi = deg2rad(phi_deg);
    
    xy_mag =0.8;         % how much to spread in XZ (increase for longer/wider shadow)
    Ly     = -0.8;        % negative Y so it projects to the Y-plane
    L = [xy_mag*cos(phi), Ly, xy_mag*sin(phi)];
    
    % Optional: normalize for cleaner scaling (not required)
    L = L / norm(L);
    Ly = L(2);            % refresh after normalization

    t = (yPlane - V1_shift(:,2)) / Ly;
    Vshadow = V1_shift + t .* L;
    Vshadow(:,2) = Vshadow(:,2) - 1e-6;  % epsilon in Y

    % ---- (Optional) draw a simple ground strip under each mesh for context ----
    % This is only to "see" the ground; it’s not required for the shadow to work.
    % Compute local ground extent along X and Y from the mesh bbox:
    bb_local = [min(V1_shift); max(V1_shift)];
    gx0 = bb_local(1,1) - 0.10*widthX;
    gx1 = bb_local(2,1) + 0.10*widthX;
    gy0 = bb_local(1,2) - 0.15*(bb_local(2,2)-bb_local(1,2));
    gy1 = bb_local(1,2) + 0.15*(bb_local(2,2)-bb_local(1,2));
    groundX = [gx0 gx1 gx1 gx0]';
    groundY = [gy0 gy0 gy1 gy1]';
    groundZ = yPlane*ones(4,1);
 

    % ---- Draw shadow (semi-transparent, dark) BEFORE the mesh ----
    patch('Faces',F1,'Vertices',Vshadow, ...
          'FaceColor',[0 0 0], 'EdgeColor','none', ...
          'FaceAlpha',0.15,'FaceLighting','none', 'Clipping','off');               % adjust 0.15–0.35 for taste

    % ---- Draw the actual mesh ----
    c = [0.45 0.45 0.45];
    patch('Faces',F1,'Vertices',V1_shift, ...
          'FaceColor',c, 'EdgeColor','none');
    %if i>6
       %shiftX = i*widthX + i*margin;
    %else
    % Update placement for next mesh
    shiftX = i*widthX;%+ i*margin;
    %end
end

axis equal off
light('Position',[0 0 1], 'Style','infinite');  % affects only mesh shading, not our projection math
lighting phong;

view(0, 70);               % <- your working az/el
camproj('perspective');     % optional: perspective can make shadows 
  
