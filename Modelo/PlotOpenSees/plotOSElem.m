function [F, hfig] = plotOSElem(NodesFile,FrameFile,vista,axi)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           RESULTADO GRÁFICO DE ELEMENTOS EN OPENSEES
%
% Departamento de Ingeniería Mecánica
% Escuela Técnica Superior de Ingenieros Industriales de Madrid (UPM)
% Autor: David Galé Lamuela
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% NodesFile: archivo de definicón de nodos
% FrameFile: archivo de definición de vigas, si no existe poner ' '
% PlatesFile: archivo de definición de placas, si no existe poner ' '
% vista: ejemplot [0,90] (plano X-Y)
% axi: definición como vector Ej: [xmin xmax ymin ymax zmin zmax];

% Ejemplo:
% [F, hfig] = plotOSElem('Nodes.tcl','BeamElem.tcl',' ',[0,90],[-600 600 -900 900 0 1800]);


ndf=6;
%% Lectura de datos

%% Lectura de Nodes
% open data input
fid1 = fopen(NodesFile);
% Initialization
i = 0;
c = zeros(1,4); % Contadores necesarios
while ( ~feof(fid1) )   
    tline = fgetl(fid1);
    i = i+1; % lineas escaneadas
    if size(tline,2)>=3
        % read node matrix
    if (regexpi(tline(1,1:4), 'node')>0)
        c(1,1)=c(1,1)+1;
        tline=str2mat(tline);  % Convierte tline en matriz de letras
        node(c(1,1),:) = sscanf(tline(6:end), '%f %f %f', [1,4]);     
    end
    end
end

%% Lectura de FrameElement
if exist(FrameFile)>0
% open data input
fid2 = fopen(FrameFile);
% Initialization
i = 0;
c = zeros(1,4); % Contadores necesarios
while ( ~feof(fid2) )   
    tline = fgetl(fid2);
    i = i+1; % lineas escaneadas
    if size(tline,2)>=3
    if (regexpi(tline, 'element elasticBeamColumn')>0) 
        c(1,3)=c(1,3)+1;
        tline=str2mat(tline);  % Convierte tline en matriz de letras
        elemB(c(1,3),:) = sscanf(tline(26:end), '%f %f %f', [1,3]);  
    elseif (regexpi(tline, 'element nonlinearBeamColumn')>0) 
        c(1,3)=c(1,3)+1;
        tline=str2mat(tline);  % Convierte tline en matriz de letras
        elemB(c(1,3),:) = sscanf(tline(29:end), '%f %f %f', [1,3]); 
    elseif (regexpi(tline, 'element forceBeamColumn')>0) 
        c(1,3)=c(1,3)+1;
        tline=str2mat(tline);  % Convierte tline en matriz de letras
        elemB(c(1,3),:) = sscanf(tline(25:end), '%f %f %f', [1,3]);    
    elseif (regexpi(tline, 'element truss')>0) 
        c(1,3)=c(1,3)+1;
        tline=str2mat(tline);  % Convierte tline en matriz de letras
        elemB(c(1,3),:) = sscanf(tline(14:end), '%f %f %f', [1,3]);
    elseif (regexpi(tline, 'rigidLink beam ')>0) 
        c(1,3)=c(1,3)+1;
        tline=str2mat(tline);  % Convierte tline en matriz de letras
        elemB(c(1,3),2:3) = sscanf(tline(15:end), '%f %f', [1,2]);    
     elseif (regexpi(tline, 'rigidLink bar ')>0) 
        c(1,3)=c(1,3)+1;
        tline=str2mat(tline);  % Convierte tline en matriz de letras
        elemB(c(1,3),2:3) = sscanf(tline(14:end), '%f %f', [1,2]);    
    end 
    end
end
end

%% Creacion de vigas
if exist('elemB')>0
% Generación Ex,Ey,Ez y Edof para Vigas
nelemB=length(elemB);
ExB=zeros(nelemB,2);
EyB=zeros(nelemB,2);
for i=1:nelemB
    nd1=find(node(:,1)==elemB(i,2));
    nd2=find(node(:,1)==elemB(i,3));
    ExB(i,1)=node(nd1,2);
    ExB(i,2)=node(nd2,2);
    EyB(i,1)=node(nd1,3);
    EyB(i,2)=node(nd2,3); 
    if ndf == 3
        EdofB(i,:)=[elemB(i,1) 3*nd1-2 3*nd1-1 3*nd1 3*nd2-2 3*nd2-1 3*nd2];
    elseif ndf == 6 
        EzB(i,1)=node(nd1,4);
        EzB(i,2)=node(nd2,4);
        EdofB(i,:)=[elemB(i,1) 6*nd1-5 6*nd1-4 6*nd1-3 6*nd1-2 6*nd1-1 6*nd1 6*nd2-5 6*nd2-4 6*nd2-3 6*nd2-2 6*nd2-1 6*nd2];    
    end
end
end

%% Creacion de placas
% Generación Ex,Ey,Ez y Edof para Placas
if exist('elemP')>0
nelemP=size(elemP,1);
ExP=zeros(nelemP,2);
EyP=zeros(nelemP,2);
for i=1:nelemP
    nd1=elemP(i,2);
    nd2=elemP(i,3);
    nd3=elemP(i,4);
    nd4=elemP(i,5);
    ExP(i,1)=node(nd1,2);
    ExP(i,2)=node(nd2,2);
    ExP(i,3)=node(nd3,2);
    ExP(i,4)=node(nd4,2);
    EyP(i,1)=node(nd1,3);
    EyP(i,2)=node(nd2,3); 
    EyP(i,3)=node(nd3,3);
    EyP(i,4)=node(nd4,3);
    EzP(i,1)=node(nd1,4);
    EzP(i,2)=node(nd2,4);
    EzP(i,3)=node(nd3,4);
    EzP(i,4)=node(nd4,4);
    
    EdofP(i,:)=[elemP(i,1) 6*nd1-5 6*nd1-4 6*nd1-3 6*nd1-2 6*nd1-1 6*nd1 6*nd2-5 6*nd2-4 6*nd2-3 6*nd2-2 6*nd2-1 6*nd2 6*nd3-5 6*nd3-4 6*nd3-3 6*nd3-2 6*nd3-1 6*nd3 6*nd4-5 6*nd4-4 6*nd4-3 6*nd4-2 6*nd4-1 6*nd4];    
end
end

%% Visualización de resultados
hfig=figure();
% cd('PlotOS')
set(hfig,'Name','3D plot','Numbertitle','Off','Color','w','position',[60 60 1300 900]);
if exist(FrameFile)>0
myeldraw3(ExB,EyB,EzB,[2 1 1],elemB(:,1)); %Antes de deformarse
end

xmin=axi(1,1);
xmax=axi(1,2);
ymin=axi(1,3);
ymax=axi(1,4);
zmin=axi(1,5);
zmax=axi(1,6);

axis([xmin xmax ymin ymax zmin zmax])
view(vista)
grid
F(i) = getframe(hfig);

end







