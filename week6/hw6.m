%%                      HW #6 -- MATLAB ASSIGNMENT                  
%__________________________________________________________________________
% 
%                        Structural Analysis II
% 
%    step-by-step MATLAB assignments by SHAHROKH SHAHI (www.sshahi.com)
%__________________________________________________________________________
% 
% NAME:       <Your First Name, Your Last Name>
% GT Account: <Your GT Account> 
% 

%% Initialization
clc                % Clear Command Window
clear              % Delete all variables from workspace (if there is any)
close all          % Close all figures (if there is any)

format short g     % Set Command Window output display format:
                   % (short g: Short, fixed-decimal format or scientific notation, 
                   %  whichever is more compact, with a total of 5 digits.)
                                     
%% Interpreting an Input File

inputFileName = 'input.txt';
outputFileName= 'output.txt';

% Opening the input file:
inp = fopen(inputFileName,'r');
out = fopen(outputFileName,'w');

%--------------------------------------------------------------------------
%             R E A D I N G       I N P U T      D A T A 
%--------------------------------------------------------------------------
data         = fscanf(inp,'%f',2); 
nNode        = data(1);              
nElem        = data(2);

data         = (fscanf(inp,'%d %f %f %d %d %f %f',[7,nNode]))';
X            = data(:,2);
Y            = data(:,3);
coordinates  = [X, Y];
rx           = data(:,4);
ry           = data(:,5);
fx           = data(:,6);
fy           = data(:,7);

data         = (fscanf(inp,'%d %d %d %f %f',[5,nElem]))';
FirstNode    = data(:,2);
SecondNode   = data(:,3);
elements     = [FirstNode, SecondNode];
E            = data(:,4);
A            = data(:,5);

%--------------------------------------------------------------------------
%          D I S P L A Y I N G      I N P U T       D A T A 
%--------------------------------------------------------------------------
printSummary(1,  nNode,nElem,X,Y,fx,fy,rx,ry,FirstNode,SecondNode,E,A);
printSummary(out,nNode,nElem,X,Y,fx,fy,rx,ry,FirstNode,SecondNode,E,A);


%--------------------------------------------------------------------------
%     C A L C U L A T I N G      S T I F F N E S S      M A T R I C E S
%--------------------------------------------------------------------------

nDof = 2; % number of degrees of freedom per each node

% initialization
K = zeros(nDof*nNode);
L = zeros(nElem,1);
rotation  = zeros(2,4,nElem);
stiffness = zeros(4,4,nElem);

% loop over number of elements
for i = 1 : nElem
    % for element (i):
    
    node1 = elements(i,1);
    node2 = elements(i,2);
    
    a = coordinates(node1,1:2);  % start node coordinates [x1 y1]
    b = coordinates(node2,1:2);  % end node coordinates   [x2 y2]
    
    x1 = a(1);
    y1 = a(2);
    x2 = b(1);
    y2 = b(2);
          
    % calculating length
    L(i) = sqrt((x1 - x2).^2   +   (y1 - y2).^2);
    
    % local stiffness matrix
    k_bar = E(i)*A(i)/L(i)   *   [1 -1; -1 1];
    
    % transformation matrix
    c = (x2 - x1)/L(i);  % cos(t) = (x2 - x1)/L
    s = (y2 - y1)/L(i);  % sin(t) = (y2 - y1)/L   
    T = [c s 0 0; 0 0 c s];
    rotation(:,:,i) = T;  
    
    % element stiffness matrix in global coordinates:
    k = T' * k_bar * T; 
    stiffness(:,:,i) = k;
    
    % ------------------------ auxiliary ------------------------%
    % Displaying the calculated stiffness matrices
    fprintf('\n\nElement No. : %2d \n',i);
    fprintf('   >> Stiffness matrix in local coordinates (k_bar): \n')
    disp(k_bar)
    fprintf('   >> Transformation matrix (T): \n')
    disp(T)
    fprintf('   >> Stiffness matrix in global coordinates (k): \n')
    disp(k)
    % -----------------------------------------------------------%
    
    
    % Assembly Procedure
    index = [nDof*(node1-1)+1:nDof*node1,nDof*(node2-1)+1:nDof*node2];
    K(index,index) = K(index,index) + k ;
end
fprintf('\n\nAssembled stiffness matrix in global coordinates (K): \n')
disp(K)

% re-shaping matrix f to obtain the nodal force vector
f = [fx, fy];
R = reshape(f',1,nDof*nNode)';

% imposing boundary conditions & solving the system of equations
bc = [rx, ry];
bc = reshape(bc',1,nDof*nNode)';
bcIndex = find(bc==0);

totalDof  = 1 : nDof*nNode;
activeDof = setdiff(totalDof, bcIndex);

Kf = K(activeDof, activeDof);
Rf = R(activeDof);

d  = Kf\Rf;
u  = zeros(nDof*nNode, 1);
u(bcIndex)   = 0;
u(activeDof) = d;

% TODO: (a) calculating reaction forces
% reactionForces = ...



% calculating element internal forces and stresses
stress = zeros(nElem, 1);
axial  = zeros(nElem, 1);

for i = 1 : nElem
    
    T = rotation(:,:,i);
    k = stiffness(:,:,i);
    
    % TODO: (b) calculating internal forces and stresste
    %
    % internalForce = ...
    %  
    % stress(i) = ...
    %
    % axial(i)  = ...
    %
    %
    %
    %
end

% TODO: (c) displaying the results











fclose all;
%--------------------------------------------------------------------------
%                    S I M P L E       P L O T
%--------------------------------------------------------------------------
figure(1);cla;
axis equal
grid on
hold on
title ('Structural Analysis II - HW 2')
% nodes
plot(coordinates(:,1),coordinates(:,2),'rO','MarkerSize',10,'LineWidth',2);
% elements
line([coordinates(elements(:,1),1),coordinates(elements(:,2),1)]',...
     [coordinates(elements(:,1),2),coordinates(elements(:,2),2)]',...
     'Color','b','LineWidth',2);
 
% bounday conditions
bColor = '#0072BD';
fColor = 'None';
for i = 1 : nNode
    if rx(i) == 0
        plot (coordinates(i,1),coordinates(i,2),'>',...
             'MarkerSize',15,'LineWidth',2, ...
             'Color',bColor,'MarkerFaceColor',fColor);
    end
    if ry(i) == 0
        plot (coordinates(i,1),coordinates(i,2),'^',...
             'MarkerSize',15,'LineWidth',2, ...
             'Color',bColor,'MarkerFaceColor',fColor);
    end    
end

%--------------------------------------------------------------------------
%                    H E L P E R       F U N C T I O N S
%--------------------------------------------------------------------------

function printSummary(fid,nNode,nElem,X,Y,fx,fy,rx,ry,FirstNode,SecondNode,E,A)

fprintf(fid, '=============================================================\n');
fprintf(fid, 'A    S U M M A R Y    O F    T H E    I N P U T    M O D E L \n');
fprintf(fid, '=============================================================\n');
fprintf(fid, 'Control Variables: \n');
fprintf(fid, '   - Number of Nodes:    %4d \n' ,nNode);
fprintf(fid, '   - Number of Elements: %4d \n' ,nElem);
fprintf(fid, '-------------------------------------------------------------\n');
fprintf(fid, '\n\n');
fprintf(fid, '=============================================================\n');
fprintf(fid, '                   N O D A L       D A T A                   \n');
fprintf(fid, '=============================================================\n');
fprintf(fid, 'Node     Coordinates        Nodal Loads        Restraints    \n');
fprintf(fid, ' ID        X     Y          Fx       Fy          Rx   Ry     \n');
fprintf(fid, '-------------------------------------------------------------\n');
for i = 1 : nNode
    fprintf(fid, '%2d   %7.2f %7.2f    %10.3f   %10.3f   %1d   %1d \n',...
                  i,   X(i),   Y(i),  fx(i),    fy(i),   rx(i), ry(i));
end
fprintf(fid, '-------------------------------------------------------------\n');
fprintf(fid, '\n\n');
fprintf(fid, '=============================================================\n');
fprintf(fid, '                E L E M E N T S      D A T A                 \n');
fprintf(fid, '=============================================================\n');
fprintf(fid, 'Element         Nodes               Material Properties      \n');
fprintf(fid, ' ID          [1]     [2]             E              A        \n');
fprintf(fid, '-------------------------------------------------------------\n');
for i = 1 : nElem
    fprintf(fid, '%2d \t\t    %3d    %3d  \t\t  %10.3e   %10.5f  \n',...
                  i,   FirstNode(i),   SecondNode(i),    E(i),    A(i));
end
fprintf(fid, '=============================================================\n');

end