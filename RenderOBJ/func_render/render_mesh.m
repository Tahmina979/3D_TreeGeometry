% 2018-10-17: rendering a mesh, using **gptoolbox**
% 'MeshVtxColor':
%       same as 'FaceVertexCData', n-by-1 or n-by-3 matrix
%       note that, if we want to add the isolines (i.e., set IfPlotIsolines to true)
%       this needs to be a n-by-1 vector (a scalar function to find the isolines)
% 'LightPos': the 3D position of the light
% 'CameraPos': the position of the camera/view
% 'BackgroundColor': the background color
% 'RotationOps': a cell of rotation vectors (apply the rotations in a seq)
% 'VecField': vector field
function [t,X, S_new] = render_mesh(S,varargin)
default_param = load_MeshPlot_default_params(S);
param = parse_MeshPlot_params(default_param, varargin{:});

X = param.VtxPos;
T = S.surface.TRIV;
f = param.MeshVtxColor;

if ~isempty(param.RotationOps)
    %center = mean(X);
    %X = X - center;
    for i = 1:length(param.RotationOps)
        R = param.RotationOps{i};
        X = X*rotx(R(1))*roty(R(2))*rotz(R(3));
    end
    %X = X + center;
end

% construct the rotated new mesh
if nargout > 2
    S_new = S;
    S_new.surface.VERT = X;
    S_new.surface.X = X(:,1);
    S_new.surface.Y = X(:,2);
    S_new.surface.Z = X(:,3);
end

% plot the mesh
t = trimesh(T, X(:,1), X(:,2), X(:,3),...
    'FaceColor',param.FaceColor,...
    'FaceAlpha',param.FaceAlpha,...
    'EdgeColor','none');
axis equal;  hold on;

    %xlim([-1.2,1.2]);    % Set x-axis limits
    %ylim([-1.2,2]);    % Set y-axis limits
    %zlim([0,2.5]);    % Set z-axis limits
    xlim([-1,10]);    % Set x-axis limits
    ylim([-1,1]);    % Set y-axis limits
    zlim([-0.5,2]);    % Set z-axis limits
view(param.CameraPos);

teal = [144 216 196]/255;
pink = [254 194 194]/255;
orange = [249,198,7]/255;

if ~isempty(param.VecField)
    error('enter')
    J = param.VecField;
    if size(J,1) == S.nv
        quiver3(X(:,1),X(:,2),X(:,3),J(:,1),J(:,2),J(:,3),'Color',[0.2,0.2,0.2],'LineWidth',0.6);
    elseif size(J,1) == S.nf
        T = S.surface.TRIV;
        Fc = (X(T(:,1),:) + X(T(:,2),:) + X(T(:,3),:))/3;
        quiver3(Fc(:,1),Fc(:,2),Fc(:,3),J(:,1),J(:,2),J(:,3),'Color',[0.5,0.3,0.3],'LineWidth',0.8);
    else
        error('Wrong: size of the vector field')
    end
end

set(t,'FaceColor','interp','FaceLighting','gouraud',...
    'FaceVertexCData',f);
set(t,'SpecularStrength',0.5,'DiffuseStrength',0.5,'AmbientStrength',0.5);


l = light('Position',param.LightPos);
bg_color = param.BackgroundColor;
set(gca,'Visible','on');
set(gcf,'Color','w');

% add isolines if MeshVtxColor is a scalar function
if param.IfPlotIsolines
    p = add_isolines(t,'LineWidth',0.8,'LineStyle','--');
end

% add the shadows
s = add_shadow(t,l,'Color',bg_color*0.8,'BackgroundColor',bg_color,'Fade','infinite');

end