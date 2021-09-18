%%                      HW #2 -- MATLAB ASSIGNMENT                  
%__________________________________________________________________________
% 
%                        Structural Analysis II
% 
%    step-by-step MATLAB assignments by SHAHROKH SHAHI (www.sshahi.com)
%__________________________________________________________________________
% 
% NAME:       <Your First Name, Your Last Name>
% GT Account: <Your GT Account> 

%% Initialization
clc                % Clear Command Window
clear              % Delete all variables from workspace (if there is any)
close all          % Close all figures (if there is any)

format short g     % Set Command Window output display format:
                   % (short g: Short, fixed-decimal format or scientific notation, 
                   %  whichever is more compact, with a total of 5 digits.)
                                     
%% Interpreting an Input File

inputFileName = 'input.txt';


% Opening the input file:
inp = fopen(inputFileName,'r');

%--------------------------------------------------------------------------
%       R E A D I N G     G E N E R A L      I N F O R M A T I O N
%--------------------------------------------------------------------------
data         = fscanf(inp,'%f',2); 
nNode        = data(1);              
nElem        = data(2);

% data         = ...
% X            = data(:,2);
% Y            = data(:,3);
% coordinates  = [X, Y];
% rx           = ...
% ry           = ...
% fx           = ...
% fy           = ...

% data         = ...;
% FirstNode    = data(:,2);
% SecondNode   = data(:,3);
% elements     = [FirstNode, SecondNode];
% E            = ...
% A            = ...


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
