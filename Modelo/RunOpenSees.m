%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%   CLASE 15            %%%%%
%%%%%   Prof: Hermes Ponce  %%%%%
%%%%%   Fecha: 27/10/2020   %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc; clear; close all;

Reloj = clock;                      % Nos devuelve un vector con la fecha y hora
Archivo_trabajo = pwd;              % Fijamos la carpeta actual de trabajo
diary off; 
delete('CommandWindows.txt');       % Eliminamos el fichero creado anteriormente
diary('CommandWindows.txt');        % Generamos un fichero que escribirá todo lo que aparezca en la ventana de comandos

%% EJECUTADOR DE OPENSEES
disp('Ejecutando OpenSees...')
disp(['Fecha de inicio: ',num2str(Reloj(3)),'/',num2str(Reloj(2)),'/',num2str(Reloj(1))])
disp(['Hora de inicio: ',num2str(Reloj(4)),':',num2str(Reloj(5))])

tic
!OpenSees_3.2.2 run.tcl        
Tiempo = toc;

fprintf('Tiempo de cálculo: %6.2f s\n',Tiempo)
diary off;                          % Cerramos el diario

%% VISUALIZADOR DE DATOS
addpath('PlotOpenSees')
Outputs='Frame';

% Ploteadores válidos para modelos 3D.

% PLOTEAMOS LA ESTRUCTURA SIN DEFORMAR
 [F, hfig] = plotOSElem('Nodes.tcl','FrameElem.tcl',[-12.1417,19.3439],[-100 5100 -1000 1000 -1 4000]);

% % PLOTEAMOS LA ESTRUCTURA DEFORMADA (en función del análisis realizado)
% [F, hfig] = plotOSDef('Nodes.tcl','FrameElem.tcl',...
% strcat(Outputs,'\Displacement\nodesdisp.out'),5,[0,0],[-1000 6000 -1000 1000 -1 4000]);
% 
% % CARGAMOS ARCHIVOS DE FUERZAS Y DESPLAZAMIENTOS
% cd('Frame\Beams')
% F1=load('ele1gp1force.out');
% D1=load('ele1gp1def.out');
% 
% F5=load('ele5gp1force.out');
% D5=load('ele5gp1def.out');
% 
% cd('..\Displacement')
% d=load('disp10.out');
% 
% cd('..\Reactions')
% R1=load('node1reac.out');
% R6=load('node6reac.out');
% 
% cd(Archivo_trabajo)
% 
% % CREAMOS GRÁFICAS
% fig1=figure();
% set(fig1,'position',[9 49 443 947])
% ax1 = subplot(211)
% plot(D1(:,1),F1(:,1))
% grid on
% title(ax1,sprintf('Ley axil-desplazamiento \n Elemento 1 - Sección 1 (Tracción)'))
% xlabel(ax1,'\it Desplazamientos (mm)')
% ylabel(ax1,'\it Axiles (N)')
% 
% ax2 = subplot(212)
% plot(D1(:,3),F1(:,3))
% grid on
% title(ax2,sprintf('Ley momento-curvatura \n Elemento 1 - Sección 1'))
% xlabel(ax2,'\it Curvaturas (1/mm)')
% ylabel(ax2,'\it Momentos (mmN)')
% 
% fig2=figure();
% set(fig2,'position',[462 48 492 947])
% ax3 = subplot(211)
% plot(D5(:,1),F5(:,1))
% grid on
% title(ax3,sprintf('Ley axil-desplazamiento \n Elemento 5 - Sección 1 (Compresión)'))
% xlabel(ax3,'\it Desplazamientos (mm)')
% ylabel(ax3,'\it Axiles (N)')
% 
% ax4 = subplot(212)
% plot(D5(:,3),F5(:,3))
% grid on
% title(ax4,sprintf('Ley momento-curvatura \n Elemento 5 - Sección 1'))
% xlabel(ax4,'\it Curvaturas (1/mm))')
% ylabel(ax4,'\it Momentos (mmN)')
% 
% 
% Q1 = F1(:,5)+F5(:,5);
% Q2 = R1(:,1)+R6(:,1);
% 
% fig3=figure();
% set(fig3,'position',[969 49 944 947])
% plot(d(:,1),-Q1)
% grid on
% title(sprintf('Curva de capacidad \n (Pushover)'))
% xlabel('\it Desplazamientos (mm))')
% ylabel('\it Cortante (N)')
% 
% 

